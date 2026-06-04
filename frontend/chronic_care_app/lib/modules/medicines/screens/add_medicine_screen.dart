import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/medicine_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final medicineController = TextEditingController();

  final dosageController = TextEditingController();

  final frequencyController = TextEditingController();

  final reminderController = TextEditingController();

  final startDateController = TextEditingController();

  final endDateController = TextEditingController();
  final instructionsController = TextEditingController();

  bool loading = false;

  Future<void> pickTime() async {
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

  Future<void> pickDate(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String().split("T")[0];

      setState(() {});
    }
  }

  Future<void> addMedicine() async {
    if (medicineController.text.isEmpty ||
        dosageController.text.isEmpty ||
        frequencyController.text.isEmpty ||
        reminderController.text.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }
    setState(() {
      loading = true;
    });

    try {
      final medicineService = ref.read(medicineServiceProvider);

      await medicineService.addMedicine(
        medicineName: medicineController.text,

        dosage: dosageController.text,

        frequency: frequencyController.text,

        reminderTime: reminderController.text,

        instructions: instructionsController.text,

        startDate: startDateController.text,

        endDate: endDateController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Medicine Added")));

      Navigator.pop(context);
    } catch (e) {
      print("ADD MEDICINE ERROR:");
      print(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add medicine")));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: medicineController,

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
              controller: startDateController,
              readOnly: true,
              onTap: () => pickDate(startDateController),
              decoration: const InputDecoration(
                labelText: "Start Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: endDateController,
              readOnly: true,
              onTap: () => pickDate(endDateController),
              decoration: const InputDecoration(
                labelText: "End Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_month),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reminderController,
              readOnly: true,
              onTap: pickTime,
              decoration: const InputDecoration(
                labelText: "Reminder Time",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: instructionsController,

              maxLines: 3,

              decoration: const InputDecoration(
                labelText: "Instructions",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loading ? null : addMedicine,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save Medicine"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
