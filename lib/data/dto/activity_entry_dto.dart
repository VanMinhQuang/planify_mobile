import '../../domain/models/activity_entry.dart';

class ActivityEntryDto {
  const ActivityEntryDto({
    required this.id,
    required this.planId,
    required this.action,
    required this.userId,
    required this.createdAt,
    this.targetTitle,
  });

  final String id;
  final String planId;
  final String action;
  final String userId;
  final String? targetTitle;
  final DateTime createdAt;

  factory ActivityEntryDto.fromJson(Map<String, dynamic> json) {
    return ActivityEntryDto(
      id: json['id'] as String,
      planId: json['planId'] as String,
      action: json['action'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      targetTitle: json['targetTitle'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
    );
  }
}
