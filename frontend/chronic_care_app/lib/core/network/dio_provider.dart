import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/token_storage.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    headers: {"Content-Type": "application/json"},
  ),
);

Future<void> setupDio() async {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();

        print("TOKEN:");
        print(token);

        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }

        handler.next(options);
      },
    ),
  );
}
