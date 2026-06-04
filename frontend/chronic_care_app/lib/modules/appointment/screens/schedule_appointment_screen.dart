import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/appointment_provider.dart';

class ScheduleAppointmentScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const ScheduleAppointmentScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState
    extends ConsumerState<ScheduleAppointmentScreen> {
  final notesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool loading = false;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  Future<void> scheduleAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time")),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final appointmentDate = selectedDate!.toIso8601String();

      final appointmentTime = DateTime(
        2025,
        1,
        1,
        selectedTime!.hour,
        selectedTime!.minute,
      ).toIso8601String();

      await ref
          .read(appointmentServiceProvider)
          .createAppointment(
            patientId: widget.patientId,
            appointmentDate: appointmentDate,
            appointmentTime: appointmentTime,
            notes: notesController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Appointment Scheduled")));

      Navigator.pop(context, true);
    } catch (e) {
      print("ERROR:");
      print(e);

      if (e is DioException) {
        print("STATUS:");
        print(e.response?.statusCode);

        print("RESPONSE:");
        print(e.response?.data);
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  String get formattedDate {
    if (selectedDate == null) return "Select Date";

    return "${selectedDate!.day}/"
        "${selectedDate!.month}/"
        "${selectedDate!.year}";
  }

  String get formattedTime {
    if (selectedTime == null) return "Select Time";

    return selectedTime!.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointment - ${widget.patientName}")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_month),

              title: Text(formattedDate),

              onTap: pickDate,
            ),

            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.access_time),

              title: Text(formattedTime),

              onTap: pickTime,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: notesController,

              maxLines: 4,

              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loading ? null : scheduleAppointment,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Schedule Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
