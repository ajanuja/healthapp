import '../../../core/network/dio_provider.dart';

class DoctorService {
  Future<List<dynamic>> getPatients() async {
    final response = await dio.get("/doctor/patients");

    return response.data["data"];
  }

  Future<Map<String, dynamic>> getPatientReport({
    required String patientId,
    required String startDate,
    required String endDate,
  }) async {
    final response = await dio.get(
      "/doctor/patients/$patientId/report",
      queryParameters: {"startDate": startDate, "endDate": endDate},
    );

    return response.data["data"];
  }

  Future<Map<String, dynamic>> searchPatient(String email) async {
    final response = await dio.get(
      "/doctor/search-patient",
      queryParameters: {"email": email},
    );

    return response.data["data"];
  }

  Future<void> assignPatient(String patientId) async {
    await dio.post("/doctor/assign-patient", data: {"patientId": patientId});
  }

  Future<void> prescribeMedicine({
    required String patientId,
    required String medicineName,
    required String dosage,
    required String frequency,
    required String reminderTime,
    required String instructions,
    required String startDate,
    required String endDate,
  }) async {
    await dio.post(
      "/doctor/patients/$patientId/medicines",
      data: {
        "medicine_name": medicineName,
        "dosage": dosage,
        "frequency": frequency,
        "reminder_time": reminderTime,
        "instructions": instructions,
        "start_date": startDate,
        "end_date": endDate,
      },
    );
  }

  Future<List<dynamic>> getPatientVitals(String patientId) async {
    final response = await dio.get("/doctor/patients/$patientId/vitals");

    return response.data["data"];
  }
}
