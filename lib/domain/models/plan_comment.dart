import 'package:equatable/equatable.dart';

import 'app_user.dart';

class PlanComment extends Equatable {
  const PlanComment({
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
  final List<PlanComment> replies;
  final int likeCount;
  final int replyCount;
  final bool likedByMe;
  final AppUser? user;

  PlanComment copyWith({
    String? id,
    String? planId,
    String? userId,
    String? parentId,
    String? content,
    DateTime? createdAt,
    List<PlanComment>? replies,
    int? likeCount,
    int? replyCount,
    bool? likedByMe,
    AppUser? user,
  }) {
    return PlanComment(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      likedByMe: likedByMe ?? this.likedByMe,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    id,
    planId,
    userId,
    parentId,
    content,
    createdAt,
    replies,
    likeCount,
    replyCount,
    likedByMe,
    user,
  ];
}
