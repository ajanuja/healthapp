import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/doctor_notes_provider.dart';
import 'add_edit_note_screen.dart';

class DoctorNotesScreen extends ConsumerStatefulWidget {
  final String patientId;

  final String patientName;

  const DoctorNotesScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<DoctorNotesScreen> createState() => _DoctorNotesScreenState();
}

class _DoctorNotesScreenState extends ConsumerState<DoctorNotesScreen> {
  List notes = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final data = await ref
          .read(doctorNotesServiceProvider)
          .getPatientNotes(widget.patientId);

      setState(() {
        notes = data;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> deleteNote(String noteId) async {
    await ref.read(doctorNotesServiceProvider).deleteNote(noteId);

    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.patientName} Notes")),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditNoteScreen(patientId: widget.patientId),
            ),
          );

          if (result == true) {
            fetchNotes();
          }
        },
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notes.length,

              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(note["note"] ?? ""),

                    subtitle: Text(note["follow_up_date"] ?? ""),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),

                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditNoteScreen(
                                  patientId: widget.patientId,
                                  noteId: note["id"],
                                  existingNote: note["note"],
                                  followUpDate: note["follow_up_date"],
                                ),
                              ),
                            );

                            if (result == true) {
                              fetchNotes();
                            }
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete),

                          onPressed: () {
                            deleteNote(note["id"]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
