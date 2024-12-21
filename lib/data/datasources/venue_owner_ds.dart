import 'package:zefeffete/core/utils/get_db_helper.dart';
import 'package:zefeffete/data/models/venue_owner_model.dart';
import 'package:zefeffete/data/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class VenueOwnerDataSource {
  final DBHelper _dbHelper = getDbHelper();

  Future<void> insertVenueOwner(VenueOwnerModel venueOwnerModel) async {
  print("Venue owner datasource: Adding venue_owner data...");

    final db = await _dbHelper.database;
    
    await db.insert(
      'venue_owner',  
      venueOwnerModel.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace,  
    );
    print("DataSource venue owner: Account saved successfully.");

  }

  Future<VenueOwnerModel?> getVenueOwnerByEmail(String email) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'venue_owner',  
      where: 'email = ?',  
      whereArgs: [email], 
    );

    if (maps.isNotEmpty) {
    
      return VenueOwnerModel.fromMap(maps.first);
    } else {
     
      return null;
    }
  }

  Future<void> deleteVenueOwner(String email) async {
    final db = await _dbHelper.database;

    await db.delete(
      'venue_owner',  
      where: 'email = ?', 
      whereArgs: [email], 
    );
  }
   Future<void> updateGender(String email, String gender) async {
    final db = await _dbHelper.database;
    await db.update(
      'venue_owner',
      {'gender': gender}, 
      where: 'email = ?',
      whereArgs: [email],  
    );
    }
}
