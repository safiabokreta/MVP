import 'package:zefeffete/domain/entities/account.dart';

class AccountModel extends Account {
  AccountModel({
    required super.email,
    required super.password,
    required super.username,
    super.profilePicture,
    super.theme,
    required super.role,
  });

  // Convert Model to Entity
  Account toEntity() {
    return Account(
      email: email,
      password: password,
      username: username,
      profilePicture: profilePicture,
      theme: theme,
      role: role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'profile_picture': profilePicture,
      'theme': theme,
      'role': role,
    };
  }

  static AccountModel fromMap(Map<String, dynamic> map) {
    return AccountModel(
      email: map['email'],
      password: map['password'],
      username: map['username'],
      profilePicture: map['profile_picture'],
      theme: map['theme'],
      role: map['role'],
    );
  }
}
