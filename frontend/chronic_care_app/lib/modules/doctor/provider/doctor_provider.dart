import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/doctor_service.dart';

final doctorServiceProvider = Provider<DoctorService>((ref) {
  return DoctorService();
});
