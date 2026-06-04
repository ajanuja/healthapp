import 'package:dio/dio.dart';

class AppointmentService {
  final Dio dio;

  AppointmentService(this.dio);

  Future<void> createAppointment({
    required String patientId,
    required String appointmentDate,
    required String appointmentTime,
    required String notes,
  }) async {
    await dio.post(
      "/appointments/doctor/$patientId",
      data: {
        "appointment_date": appointmentDate,
        "appointment_time": appointmentTime,
        "notes": notes,
      },
    );
  }

  Future<List> getDoctorAppointments() async {
    final response = await dio.get("/appointments/doctor");

    return response.data["data"];
  }

  Future<List> getPatientAppointments() async {
    final response = await dio.get("/appointments/patient");

    return response.data["data"];
  }
}
