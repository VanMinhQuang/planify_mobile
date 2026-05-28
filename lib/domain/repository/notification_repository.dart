import '../models/app_notification.dart';

abstract interface class NotificationRepository {
  Future<List<AppNotification>> listNotifications();

  Future<void> markRead(String notificationId);
}
