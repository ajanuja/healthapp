import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/doctor_provider.dart';

class PrescribeMedicineScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const PrescribeMedicineScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<PrescribeMedicineScreen> createState() =>
      _PrescribeMedicineScreenState();
}

class _PrescribeMedicineScreenState
    extends ConsumerState<PrescribeMedicineScreen> {
  final medicineNameController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final instructionsController = TextEditingController();

  final reminderController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  bool loading = false;

  Future<void> pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      reminderController.text =
          "${picked.hour.toString().padLeft(2, '0')}:"
          "${picked.minute.toString().padLeft(2, '0')}:00";

      setState(() {});
    }
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute:00";
  }

  Future<void> prescribeMedicine() async {
    if (medicineNameController.text.isEmpty ||
        dosageController.text.isEmpty ||
        frequencyController.text.isEmpty ||
        reminderController.text.isEmpty ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await ref
          .read(doctorServiceProvider)
          .prescribeMedicine(
            patientId: widget.patientId,
            medicineName: medicineNameController.text.trim(),
            dosage: dosageController.text.trim(),
            frequency: frequencyController.text.trim(),
            reminderTime: reminderController.text,
            instructions: instructionsController.text.trim(),
            startDate: startDate!.toIso8601String(),
            endDate: endDate!.toIso8601String(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicine prescribed successfully")),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      print("STATUS:");
      print(e.response?.statusCode);

      print("RESPONSE:");
      print(e.response?.data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data["message"] ?? "Failed")),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    medicineNameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prescribe for ${widget.patientName}")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: medicineNameController,
              decoration: const InputDecoration(
                labelText: "Medicine Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: dosageController,
              decoration: const InputDecoration(
                labelText: "Dosage",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: frequencyController,
              decoration: const InputDecoration(
                labelText: "Frequency",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reminderController,
              readOnly: true,
              onTap: pickReminderTime,
              decoration: const InputDecoration(
                labelText: "Reminder Time",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),

            const SizedBox(height: 10),

            ListTile(
              title: Text(
                startDate == null
                    ? "Select Start Date"
                    : "Start Date: ${startDate!.toLocal().toString().split(" ")[0]}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickStartDate,
            ),

            const SizedBox(height: 10),

            ListTile(
              title: Text(
                endDate == null
                    ? "Select End Date"
                    : "End Date: ${endDate!.toLocal().toString().split(" ")[0]}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickEndDate,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: instructionsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Instructions",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : prescribeMedicine,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Prescribe Medicine"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
