import 'package:zefeffete/domain/entities/vendor.dart';

class VendorModel extends Vendor {
  final double? averageRating;
  final int? totalReviews;
  final List<int>? starPercentages;

  VendorModel({
    required String email,
    String? username,
    String? phoneNumber,
    String? city,
    String? wilaya,
    String? gender,
    String? about,
    double? priceMin,
    double? priceMax,
    String? pricingDetails,
    String? theme,
    String? profilePicture,
    List<String>? images,
    String? category,
    bool activated = false,
    this.averageRating,
    this.totalReviews,
    this.starPercentages,
  }) : super(
          email: email,
          username: username,
          phoneNumber: phoneNumber,
          city: city,
          wilaya: wilaya,
          gender: gender,
          about: about,
          priceMin: priceMin,
          priceMax: priceMax,
          pricingDetails: pricingDetails,
          activated: activated,
          profilePicture: profilePicture,
          images: images,
          category: category,
        );

  Vendor toEntity() {
    return Vendor(
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      city: city,
      wilaya: wilaya,
      gender: gender,
      about: about,
      priceMin: priceMin,
      priceMax: priceMax,
      pricingDetails: pricingDetails,
      activated: activated,
      profilePicture: profilePicture,
      images: images,
      category: category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phone_number': phoneNumber,
      'city': city,
      'wilaya': wilaya,
      'gender': gender,
      'about': about,
      'price_min': priceMin,
      'price_max': priceMax,
      'pricing_details': pricingDetails,
      'activated': activated ? 1 : 0,
      'profile_picture': profilePicture,
      'images': images,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'star_percentages': starPercentages,
      'category': category
    };
  }

  static VendorModel fromMap(Map<String, dynamic> map) {
    return VendorModel(
      email: map['email'],
      username: map['username'],
      phoneNumber: map['phone_number'],
      city: map['city'],
      wilaya: map['wilaya'],
      gender: map['gender'],
      about: map['about'],
      priceMin: (map['price_min'] as num?)?.toDouble(),
      priceMax: (map['price_max'] as num?)?.toDouble(),
      pricingDetails: map['pricing_details'],
      theme: map['theme'],
      activated: map['activated'] == 1,
      profilePicture: map['profile_picture'],
      images:
          (map['images'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      averageRating: map['average_rating']?.toDouble(),
      totalReviews: map['total_reviews'],
      starPercentages: map['star_percentages'] != null
          ? List<int>.from(map['star_percentages'])
          : null,
      category: map['category'],
    );
  }
}
