import '../../domain/models/feed_post.dart';
import 'app_user_dto.dart';
import 'plan_dto.dart';

class FeedPostDto {
  const FeedPostDto({
    required this.plan,
    this.owner,
    this.commentCount = 0,
    this.likeCount = 0,
    this.likedByMe = false,
  });

  final PlanDto plan;
  final AppUserDto? owner;
  final int commentCount;
  final int likeCount;
  final bool likedByMe;

  factory FeedPostDto.fromJson(Map<String, dynamic> json) {
    final count = json['_count'] as Map<String, dynamic>?;
    final likes = json['likes'] as List<dynamic>? ?? [];
    return FeedPostDto(
      plan: PlanDto.fromJson(json),
      owner: json['owner'] == null
          ? null
          : AppUserDto.fromJson(json['owner'] as Map<String, dynamic>),
      commentCount: count?['comments'] as int? ?? 0,
      likeCount: count?['likes'] as int? ?? 0,
      likedByMe: likes.isNotEmpty,
    );
  }

  FeedPost toDomain() {
    return FeedPost(
      plan: plan.toDomain(),
      owner: owner?.toDomain(),
      commentCount: commentCount,
      likeCount: likeCount,
      likedByMe: likedByMe,
    );
  }
}
