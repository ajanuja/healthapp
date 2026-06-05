import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/appointment_provider.dart';

class PatientAppointmentsScreen extends ConsumerStatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  ConsumerState<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState
    extends ConsumerState<PatientAppointmentsScreen> {
  bool loading = true;

  List appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final data = await ref
          .read(appointmentServiceProvider)
          .getPatientAppointments();

      setState(() {
        appointments = data;
        loading = false;
      });
    } catch (e) {
      print("APPOINTMENT ERROR:");
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  String formatDate(String? date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date);

      return "${parsed.day}/${parsed.month}/${parsed.year}";
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(child: Text("No Appointments Found"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                final doctor =
                    appointment["users_appointments_doctor_idTousers"];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          doctor?["full_name"] ?? "Doctor",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 18),

                            const SizedBox(width: 8),

                            Text(formatDate(appointment["appointment_date"])),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 18),

                            const SizedBox(width: 8),

                            Text(
                              appointment["appointment_time"]?.toString() ??
                                  "-",
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.info_outline, size: 18),

                            const SizedBox(width: 8),

                            Text(appointment["status"] ?? "SCHEDULED"),
                          ],
                        ),

                        if (appointment["notes"] != null &&
                            appointment["notes"].toString().isNotEmpty) ...[
                          const Divider(),

                          const Text(
                            "Notes",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(appointment["notes"]),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
