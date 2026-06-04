import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Dashboard")),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
