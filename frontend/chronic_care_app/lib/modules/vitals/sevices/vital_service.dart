import '../../../core/network/dio_provider.dart';

class VitalService {
  Future<void> addVital({
    required String vitalType,
    required String value,
    String? note,
  }) async {
    await dio.post(
      "/vitals",
      data: {"vital_type": vitalType, "value": value, "note": note},
    );
  }

  Future<List<dynamic>> getVitals() async {
    final response = await dio.get("/vitals");

    return response.data["data"];
  }

  Future<void> deleteVital(String vitalId) async {
    await dio.delete("/vitals/$vitalId");
  }

  Future<void> updateVital({
    required String vitalId,
    required String vitalType,
    required String value,
    String? note,
  }) async {
    await dio.put(
      "/vitals/$vitalId",
      data: {"vital_type": vitalType, "value": value, "note": note},
    );
  }
}
