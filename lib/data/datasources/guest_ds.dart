import 'package:zefeffete/data/models/guest_model.dart';
import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';

class GuestDataSource {
  static Future<List<Map<String, dynamic>>> getAllGuests() async {
    final dbHelper = DBHelper();
    final db = await dbHelper.database;
    return await db.query('guest');
  }

  static Future<List<Map<String, dynamic>>> getGuestsByWeddingOwner(
      String email) async {
    final dbHelper = DBHelper();
    final db = await dbHelper.database;
    return await db.query(
      'guest',
      where: 'wedding_owner_email = ?',
      whereArgs: [email],
    );
  }

  static Future<Map<String, dynamic>?> getGuestById(int guestId) async {
    final dbHelper = DBHelper();
    final db = await dbHelper.database;
    final result = await db.query(
      'guest',
      where: 'guest_id = ?',
      whereArgs: [guestId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> addGuest(Map<String, dynamic> guestData) async {
    final dbHelper = DBHelper();
    final db = await dbHelper.database;

    // Create a new map without modifying the original map
    final cleanedGuestData = Map<String, dynamic>.from(guestData);

    // Ensure 'guest_id' is removed to allow auto-increment
    cleanedGuestData.remove('guest_id');

    print(cleanedGuestData); // Debug print to confirm 'guest_id' is removed

    // Insert the cleaned data into the 'guest' table
    return await db.insert('guest', cleanedGuestData);
  }

  static Future<int> updateGuest(
      int guestId, Map<String, dynamic> updatedData) async {
    final dbHelper = DBHelper();
    final db = await dbHelper.database;
    return await db.update(
      'guest',
      updatedData,
      where: 'guest_id = ?',
      whereArgs: [guestId],
    );
  }

  static Future<int> deleteGuest(int guestId) async {
    final dbHelper = DBHelper();
    final db = await dbHelper.database;
    return await db.delete(
      'guest',
      where: 'guest_id = ?',
      whereArgs: [guestId],
    );
  }
}
