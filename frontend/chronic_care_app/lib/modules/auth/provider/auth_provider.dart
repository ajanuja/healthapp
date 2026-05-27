import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/auth_service.dart';

import '../../../core/storage/token_storage.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(false);

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    state = true;

    try {
      final response = await authService.login(
        email: email,
        password: password,
      );

      final token = response["data"]["token"];

      final role = response["data"]["user"]["role"];

      await TokenStorage.saveToken(token);

      state = false;

      return role;
    } catch (e) {
      print("LOGIN ERROR: $e");

      state = false;

      return null;
    }
  }

  //register method can be added here similarly
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String role,

    String? gender,
    int? age,
  }) async {
    state = true;

    try {
      final response = await authService.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        gender: gender,
        age: age,
      );

      final token = response["data"]["token"];

      await TokenStorage.saveToken(token);

      state = false;

      return true;
    } catch (e) {
      print("REGISTER ERROR: $e");

      state = false;

      return false;
    }
  }
}
