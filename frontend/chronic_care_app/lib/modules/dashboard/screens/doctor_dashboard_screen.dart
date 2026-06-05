import 'package:chronic_care_app/modules/appointment/provider/appointment_provider.dart';
import 'package:chronic_care_app/modules/appointment/screens/upcoming_appointments_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  List appointments = [];

  bool loadingAppointments = true;

  @override
  void initState() {
    super.initState();

    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      final data = await ref
          .read(appointmentServiceProvider)
          .getDoctorAppointments();

      setState(() {
        appointments = data;

        loadingAppointments = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loadingAppointments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Dashboard")),

      body: loadingAppointments
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  UpcomingAppointmentsCard(appointments: appointments),

                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text("My Patients"),
                    onTap: () {
                      context.push("/doctor-patients");
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
