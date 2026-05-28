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
