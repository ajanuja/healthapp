import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List notifications = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final data = await ref
          .read(notificationServiceProvider)
          .getNotifications();

      setState(() {
        notifications = data;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await ref.read(notificationServiceProvider).markAsRead(id);

      await fetchNotifications();
    } catch (e) {
      print(e);
    }
  }

  IconData getNotificationIcon(String title) {
    if (title.toLowerCase().contains("missed")) {
      return Icons.medication;
    }

    if (title.toLowerCase().contains("doctor")) {
      return Icons.medical_services;
    }

    return Icons.notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : ListView.builder(
              itemCount: notifications.length,

              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(
                    leading: Icon(
                      getNotificationIcon(notification["title"] ?? ""),
                    ),

                    title: Text(notification["title"] ?? ""),

                    subtitle: Text(notification["message"] ?? ""),

                    trailing: notification["is_read"] == true
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : TextButton(
                            onPressed: () async {
                              await markAsRead(notification["id"]);
                            },

                            child: const Text("Mark Read"),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
