import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/doctor_provider.dart';

class PatientReportScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const PatientReportScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<PatientReportScreen> createState() =>
      _PatientReportScreenState();
}

class _PatientReportScreenState extends ConsumerState<PatientReportScreen> {
  bool loading = true;

  List medicines = [];
  List medicineLogs = [];
  List vitals = [];

  @override
  void initState() {
    super.initState();

    fetchReport();
  }

  Future<void> fetchReport() async {
    try {
      final report = await ref
          .read(doctorServiceProvider)
          .getPatientReport(
            patientId: widget.patientId,
            startDate: "2025-01-01",
            endDate: "2030-12-31",
          );

      setState(() {
        medicines = report["medicines"];
        medicineLogs = report["medicineLogs"];
        vitals = report["vitals"];

        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),

        actions: [
          IconButton(
            icon: const Icon(Icons.note_alt),

            onPressed: () {
              context.push(
                "/doctor-notes",

                extra: {
                  "patientId": widget.patientId,
                  "patientName": widget.patientName,
                },
              );
            },
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  sectionTitle("Medicines"),

                  ...medicines.map(
                    (medicine) => Card(
                      child: ListTile(
                        title: Text(medicine["medicine_name"] ?? ""),

                        subtitle: Text(medicine["dosage"] ?? ""),
                      ),
                    ),
                  ),

                  sectionTitle("Medicine Logs"),

                  ...medicineLogs.map(
                    (log) => Card(
                      child: ListTile(
                        title: Text(log["status"] ?? ""),

                        subtitle: Text(log["taken_at"] ?? ""),
                      ),
                    ),
                  ),

                  sectionTitle("Vitals"),

                  ...vitals.map(
                    (vital) => Card(
                      child: ListTile(
                        title: Text(vital["vital_type"] ?? ""),

                        subtitle: Text(vital["value"] ?? ""),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
