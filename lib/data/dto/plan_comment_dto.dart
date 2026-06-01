import '../../domain/models/plan_comment.dart';
import 'app_user_dto.dart';

class PlanCommentDto {
  const PlanCommentDto({
    required this.id,
    required this.planId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.replies = const [],
    this.likeCount = 0,
    this.replyCount = 0,
    this.likedByMe = false,
    this.user,
  });

  final String id;
  final String planId;
  final String userId;
  final String? parentId;
  final String content;
  final DateTime createdAt;
  final List<PlanCommentDto> replies;
  final int likeCount;
  final int replyCount;
  final bool likedByMe;
  final AppUserDto? user;

  factory PlanCommentDto.fromJson(Map<String, dynamic> json) {
    final count = json['_count'] as Map<String, dynamic>?;
    final likes = json['likes'] as List<dynamic>? ?? [];
    return PlanCommentDto(
      id: json['id'] as String,
      planId: json['planId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      parentId: json['parentId'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((item) => PlanCommentDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      likeCount: count?['likes'] as int? ?? 0,
      replyCount: count?['replies'] as int? ?? 0,
      likedByMe: likes.isNotEmpty,
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
      parentId: parentId,
      content: content,
      createdAt: createdAt,
      replies: replies.map((reply) => reply.toDomain()).toList(),
      likeCount: likeCount,
      replyCount: replyCount,
      likedByMe: likedByMe,
      user: user?.toDomain(),
    );
  }
}
