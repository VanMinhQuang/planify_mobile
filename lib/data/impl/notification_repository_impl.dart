import '../../domain/models/app_notification.dart';
import '../../domain/repository/notification_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/app_notification_dto.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<AppNotification>> listNotifications() async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.notifications,
        parser: (json) => (json as List<dynamic>)
            .map(
              (item) => AppNotificationDto.fromJson(
                item as Map<String, dynamic>,
              ).toDomain(),
            )
            .toList(),
      );
      return result ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markRead(String notificationId) async {
    try {
      await _apiClient.patch(
        path: ApiUrl.notificationRead(notificationId),
        body: {},
        parser: (_) => null,
      );
    } catch (e) {
      rethrow;
    }
  }
}
