import '../../domain/models/app_notification.dart';

class AppNotificationDto {
  const AppNotificationDto({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;

  factory AppNotificationDto.fromJson(Map<String, dynamic> json) {
    return AppNotificationDto(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );
  }

  AppNotification toDomain() {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      readAt: readAt,
    );
  }
}
