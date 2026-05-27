import 'package:dio/dio.dart';

import '../../../core/network/dio_provider.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("BASE URL:");
      print(dio.options.baseUrl);

      final response = await dio.post(
        "/auth/login",

        data: {"email": email, "password": password},
      );

      print("SUCCESS:");
      print(response.data);

      return response.data;
    } on DioException catch (e) {
      print("ERROR URL:");
      print(e.requestOptions.uri);

      print("STATUS:");
      print(e.response?.statusCode);

      print("RESPONSE:");
      print(e.response?.data);

      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,

    String? gender,
    int? age,
  }) async {
    final response = await dio.post(
      "/auth/register",

      data: {
        "full_name": fullName,
        "email": email,
        "password": password,
        "role": role,
        "gender": gender,
        "age": age,
      },
    );

    return response.data;
  }
}
