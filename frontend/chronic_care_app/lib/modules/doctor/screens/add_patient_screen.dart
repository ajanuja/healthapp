import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/doctor_provider.dart';

class AddPatientScreen extends ConsumerStatefulWidget {
  const AddPatientScreen({super.key});

  @override
  ConsumerState<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends ConsumerState<AddPatientScreen> {
  final emailController = TextEditingController();

  Map<String, dynamic>? patient;

  bool searching = false;

  bool assigning = false;

  Future<void> searchPatient() async {
    setState(() {
      searching = true;
    });

    try {
      final result = await ref
          .read(doctorServiceProvider)
          .searchPatient(emailController.text);

      setState(() {
        patient = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Patient not found")));
    }

    setState(() {
      searching = false;
    });
  }

  Future<void> assignPatient() async {
    if (patient == null) return;

    setState(() {
      assigning = true;
    });

    try {
      await ref.read(doctorServiceProvider).assignPatient(patient!["id"]);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Patient Assigned")));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      assigning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Patient")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Patient Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: searching ? null : searchPatient,

                child: const Text("Search"),
              ),
            ),

            const SizedBox(height: 24),

            if (patient != null)
              Card(
                child: ListTile(
                  title: Text(patient!["full_name"]),

                  subtitle: Text(patient!["email"]),

                  trailing: ElevatedButton(
                    onPressed: assigning ? null : assignPatient,

                    child: const Text("Assign"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
