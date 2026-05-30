import 'package:equatable/equatable.dart';

import 'app_user.dart';
import 'plan.dart';

class FeedPost extends Equatable {
  const FeedPost({
    required this.plan,
    this.owner,
    this.commentCount = 0,
    this.likeCount = 0,
    this.likedByMe = false,
  });

  final Plan plan;
  final AppUser? owner;
  final int commentCount;
  final int likeCount;
  final bool likedByMe;

  FeedPost copyWith({
    Plan? plan,
    AppUser? owner,
    int? commentCount,
    int? likeCount,
    bool? likedByMe,
  }) {
    return FeedPost(
      plan: plan ?? this.plan,
      owner: owner ?? this.owner,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }

  @override
  List<Object?> get props => [plan, owner, commentCount, likeCount, likedByMe];
}
