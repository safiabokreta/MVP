import 'package:zefeffete/core/utils/get_db_helper.dart';
import 'package:zefeffete/data/models/wedding_owner_model.dart';
import 'package:zefeffete/data/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class WeddingOwnerDataSource {
  // Reference to DBHelper singleton
  final DBHelper _dbHelper = getDbHelper();

  // Insert a wedding owner into the database
  Future<void> insertWeddingOwner(WeddingOwnerModel weddingOwnerModel) async {
  print("Wedding owner owner datasource: Adding wedding_owner data...");

    final db = await _dbHelper.database;
    
    await db.insert(
      'wedding_owner',  // Table name
      weddingOwnerModel.toMap(),  // Convert WeddingOwnerModel to a map
      conflictAlgorithm: ConflictAlgorithm.replace,  // Replace if a conflict happens
    );
    print("DataSource wedding owner: Account saved successfully.");

  }

  // Get a wedding owner by email
  Future<WeddingOwnerModel?> getWeddingOwnerByEmail(String email) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'wedding_owner',  // Table name
      where: 'email = ?',  // Condition to find the wedding owner by email
      whereArgs: [email],  // Argument to bind to the query
    );

    if (maps.isNotEmpty) {
      // If the wedding owner exists, convert the first record to a WeddingOwnerModel
      return WeddingOwnerModel.fromMap(maps.first);
    } else {
      // If no wedding owner was found, return null
      return null;
    }
  }

  // Delete a wedding owner by email
  Future<void> deleteWeddingOwner(String email) async {
    final db = await _dbHelper.database;

    await db.delete(
      'wedding_owner',  // Table name
      where: 'email = ?',  // Condition to delete wedding owner by email
      whereArgs: [email],  // Argument to bind to the query
    );
  }
}
