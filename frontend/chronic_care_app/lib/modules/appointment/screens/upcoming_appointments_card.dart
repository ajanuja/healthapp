import 'package:flutter/material.dart';

class UpcomingAppointmentsCard extends StatelessWidget {
  final List appointments;

  const UpcomingAppointmentsCard({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Upcoming Appointments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (appointments.isEmpty) const Text("No appointments scheduled"),

            ...appointments.take(5).map((appointment) {
              print(appointment);

              final patient =
                  appointment["patient"] ??
                  appointment["users_appointments_patient_idTousers"];

              return ListTile(
                contentPadding: EdgeInsets.zero,

                leading: const Icon(Icons.calendar_month),

                title: Text(patient["full_name"] ?? ""),

                subtitle: Text(appointment["appointment_date"].toString()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
