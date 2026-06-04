import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/vital_provider.dart';

class AddVitalScreen extends ConsumerStatefulWidget {
  const AddVitalScreen({super.key});

  @override
  ConsumerState<AddVitalScreen> createState() => _AddVitalScreenState();
}

class _AddVitalScreenState extends ConsumerState<AddVitalScreen> {
  final valueController = TextEditingController();
  final noteController = TextEditingController();

  String selectedVital = "BLOOD_PRESSURE";
  bool loading = false;

  final List<Map<String, String>> vitalTypes = const [
    {"value": "BLOOD_PRESSURE", "label": "Blood Pressure"},
    {"value": "BLOOD_SUGAR", "label": "Blood Sugar"},
    {"value": "WEIGHT", "label": "Weight"},
  ];

  Future<void> saveVital() async {
    setState(() => loading = true);

    try {
      await ref
          .read(vitalServiceProvider)
          .addVital(
            vitalType: selectedVital,
            value: valueController.text,
            note: noteController.text,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vital Saved Successfully")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to Save Vital")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vital")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedVital,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Vital Type",
              ),
              items: vitalTypes
                  .map(
                    (v) => DropdownMenuItem(
                      value: v["value"],
                      child: Text(v["label"]!),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedVital = value!);
              },
            ),
            const SizedBox(height: 16),

            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: "Value",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Note (Optional)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : saveVital,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save Vital"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
