import 'package:chronic_care_app/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/doctor_notes_service.dart';

final doctorNotesServiceProvider = Provider<DoctorNotesService>((ref) {
  return DoctorNotesService(dio);
});
