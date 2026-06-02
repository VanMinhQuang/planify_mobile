part of 'feed_cubit.dart';

class FeedState extends Equatable {
  const FeedState({
    this.isLoading = false,
    this.posts = const [],
    this.error = '',
    this.commentDraftByPlanId = const {},
    this.isLikingPlanIds = const {},
    this.nextCursor,
    this.hasNextPage = false,
    this.isLoadingMore = false,
  });

  final bool isLoading;
  final List<FeedPost> posts;
  final String error;
  final Map<String, String> commentDraftByPlanId;
  final Set<String> isLikingPlanIds;
  final String? nextCursor;
  final bool hasNextPage;
  final bool isLoadingMore;

  FeedState copyWith({
    bool? isLoading,
    List<FeedPost>? posts,
    String? error,
    Map<String, String>? commentDraftByPlanId,
    Set<String>? isLikingPlanIds,
    Object? nextCursor = _unchanged,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: error ?? this.error,
      commentDraftByPlanId: commentDraftByPlanId ?? this.commentDraftByPlanId,
      isLikingPlanIds: isLikingPlanIds ?? this.isLikingPlanIds,
      nextCursor: nextCursor == _unchanged
          ? this.nextCursor
          : nextCursor as String?,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    posts,
    error,
    commentDraftByPlanId,
    isLikingPlanIds,
    nextCursor,
    hasNextPage,
    isLoadingMore,
  ];
}

const _unchanged = Object();
