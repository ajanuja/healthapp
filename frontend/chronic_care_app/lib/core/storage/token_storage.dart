import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = "token";

  static const _roleKey = "role";

  // SAVE TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // SAVE ROLE
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  // GET ROLE
  static Future<String?> getRole() async {
    return await _storage.read(key: _roleKey);
  }

  // LOGOUT
  static Future<void> clearStorage() async {
    await _storage.deleteAll();
  }
}
