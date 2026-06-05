import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/doctor_notes_provider.dart';

class AddEditNoteScreen extends ConsumerStatefulWidget {
  final String patientId;

  final String? noteId;

  final String? existingNote;

  final String? followUpDate;

  const AddEditNoteScreen({
    super.key,
    required this.patientId,
    this.noteId,
    this.existingNote,
    this.followUpDate,
  });

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  final noteController = TextEditingController();

  DateTime? followUpDate;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    noteController.text = widget.existingNote ?? "";

    if (widget.followUpDate != null) {
      followUpDate = DateTime.parse(widget.followUpDate!);
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        followUpDate = picked;
      });
    }
  }

  Future<void> saveNote() async {
    if (noteController.text.isEmpty) return;

    setState(() {
      loading = true;
    });

    try {
      final service = ref.read(doctorNotesServiceProvider);

      if (widget.noteId == null) {
        await service.addNote(
          patientId: widget.patientId,
          note: noteController.text,
          followUpDate: followUpDate?.toIso8601String(),
        );
      } else {
        await service.updateNote(
          noteId: widget.noteId!,
          note: noteController.text,
          followUpDate: followUpDate?.toIso8601String(),
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      print(e);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? "Add Note" : "Edit Note"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Doctor Note",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              title: Text(
                followUpDate == null
                    ? "Select Follow Up Date"
                    : followUpDate!.toString().split(" ")[0],
              ),

              trailing: const Icon(Icons.calendar_month),

              onTap: pickDate,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loading ? null : saveNote,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
