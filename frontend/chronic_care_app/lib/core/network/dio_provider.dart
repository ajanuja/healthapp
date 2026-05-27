import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,

    headers: {"Content-Type": "application/json"},
  ),
);
