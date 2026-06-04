import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/medicine_service.dart';

final medicineServiceProvider = Provider<MedicineService>((ref) {
  return MedicineService();
});

final medicineLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
