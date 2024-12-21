import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:zefeffete/core/utils/get_db_helper.dart';
import 'package:zefeffete/data/db/db_helper.dart';
import 'package:zefeffete/data/models/account_model.dart';
import 'package:sqflite/sqflite.dart';

class AccountDataSource {
  final DBHelper _dbHelper = getDbHelper();

  Future<void> insertAccount(AccountModel accountModel) async {
      print("DataSource: Saving account to database...");
      print(accountModel);
    final db = await _dbHelper.database;
    await db.insert(
      'account', 
      accountModel.toMap(), // Data to insert (convert AccountModel to Map)
      conflictAlgorithm: ConflictAlgorithm.replace, // Handling conflicts
    );
    print("DataSource: Account saved successfully.");
  }


Future<void> updateProfileImage(String email, String image) async {
  try {
    final db = await _dbHelper.database;

 

    // Prepare the data to update (AccountModel's fields)
    Map<String, dynamic> updatedData = {
      'profile_picture': image, // Store the base64 image string
    };

    int rowsAffected = await db.update(
      'account', // Table name
      updatedData, // Data to update
      where: 'email = ?', // Filter by email
      whereArgs: [email], // Email parameter to search for
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts
    );

    // Check if the update was successful
    if (rowsAffected > 0) {
      print("DataSource: Account updated successfully.");
    } else {
      print("DataSource: No account found with the provided email.");
    }
  } catch (e) {
    print("Error updating profile image: $e");
  }
}

  Future<void> updateUsername(String email, String username) async{
    final db = await _dbHelper.database;
    print("User datasource update called" + username +' '+ email);
    await db.update(
      'account',
      {'username': username},  
      where: 'email = ?',
      whereArgs: [email],  
    );
    print("User datasource update successful");

    
  }
  Future<AccountModel?> getAccountByEmail(String email) async {
    print("DataSource: Searching for account with email: $email");
    final db = await _dbHelper.database; // Get the database instance
    List<Map<String, dynamic>> result = await db.query(
      'account', // Table name
      where: 'email = ?', // Condition
      whereArgs: [email], // Arguments for the condition
    );

      print("DataSource: looking for email result$result");
    

    if (result.isNotEmpty) {
      return AccountModel.fromMap(result.first); // Convert map to AccountModel
    } else {
      return null; // No account found with that email
    }
  }

  Future<void> deleteAccount(String email) async {
    final db = await _dbHelper.database; // Get the database instance
    await db.delete(
      'account', // Table name
      where: 'email = ?', // Condition
      whereArgs: [email], // Arguments for the condition
    );
  }
}
