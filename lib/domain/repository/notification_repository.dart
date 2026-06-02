import '../models/app_notification.dart';
import '../models/paged_result.dart';

abstract interface class NotificationRepository {
  Future<PagedResult<AppNotification>> listNotifications({
    int limit = 20,
    String? cursor,
  });

  Future<void> markRead(String notificationId);
}
