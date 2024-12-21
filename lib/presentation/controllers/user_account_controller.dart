import 'dart:io';

import 'package:zefeffete/domain/entities/account.dart';
import 'package:zefeffete/domain/usecases/account/account_usecases.dart';

class AccountController {
  final AccountUserCases _useCases;

  AccountController(this._useCases);

  Future<void> addUser(Account User) async {
    await _useCases.insertAccount(User);
  }

  Future<Account?> getUserByEmail(String email) async {
    return await _useCases.getAccountByEmail(email);
  }

  Future<void> deleteUser(String email) async {
    await _useCases.deleteAccount(email);
  }

  Future<String> login(String email, String password) async {
    try {
      final result = await _useCases.login(email, password);
      return result; // return the result to be handled by the UI.
    } catch (e) {
      return "An unexpected error occurred."; // return error message
    }
  }

  Future<void> updateProfileImage(String email, File image) async {
    await _useCases.updateProfileImage(email, image.path);
  }

  Future<void> updateUsername(String email, String username) async {
    print("User controller update called" + username);
    await _useCases.updateUsername(email, username);
    return;
  }
}
