import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/feed_post.dart';
import '../../../domain/repository/feed_repository.dart';
import '../../../domain/repository/like_repository.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required FeedRepository feedRepository,
    required LikeRepository likeRepository,
  }) : _feedRepository = feedRepository,
       _likeRepository = likeRepository,
       super(const FeedState());

  final FeedRepository _feedRepository;
  final LikeRepository _likeRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final posts = await _feedRepository.listFeed();
      emit(state.copyWith(isLoading: false, posts: posts));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> refresh() => load();

  Future<void> toggleLike(FeedPost post) async {
    if (state.isLikingPlanIds.contains(post.plan.id)) {
      return;
    }
    final nextLiked = !post.likedByMe;
    final nextCount = post.likeCount + (nextLiked ? 1 : -1);
    final previousPosts = state.posts;
    emit(
      state.copyWith(
        posts: _replacePost(
          post.plan.id,
          post.copyWith(
            likedByMe: nextLiked,
            likeCount: nextCount < 0 ? 0 : nextCount,
          ),
        ),
        isLikingPlanIds: {...state.isLikingPlanIds, post.plan.id},
      ),
    );

    try {
      if (nextLiked) {
        await _likeRepository.likePlan(post.plan.id);
      } else {
        await _likeRepository.unlikePlan(post.plan.id);
      }
      emit(
        state.copyWith(
          isLikingPlanIds: {...state.isLikingPlanIds}..remove(post.plan.id),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          posts: previousPosts,
          isLikingPlanIds: {...state.isLikingPlanIds}..remove(post.plan.id),
          error: error.toString(),
        ),
      );
    }
  }

  void incrementCommentCount(String planId) {
    FeedPost? post;
    for (final item in state.posts) {
      if (item.plan.id == planId) {
        post = item;
        break;
      }
    }
    if (post == null) {
      return;
    }
    emit(
      state.copyWith(
        posts: _replacePost(
          planId,
          post.copyWith(commentCount: post.commentCount + 1),
        ),
      ),
    );
  }

  List<FeedPost> _replacePost(String planId, FeedPost updated) {
    return state.posts
        .map((post) => post.plan.id == planId ? updated : post)
        .toList();
  }
}
