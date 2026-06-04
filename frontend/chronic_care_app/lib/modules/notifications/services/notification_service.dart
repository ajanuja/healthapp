import '../../../core/network/dio_provider.dart';

class NotificationService {
  Future<List<dynamic>> getNotifications() async {
    final response = await dio.get("/notifications");

    return response.data["data"];
  }

  Future<void> markAsRead(String notificationId) async {
    await dio.put("/notifications/$notificationId/read");
  }
}
