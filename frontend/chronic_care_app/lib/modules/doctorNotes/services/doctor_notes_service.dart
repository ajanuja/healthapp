import 'package:dio/dio.dart';

class DoctorNotesService {
  final Dio dio;

  DoctorNotesService(this.dio);

  Future<List<dynamic>> getPatientNotes(String patientId) async {
    final response = await dio.get("/doctor/patients/$patientId/notes");

    return response.data["data"];
  }

  Future<void> addNote({
    required String patientId,
    required String note,
    String? followUpDate,
  }) async {
    await dio.post(
      "/doctor/patients/$patientId/notes",
      data: {"note": note, "follow_up_date": followUpDate},
    );
  }

  Future<void> updateNote({
    required String noteId,
    required String note,
    String? followUpDate,
  }) async {
    await dio.put(
      "/doctor/notes/$noteId",
      data: {"note": note, "follow_up_date": followUpDate},
    );
  }

  Future<void> deleteNote(String noteId) async {
    await dio.delete("/doctor/notes/$noteId");
  }
}
