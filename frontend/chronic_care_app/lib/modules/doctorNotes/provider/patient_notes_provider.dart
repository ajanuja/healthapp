import 'package:chronic_care_app/core/network/dio_provider.dart';
import 'package:chronic_care_app/modules/doctorNotes/services/patient_notes_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final patientNotesServiceProvider = Provider<PatientNotesService>((ref) {
  return PatientNotesService(dio);
});
