import 'package:zefeffete/data/models/vendor_model.dart';
import 'package:zefeffete/core/utils/get_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class VendorDataSource {
  final _dbHelper = getDbHelper();

  Future<bool> hasReview(String weddingOwnerEmail, String vendorEmail) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'vendor_review',
      where: 'wedding_owner_email = ? AND vendor_email = ?',
      whereArgs: [weddingOwnerEmail, vendorEmail],
    );
    return result.isNotEmpty;
  }

  Future<void> insertReview({
    required String weddingOwnerEmail,
    required String vendorEmail,
    required int reviewValue,
  }) async {
    final db = await _dbHelper.database;
    await db.insert(
      'vendor_review',
      {
        'wedding_owner_email': weddingOwnerEmail,
        'vendor_email': vendorEmail,
        'review_value': reviewValue,
      },
    );
  }

  Future<void> updateReview({
    required String weddingOwnerEmail,
    required String vendorEmail,
    required int reviewValue,
  }) async {
    final db = await _dbHelper.database;
    await db.update(
      'vendor_review',
      {'review_value': reviewValue},
      where: 'wedding_owner_email = ? AND vendor_email = ?',
      whereArgs: [weddingOwnerEmail, vendorEmail],
    );
  }

  Future<String?> _getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Email');
  }

  Future<VendorModel> getVendorDetailsByEmail(String email) async {
    final db = await _dbHelper.database;

    final vendorResult = await db.query(
      'vendor',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (vendorResult.isEmpty) {
      throw Exception('Vendor not found');
    }

    final vendorData = vendorResult.first;

    final accountResult = await db.query(
      'account',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (accountResult.isEmpty) {
      throw Exception('Account not found');
    }

    final accountData = accountResult.first;

    final imagesResult = await db.query(
      'vendor_image',
      where: 'vendor_email = ?',
      whereArgs: [email],
    );

    final images =
        imagesResult.map((image) => image['image_url'] as String).toList();

    final ratings = await _getVendorRatings(vendorData['email'].toString());

    return VendorModel(
      email: vendorData['email'] as String,
      username: accountData['username'] as String?,
      profilePicture: accountData['profile_picture'] as String?,
      phoneNumber: vendorData['phone_number'] as String?,
      city: vendorData['city'] as String?,
      wilaya: vendorData['wilaya'] as String?,
      gender: vendorData['gender'] as String?,
      about: vendorData['about'] as String?,
      priceMin: (vendorData['price_min'] as double?) ?? 0.0,
      priceMax: (vendorData['price_max'] as double?) ?? 0.0,
      pricingDetails: vendorData['pricing_details'] as String?,
      activated: vendorData['activated'] == 1,
      images: images ?? [],
      averageRating: ratings['average_rating'],
      totalReviews: ratings['total_reviews'],
      starPercentages: ratings['star_percentages'],
    );
  }

  Future<List<VendorModel>> getVendorsByCategory(String category) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT v.email, v.phone_number, v.city, a.profile_picture, a.username, v.category
    FROM vendor v
    JOIN account a ON v.email = a.email
    WHERE v.category = ? AND v.activated = 1
  ''', [category]);

    return results.map((map) => VendorModel.fromMap(map)).toList();
  }

  Future<Map<String, dynamic>> _getVendorRatings(String vendorEmail) async {
    final db = await _dbHelper.database;

    final reviews = await db.query(
      'vendor_review',
      where: 'vendor_email = ?',
      whereArgs: [vendorEmail],
    );

    if (reviews.isEmpty) {
      return {
        'average_rating': null,
        'total_reviews': 0,
        'star_percentages': [0, 0, 0, 0, 0]
      };
    }

    int totalReviews = reviews.length;
    int sumRatings = 0;
    List<int> starPercentages = [0, 0, 0, 0, 0];

    for (var review in reviews) {
      int rating = review['review_value'] as int;

      sumRatings += rating;
      starPercentages[rating - 1]++;
    }

    double averageRating = sumRatings / totalReviews;
    for (int i = 0; i < 5; i++) {
      starPercentages[i] = ((starPercentages[i] * 100) / totalReviews).toInt();
    }

    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'star_percentages': starPercentages,
    };
  }

  Future<List<VendorModel>> getFilteredVendors({
    required String category,
    double? minPrice,
    double? maxPrice,
    String? gender,
    double? minRating,
    Map<String, List<String>>? selectedLocations,
  }) async {
    final db = await _dbHelper.database;

    final List<String> whereClauses = ['v.category = ?'];
    final List<dynamic> whereArgs = [category];

    if (minPrice != null) {
      whereClauses.add('v.price_min >= ?');
      whereArgs.add(minPrice);
    }

    if (maxPrice != null) {
      whereClauses.add('v.price_max <= ?');
      whereArgs.add(maxPrice);
    }

    if (gender != null && gender != 'All') {
      whereClauses.add('v.gender = ?');
      whereArgs.add(gender);
    }

    if (minRating != null) {
      whereClauses.add(
          '(SELECT AVG(r.review_value) FROM vendor_review r WHERE r.vendor_email = v.email) >= ?');
      whereArgs.add(minRating);
    }

    if (selectedLocations != null &&
        selectedLocations.isNotEmpty &&
        selectedLocations != {}) {
      final List<String> wilayas = selectedLocations.keys.toList();

      if (wilayas.isNotEmpty) {
        final placeholders = List.filled(wilayas.length, '?').join(', ');
        whereClauses.add('v.wilaya IN ($placeholders)');
        whereArgs.addAll(wilayas);
      }
    }

    final whereClause = whereClauses.join(' AND ');

    final List<Map<String, dynamic>> results = await db.rawQuery('''
  SELECT v.email, v.phone_number, v.city, a.profile_picture, a.username, v.category, v.price_min, v.price_max, v.gender
  FROM vendor v
  JOIN account a ON v.email = a.email
  WHERE $whereClause AND v.activated = 1
  ''', whereArgs);

    return results.map((map) => VendorModel.fromMap(map)).toList();
  }

  Future<void> likeVendor(String vendorEmail) async {
    final currentUserEmail = await _getCurrentUserEmail();
    if (currentUserEmail != null) {
      final db = await _dbHelper.database;
      await db.insert(
        'liked_vendor',
        {
          'wedding_owner_email': currentUserEmail,
          'vendor_email': vendorEmail,
          'is_liked': 1
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> unlikeVendor(String vendorEmail) async {
    final currentUserEmail = await _getCurrentUserEmail();
    if (currentUserEmail != null) {
      final db = await _dbHelper.database;
      await db.delete(
        'liked_vendor',
        where: 'wedding_owner_email = ? AND vendor_email = ?',
        whereArgs: [currentUserEmail, vendorEmail],
      );
    }
  }

  Future<bool> isVendorLiked(String vendorEmail) async {
    final currentUserEmail = await _getCurrentUserEmail();
    if (currentUserEmail != null) {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query(
        'liked_vendor',
        where: 'wedding_owner_email = ? AND vendor_email = ? AND is_liked = 1',
        whereArgs: [currentUserEmail, vendorEmail],
      );
      return result.isNotEmpty;
    }
    return false;
  }

  Future<void> insertVendor(VendorModel vendorModel) async {
    print("vendor datasource: Adding vendor data...");

    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.insert(
        'vendor',
        vendorModel.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Replace if a conflict happens
      );
    });

    print("DataSource vendor: Account saved successfully.");
  }

  Future<void> insertImage(String vendorEmail, String imageUrl) async {
    final db = await _dbHelper.database;
    await db.insert(
      'vendor_image',
      {'vendor_email': vendorEmail, 'image_url': imageUrl},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get a vendor by email
  Future<VendorModel?> getVendorByEmail(String email) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'vendor',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return VendorModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<String>> getImagesByVendorEmail(String vendorEmail) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vendor_image',
      where: 'vendor_email = ?',
      whereArgs: [vendorEmail],
    );

    return List<String>.from(maps.map((map) => map['image_url']));
  }

  Future<void> deleteImagesByVendorEmail(
      String vendorEmail, String imageUrl) async {
    final db = await _dbHelper.database;
    await db.delete(
      'vendor_image',
      where: 'vendor_email = ? AND image_url = ?',
      whereArgs: [vendorEmail, imageUrl],
    );
  }

  // Activate vendor using a transaction
  Future<void> activateVendor(String email, VendorModel vendorModel) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        vendorModel.toMap(),
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Get vendor activation status
  Future<bool?> getVendorIsActivated(String email) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'vendor',
      columns: ['activated'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first['activated'] == 1;
    } else {
      return null;
    }
  }

  // Set vendor activation status using a transaction
  Future<bool> setVendorIsActivated(String email, bool isActivated) async {
    final db = await _dbHelper.database;

    int activatedValue = isActivated ? 1 : 0;

    int count = await db.transaction((txn) async {
      return await txn.update(
        'vendor',
        {'activated': activatedValue},
        where: 'email = ?',
        whereArgs: [email],
      );
    });

    return count > 0;
  }

  // Delete vendor using a transaction
  Future<void> deleteVendor(String email) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.delete(
        'vendor',
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor about field using a transaction
  Future<void> updateVendorAbout(String email, String about) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'about': about},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor category using a transaction
  Future<void> updateVendorCategory(String email, String category) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'category': category},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor gender using a transaction
  Future<void> updateVendorGender(String email, String gender) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'gender': gender},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor wilaya using a transaction
  Future<void> updateVendorWilaya(String email, String wilaya) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'wilaya': wilaya},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor city using a transaction
  Future<void> updateVendorCity(String email, String city) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'city': city},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor price max using a transaction
  Future<void> updateVendorPriceMax(String email, double price) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'price_max': price},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor price min using a transaction
  Future<void> updateVendorPriceMin(String email, double price) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'price_min': price},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }

  // Update vendor pricing details using a transaction
  Future<void> updateVendorPricingDetails(
      String email, String pricedetail) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        'vendor',
        {'pricing_details': pricedetail},
        where: 'email = ?',
        whereArgs: [email],
      );
    });
  }
}
