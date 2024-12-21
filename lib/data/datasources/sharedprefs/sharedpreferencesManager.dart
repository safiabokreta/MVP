import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._internal();

  SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance;
  }

  // Keys
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _emailKey = 'Email';
  static const String _roleKey = 'Role';
  static const String _usernameKey = 'Username';
  static const String _profileImageKey = 'ProfileImage';
  static const String _activatedKey =
      'NotActivated'; // Corrected to be a key for activation

  /// Save login status, email, role, username
  Future<void> setLoginStatus(
      bool status, String email, String role, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, status);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_usernameKey, username);
  }

  // Check login status
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Get email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  /// Get role
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Get username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<bool> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_usernameKey, username);
  }

  Future<String?> getActivated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activatedKey); // Default to false if null
  }

  /// Set activation status
  Future<void> setActivated(String activation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _activatedKey, activation); // Save the activation status
  }

  /// Save profile image (base64 encoded string or image URL)
  Future<void> setProfileImage(String base64Image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, base64Image);
  }

  /// Get profile image (base64 encoded string or image URL)
  Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  /// Clear all saved preferences
  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
