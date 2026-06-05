import 'package:chronic_care_app/modules/doctorNotes/provider/patient_notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientNotesScreen extends ConsumerStatefulWidget {
  const PatientNotesScreen({super.key});

  @override
  ConsumerState<PatientNotesScreen> createState() => _PatientNotesScreenState();
}

class _PatientNotesScreenState extends ConsumerState<PatientNotesScreen> {
  List notes = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      final data = await ref.read(patientNotesServiceProvider).getMyNotes();

      setState(() {
        notes = data;
        loading = false;
      });
    } catch (e) {
      print("NOTES ERROR:");
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Notes")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(
              child: Text("No notes yet", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(note["note"]),
                    subtitle: Text(
                      "Doctor: ${note["users_doctor_notes_doctor_idTousers"]["full_name"]}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
