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
  Future<List<AppNotification>> listNotifications() {
    return _apiClient.get(
      ApiUrl.notifications,
      parser: (json) => (json as List<dynamic>)
          .map(
            (item) => AppNotificationDto.fromJson(
              item as Map<String, dynamic>,
            ).toDomain(),
          )
          .toList(),
    );
  }

  @override
  Future<void> markRead(String notificationId) async {
    await _apiClient.patch(
      ApiUrl.notificationRead(notificationId),
      parser: (_) => null,
    );
  }
}
