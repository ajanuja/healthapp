import 'package:dio/dio.dart';

import '../../../core/network/dio_provider.dart';

class MedicineService {
  Future<Map<String, dynamic>> addMedicine({
    required String medicineName,
    required String dosage,
    required String frequency,
    required String reminderTime,
    required String instructions,
    required String startDate,
    required String endDate,
  }) async {
    final response = await dio.post(
      "/medicines",

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

    return response.data;
  }
}
