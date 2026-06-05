import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.push("/notifications");
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Welcome 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // QUICK STATS PLACEHOLDER
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [Text("Today"), Text("Medicines")],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(children: [Text("Missed"), Text("Doses")]),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                context.push("/medicines");
              },
              child: const Text("View Medicines"),
            ),

            ElevatedButton(
              onPressed: () {
                context.push("/vitals");
              },
              child: const Text("View Vitals"),
            ),
            ElevatedButton(
              onPressed: () {
                context.push("/patient-notes");
              },

              child: const Text("Doctor Notes"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                context.push("/patient-appointments");
              },
              child: const Text("Appointments"),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text("Vital Trends"),
              onTap: () {
                context.push("/vital-trends");
              },
            ),
          ],
        ),
      ),
    );
  }
}
