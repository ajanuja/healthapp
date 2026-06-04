import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/medicine_log_provider.dart';

class MedicineHistoryScreen extends ConsumerStatefulWidget {
  final String medicineId;
  final String medicineName;

  const MedicineHistoryScreen({
    super.key,
    required this.medicineId,
    required this.medicineName,
  });

  @override
  ConsumerState<MedicineHistoryScreen> createState() =>
      _MedicineHistoryScreenState();
}

class _MedicineHistoryScreenState extends ConsumerState<MedicineHistoryScreen> {
  List logs = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final result = await ref
          .read(medicineLogServiceProvider)
          .getMedicineHistory(widget.medicineId);

      setState(() {
        logs = result;
        loading = false;
      });
    } catch (e) {
      print("HISTORY ERROR:");
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);

    return "${date.day}/${date.month}/${date.year}";
  }

  String formatTime(String dateString) {
    final date = DateTime.parse(dateString);

    final hour = date.hour > 12 ? date.hour - 12 : date.hour;

    final period = date.hour >= 12 ? "PM" : "AM";

    return "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.medicineName)),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
          ? const Center(child: Text("No history found"))
          : ListView.builder(
              itemCount: logs.length,

              itemBuilder: (context, index) {
                final log = logs[index];

                final status = log["status"];

                final isTaken = status == "TAKEN";

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(
                    leading: Icon(isTaken ? Icons.check_circle : Icons.cancel),

                    title: Text(status),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("Date: ${formatDate(log["taken_at"])}"),

                        Text("Time: ${formatTime(log["taken_at"])}"),

                        if (log["note"] != null) Text("Note: ${log["note"]}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
