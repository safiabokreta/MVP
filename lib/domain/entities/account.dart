import 'package:zefeffete/data/models/account_model.dart';

class Account {
  final String email;
  final String password;
  final String username;
  final String? profilePicture;
  final String? theme;
  final String role;

  Account({
    required this.email,
    required this.password,
    required this.username,
    this.profilePicture,
    this.theme,
    required this.role,
  });

  // Convert Entity to Model
  AccountModel toModel() {
    return AccountModel(
      email: email,
      password: password,
      username: username,
      profilePicture: profilePicture,
      theme: theme,
      role: role,
    );
  }
}
