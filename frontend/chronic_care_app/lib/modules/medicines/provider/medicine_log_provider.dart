import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/medicine_log_service.dart';

final medicineLogServiceProvider = Provider<MedicineLogService>((ref) {
  return MedicineLogService();
});
