import 'package:chronic_care_app/modules/vitals/sevices/vital_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vitalServiceProvider = Provider<VitalService>((ref) {
  return VitalService();
});
