part of 'feed_cubit.dart';

class FeedState extends Equatable {
  const FeedState({
    this.isLoading = false,
    this.posts = const [],
    this.error = '',
    this.commentDraftByPlanId = const {},
    this.isLikingPlanIds = const {},
  });

  final bool isLoading;
  final List<FeedPost> posts;
  final String error;
  final Map<String, String> commentDraftByPlanId;
  final Set<String> isLikingPlanIds;

  FeedState copyWith({
    bool? isLoading,
    List<FeedPost>? posts,
    String? error,
    Map<String, String>? commentDraftByPlanId,
    Set<String>? isLikingPlanIds,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: error ?? this.error,
      commentDraftByPlanId: commentDraftByPlanId ?? this.commentDraftByPlanId,
      isLikingPlanIds: isLikingPlanIds ?? this.isLikingPlanIds,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    posts,
    error,
    commentDraftByPlanId,
    isLikingPlanIds,
  ];
}
