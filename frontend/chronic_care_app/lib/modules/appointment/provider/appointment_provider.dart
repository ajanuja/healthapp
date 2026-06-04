import 'package:chronic_care_app/core/network/dio_provider.dart';
import 'package:chronic_care_app/modules/appointment/services/appointment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService(dio);
});
