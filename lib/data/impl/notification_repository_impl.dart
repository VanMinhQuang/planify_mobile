import '../../domain/models/app_notification.dart';
import '../../domain/models/paged_result.dart';
import '../../domain/repository/notification_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/app_notification_dto.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<PagedResult<AppNotification>> listNotifications({
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final result = await _apiClient.get(
        path: ApiUrl.notifications,
        queryParameters: {
          'limit': limit,
          ...?(cursor == null ? null : {'cursor': cursor}),
        },
        parser: (json) => PagedResult.fromJson(
          json,
          (item) => AppNotificationDto.fromJson(item).toDomain(),
        ),
      );
      return result ??
          const PagedResult(
            items: [],
            nextCursor: null,
            hasNextPage: false,
            totalCount: 0,
          );
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
