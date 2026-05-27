import '../../domain/models/app_notification.dart';
import '../api/api_client.dart';

class NotificationRepository {
  NotificationRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<AppNotification>> listNotifications() async {
    final response = await _apiClient.dio.get<List<dynamic>>('/notifications');
    return response.data!
        .map((item) => AppNotification.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> markRead(String notificationId) async {
    await _apiClient.dio.patch('/notifications/$notificationId/read');
  }
}
