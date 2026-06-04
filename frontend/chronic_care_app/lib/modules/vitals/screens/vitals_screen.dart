import 'package:chronic_care_app/modules/vitals/screens/edit_vital_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/vital_provider.dart';

class VitalsScreen extends ConsumerStatefulWidget {
  const VitalsScreen({super.key});

  @override
  ConsumerState<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends ConsumerState<VitalsScreen> {
  List vitals = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchVitals();
  }

  String formatVitalType(String type) {
    return type
        .replaceAll("_", " ")
        .toLowerCase()
        .split(" ")
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(" ");
  }

  Future<void> fetchVitals() async {
    try {
      final data = await ref.read(vitalServiceProvider).getVitals();

      setState(() {
        vitals = data;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> deleteVital(String vitalId) async {
    try {
      await ref.read(vitalServiceProvider).deleteVital(vitalId);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vital Deleted")));

      fetchVitals();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vitals"),

        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              context.push("/vital-trends");
            },
          ),
          IconButton(
            onPressed: () {
              context.push("/add-vital").then((_) => fetchVitals());
            },

            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vitals.length,

              itemBuilder: (context, index) {
                final vital = vitals[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(formatVitalType(vital["vital_type"])),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Value: ${vital["value"]}"),

                        Text("Note: ${vital["note"] ?? ""}"),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditVitalScreen(vital: vital),
                              ),
                            );

                            if (updated == true) {
                              fetchVitals();
                            }
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteVital(vital["id"]);
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
