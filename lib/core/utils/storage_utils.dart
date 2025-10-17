import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtils {
  static const _storage = FlutterSecureStorage();
  
  // Keys para el almacenamiento
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _refreshTokenKey = 'refresh_token';

  // Token methods
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Refresh token methods
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> removeRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // User ID methods
  static Future<void> saveUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  static Future<int?> getUserId() async {
    final userIdString = await _storage.read(key: _userIdKey);
    return userIdString != null ? int.tryParse(userIdString) : null;
  }

  static Future<void> removeUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // User email methods
  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  static Future<void> removeUserEmail() async {
    await _storage.delete(key: _userEmailKey);
  }

  // User role methods
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  static Future<void> removeUserRole() async {
    await _storage.delete(key: _userRoleKey);
  }

  // User session methods
  static Future<void> saveUserSession({
    required String token,
    required int userId,
    required String email,
    required String role,
    String? refreshToken,
  }) async {
    await Future.wait([
      saveToken(token),
      saveUserId(userId),
      saveUserEmail(email),
      saveUserRole(role),
      if (refreshToken != null) saveRefreshToken(refreshToken),
    ]);
  }

  static Future<Map<String, dynamic>?> getUserSession() async {
    final token = await getToken();
    final userId = await getUserId();
    final email = await getUserEmail();
    final role = await getUserRole();
    final refreshToken = await getRefreshToken();

    if (token != null && userId != null && email != null && role != null) {
      return {
        'token': token,
        'userId': userId,
        'email': email,
        'role': role,
        'refreshToken': refreshToken,
      };
    }
    return null;
  }

  // Clear all user data
  static Future<void> clearUserSession() async {
    await Future.wait([
      removeToken(),
      removeUserId(),
      removeUserEmail(),
      removeUserRole(),
      removeRefreshToken(),
    ]);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Check if user is driver
  static Future<bool> isDriver() async {
    final role = await getUserRole();
    return role?.toUpperCase() == 'DRIVER';
  }

  // Check if user is passenger
  static Future<bool> isPassenger() async {
    final role = await getUserRole();
    return role?.toUpperCase() == 'PASSENGER';
  }

  // Generic storage methods
  static Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> removeString(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Get all stored keys (for debugging)
  static Future<Map<String, String>> getAllStoredData() async {
    return await _storage.readAll();
  }
}