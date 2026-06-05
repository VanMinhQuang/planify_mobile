import 'package:equatable/equatable.dart';
import 'package:planify_mobile/domain/models/app_user.dart';

class ActivityEntry extends Equatable {
  const ActivityEntry({
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
  final AppUser? user;

  @override
  List<Object?> get props => [
    id,
    planId,
    action,
    userId,
    targetTitle,
    createdAt,
    user,
  ];
}
