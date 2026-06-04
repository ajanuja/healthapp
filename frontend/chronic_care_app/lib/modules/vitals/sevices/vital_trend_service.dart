import '../../../core/network/dio_provider.dart';

class VitalTrendService {
  Future<List<dynamic>> getVitals() async {
    final response = await dio.get("/vitals");
    return response.data["data"];
  }
}
