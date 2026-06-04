import 'package:chronic_care_app/modules/medicines/provider/medicine_log_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import 'package:go_router/go_router.dart';

class MedicineScreen extends ConsumerStatefulWidget {
  const MedicineScreen({super.key});

  @override
  ConsumerState<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends ConsumerState<MedicineScreen> {
  List medicines = [];
  bool loading = true;

  Set<String> takenToday = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await fetchMedicines();
    await fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      final logs = await ref.read(medicineLogServiceProvider).getLogs();

      final today = DateTime.now();

      final todayTaken = logs
          .where((log) {
            final takenDate = DateTime.parse(log["taken_at"]);

            return log["status"] == "TAKEN" &&
                takenDate.year == today.year &&
                takenDate.month == today.month &&
                takenDate.day == today.day;
          })
          .map((log) => log["medicine_id"].toString())
          .toSet();

      setState(() {
        takenToday = todayTaken;
      });
    } catch (e) {
      print("FETCH LOGS ERROR:");
      print(e);
    }
  }

  Future<void> markMedicineTaken(String medicineId) async {
    try {
      await ref.read(medicineLogServiceProvider).markMedicineTaken(medicineId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Medicine marked as taken")));

      await fetchMedicines();
      await fetchLogs();
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Something went wrong";

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to mark medicine")));
    }
  }

  Future<void> fetchMedicines() async {
    try {
      print("FETCHING MEDICINES");

      final response = await dio.get("/medicines");

      print(response.data);

      setState(() {
        medicines = response.data["data"];
        loading = false;
      });
    } catch (e) {
      print("FETCH ERROR:");
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Medicines"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push("/add-medicine").then((_) => fetchMedicines());
            },
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(med["medicine_name"]),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dosage: ${med["dosage"]}"),
                        Text("Frequency: ${med["frequency"]}"),
                        Text("Reminder: ${med["reminder_time"]}"),
                      ],
                    ),

                    trailing: takenToday.contains(med["id"])
                        ? const Chip(label: Text("✓ Taken Today"))
                        : ElevatedButton(
                            onPressed: () async {
                              await markMedicineTaken(med["id"]);
                            },

                            child: const Text("Taken"),
                          ),

                    onTap: () {
                      context.push(
                        "/medicine-history",
                        extra: {
                          "medicineId": med["id"],
                          "medicineName": med["medicine_name"],
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
