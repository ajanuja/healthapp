import 'package:dio/dio.dart';

class PatientNotesService {
  final Dio dio;

  PatientNotesService(this.dio);

  Future<List> getMyNotes() async {
    try {
      final response = await dio.get("/doctor/my-notes");

      return response.data["data"];
    } on DioException catch (e) {
      print("URL:");
      print(e.requestOptions.uri);

      print("STATUS:");
      print(e.response?.statusCode);

      print("DATA:");
      print(e.response?.data);

      rethrow;
    }
  }
}
