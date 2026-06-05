import '../../domain/models/activity_entry.dart';
import 'app_user_dto.dart';

class ActivityEntryDto {
  const ActivityEntryDto({
    required this.id,
    required this.planId,
    required this.action,
    required this.userId,
    required this.createdAt,
    this.targetTitle,
    this.user,
  });

  final String id;
  final String planId;
  final String action;
  final String userId;
  final String? targetTitle;
  final DateTime createdAt;
  final AppUserDto? user;

  factory ActivityEntryDto.fromJson(Map<String, dynamic> json) {
    return ActivityEntryDto(
      id: json['id'] as String,
      planId: json['planId'] as String,
      action: json['action'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      targetTitle: json['targetTitle'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: json['user'] is Map<String, dynamic>
          ? AppUserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  ActivityEntry toDomain() {
    return ActivityEntry(
      id: id,
      planId: planId,
      action: action,
      userId: userId,
      createdAt: createdAt,
      targetTitle: targetTitle,
      user: user?.toDomain(),
    );
  }
}
