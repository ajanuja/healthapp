import 'package:chronic_care_app/modules/vitals/sevices/vital_trend_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vitalTrendServiceProvider = Provider((ref) {
  return VitalTrendService();
});
