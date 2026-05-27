import 'package:equatable/equatable.dart';

class ActivityEntry extends Equatable {
  const ActivityEntry({
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

  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      id: json['id'] as String,
      planId: json['planId'] as String,
      action: json['action'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      targetTitle: json['targetTitle'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    planId,
    action,
    userId,
    targetTitle,
    createdAt,
  ];
}
