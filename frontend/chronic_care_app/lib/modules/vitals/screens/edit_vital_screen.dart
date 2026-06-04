import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../provider/vital_provider.dart';

class EditVitalScreen extends ConsumerStatefulWidget {
  final Map vital;

  const EditVitalScreen({super.key, required this.vital});

  @override
  ConsumerState<EditVitalScreen> createState() => _EditVitalScreenState();
}

class _EditVitalScreenState extends ConsumerState<EditVitalScreen> {
  late TextEditingController valueController;
  late TextEditingController noteController;

  late String selectedVital;
  bool loading = false;

  final List<Map<String, String>> vitalTypes = const [
    {"value": "BLOOD_PRESSURE", "label": "Blood Pressure"},
    {"value": "BLOOD_SUGAR", "label": "Blood Sugar"},
    {"value": "WEIGHT", "label": "Weight"},
  ];

  @override
  void initState() {
    super.initState();

    valueController = TextEditingController(text: widget.vital["value"] ?? "");
    noteController = TextEditingController(text: widget.vital["note"] ?? "");

    final dbValue = widget.vital["vital_type"]?.toString();

    // fallback safe
    if (vitalTypes.any((e) => e["value"] == dbValue)) {
      selectedVital = dbValue!;
    } else {
      selectedVital = "BLOOD_PRESSURE";
    }
  }

  Future<void> updateVital() async {
    setState(() => loading = true);

    try {
      await ref
          .read(vitalServiceProvider)
          .updateVital(
            vitalId: widget.vital["id"],
            vitalType: selectedVital,
            value: valueController.text,
            note: noteController.text,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vital updated successfully")),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data["message"] ?? "Update failed")),
      );
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    valueController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Vital")),
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
                labelText: "Note",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : updateVital,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Update Vital"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
