import '../../../core/network/dio_provider.dart';

class MedicineLogService {
  Future<void> markMedicineTaken(String medicineId) async {
    await dio.post(
      "/medicine-logs",
      data: {"medicine_id": medicineId, "status": "TAKEN"},
    );
  }

  Future<List<dynamic>> getLogs() async {
    final response = await dio.get("/medicine-logs");

    return response.data["data"];
  }

  Future<List<dynamic>> getMedicineHistory(String medicineId) async {
    final response = await dio.get("/medicine-logs/$medicineId");

    return response.data["data"];
  }
}
