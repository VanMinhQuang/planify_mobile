import '../../domain/models/plan_comment.dart';
import 'app_user_dto.dart';

class PlanCommentDto {
  const PlanCommentDto({
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
  final AppUserDto? user;

  factory PlanCommentDto.fromJson(Map<String, dynamic> json) {
    return PlanCommentDto(
      id: json['id'] as String,
      planId: json['planId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: json['user'] == null
          ? null
          : AppUserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  PlanComment toDomain() {
    return PlanComment(
      id: id,
      planId: planId,
      userId: userId,
      content: content,
      createdAt: createdAt,
      user: user?.toDomain(),
    );
  }
}
