import 'dart:io';

import 'package:zefeffete/data/datasources/sharedprefs/sharedpreferencesManager.dart';
import 'package:zefeffete/domain/entities/account.dart';
import 'package:zefeffete/domain/repositories/account_rep.dart';

class AccountUserCases {
  final AccountRepository _repository;

  AccountUserCases(this._repository);

  Future<void> insertAccount(Account account) async {
    try {
      print("Account Usecase: Inserting account into repo...");
      await _repository.insertAccount(account.toModel());
      print("Account UseCase: Account inserted successfully.");
    } catch (e) {
      print("Error in usecase: ${e.toString()}");
      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  Future<void> updateProfileImage(String email, String image) async {
    await _repository.updateProfileImage(email, image);
  }

  Future<Account?> getAccountByEmail(String email) async {
    // Fetch model from repository, transform to entity, and return
    final model = await _repository.getAccountByEmail(email);
    return model?.toEntity();
  }

  Future<void> deleteAccount(String email) async {
    // Call repository to delete
    await _repository.deleteAccount(email);
  }

  Future<String> login(String email, String password) async {
    try {
      print("UseCase: Attempting to find account with email: $email");

      final account = await _repository.getAccountByEmail(email);

      if (account != null) {
        print("UseCase: Account found: ${account.email}");
        if (account.password == password) {
          print("UseCase: Password matches, login successful");
          await SharedPreferencesManager().setLoginStatus(
            true,
            account.email,
            account.role,
            account.username,
          );
          return "Login successful";
        } else {
          print("UseCase: Incorrect password");
          return "Incorrect password";
        }
      } else {
        print("UseCase: Account not found for email: $email");
        return "Email not registered";
      }
    } catch (e) {
      print("UseCase error: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> updateUsername(String email, String username) async {
    print("User usescase update called" + username);

    await _repository.updateUsername(email, username);

    return "Update username successful";
  }
}
