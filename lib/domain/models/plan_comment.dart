import 'package:equatable/equatable.dart';

import 'app_user.dart';

class PlanComment extends Equatable {
  const PlanComment({
    required this.id,
    required this.planId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.user,
  });

  final String id;
  final String planId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final AppUser? user;

  @override
  List<Object?> get props => [id, planId, userId, content, createdAt, user];
}
