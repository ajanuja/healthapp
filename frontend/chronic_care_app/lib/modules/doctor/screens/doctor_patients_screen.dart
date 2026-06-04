import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/doctor_provider.dart';

class DoctorPatientsScreen extends ConsumerStatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  ConsumerState<DoctorPatientsScreen> createState() =>
      _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends ConsumerState<DoctorPatientsScreen> {
  List patients = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final data = await ref.read(doctorServiceProvider).getPatients();

      setState(() {
        patients = data;
        loading = false;
      });
    } catch (e) {
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
        title: const Text("My Patients"),

        actions: [
          IconButton(
            onPressed: () {
              context.push("/add-patient").then((_) {
                fetchPatients();
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : patients.isEmpty
          ? const Center(child: Text("No Patients Assigned"))
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];

                final user = patient["users_doctor_patients_patient_idTousers"];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(user["full_name"] ?? ""),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user["email"] ?? ""),
                        Text("Age: ${user["age"] ?? ""}"),
                        Text("Gender: ${user["gender"] ?? ""}"),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.medication),
                          onPressed: () {
                            context.push(
                              "/prescribe-medicine",
                              extra: {
                                "patientId": user["id"],
                                "patientName": user["full_name"],
                              },
                            );
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.calendar_month),

                          onPressed: () {
                            context.push(
                              "/schedule-appointment",
                              extra: {
                                "patientId": user["id"],
                                "patientName": user["full_name"],
                              },
                            );
                          },
                        ),

                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),

                    onTap: () {
                      context.push(
                        "/patient-report",
                        extra: {
                          "patientId": user["id"],
                          "patientName": user["full_name"],
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
