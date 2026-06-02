import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify_mobile/domain/models/models.dart';
import 'package:planify_mobile/domain/repository/repositories.dart';

part 'plan_detail_state.dart';

class PlanDetailCubit extends Cubit<PlanDetailState> {
  PlanDetailCubit({
    required PlanRepository planRepository,
    required CommentRepository commentRepository,
    required LikeRepository likeRepository,
    required FriendRepository friendRepository,
    required String? currentUserId,
  }) : _planRepository = planRepository,
       _commentRepository = commentRepository,
       _likeRepository = likeRepository,
       _friendRepository = friendRepository,
       _currentUserId = currentUserId,
       super(const PlanDetailState());

  final PlanRepository _planRepository;
  final CommentRepository _commentRepository;
  final LikeRepository _likeRepository;
  final FriendRepository _friendRepository;
  final String? _currentUserId;

  Future<void> load(String planId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final plan = await _planRepository.getPlan(planId);
      final canViewMemberContent =
          plan.ownerId == _currentUserId ||
          plan.memberUserIds.contains(_currentUserId);
      final commentsFuture = _commentRepository.listComments(planId);
      final friendsFuture = canViewMemberContent
          ? _friendRepository.listFriends()
          : Future<List<Friendship>>.value(const []);
      if (!canViewMemberContent) {
        final commentsPage = await commentsFuture;
        emit(
          state.copyWith(
            isLoading: false,
            plan: plan,
            tasks: const [],
            notes: const [],
            activity: const [],
            comments: commentsPage.items,
            commentsNextCursor: commentsPage.nextCursor,
            commentsHasNextPage: commentsPage.hasNextPage,
          ),
        );
        return;
      }

      final results = await Future.wait<dynamic>([
        _planRepository.listTasks(planId),
        _planRepository.listNotes(planId),
        _planRepository.listActivity(planId),
        commentsFuture,
        friendsFuture,
      ]);
      final tasksPage = results[0] as PagedResult<PlanTask>;
      final notesPage = results[1] as PagedResult<PlanNote>;
      final activityPage = results[2] as PagedResult<ActivityEntry>;
      final commentsPage = results[3] as PagedResult<PlanComment>;
      final friendships = results[4] as List<Friendship>;
      emit(
        state.copyWith(
          isLoading: false,
          plan: plan,
          tasks: tasksPage.items,
          tasksNextCursor: tasksPage.nextCursor,
          tasksHasNextPage: tasksPage.hasNextPage,
          notes: notesPage.items,
          notesNextCursor: notesPage.nextCursor,
          notesHasNextPage: notesPage.hasNextPage,
          activity: activityPage.items,
          activityNextCursor: activityPage.nextCursor,
          activityHasNextPage: activityPage.hasNextPage,
          comments: commentsPage.items,
          commentsNextCursor: commentsPage.nextCursor,
          commentsHasNextPage: commentsPage.hasNextPage,
          friends: _inviteableFriends(plan, friendships),
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, message: error.toString()));
    }
  }

  Future<void> refreshFriends() async {
    final plan = state.plan;
    if (plan == null || state.isLoadingFriends) {
      return;
    }
    emit(state.copyWith(isLoadingFriends: true));
    try {
      final friendships = await _friendRepository.listFriends();
      emit(
        state.copyWith(
          friends: _inviteableFriends(plan, friendships),
          isLoadingFriends: false,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoadingFriends: false, message: error.toString()));
    }
  }

  Future<void> loadMoreComments() async {
    final plan = state.plan;
    if (plan == null ||
        !state.commentsHasNextPage ||
        state.isLoadingMoreComments) {
      return;
    }
    emit(state.copyWith(isLoadingMoreComments: true));
    try {
      final page = await _commentRepository.listComments(
        plan.id,
        cursor: state.commentsNextCursor,
      );
      emit(
        state.copyWith(
          comments: [...state.comments, ...page.items],
          commentsNextCursor: page.nextCursor,
          commentsHasNextPage: page.hasNextPage,
          isLoadingMoreComments: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoadingMoreComments: false, message: error.toString()),
      );
    }
  }

  Future<void> loadMoreTasks() async {
    final plan = state.plan;
    if (plan == null || !state.tasksHasNextPage || state.isLoadingMoreTasks) {
      return;
    }
    emit(state.copyWith(isLoadingMoreTasks: true));
    try {
      final page = await _planRepository.listTasks(
        plan.id,
        cursor: state.tasksNextCursor,
      );
      emit(
        state.copyWith(
          tasks: [...state.tasks, ...page.items],
          tasksNextCursor: page.nextCursor,
          tasksHasNextPage: page.hasNextPage,
          isLoadingMoreTasks: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoadingMoreTasks: false, message: error.toString()),
      );
    }
  }

  Future<void> loadMoreNotes() async {
    final plan = state.plan;
    if (plan == null || !state.notesHasNextPage || state.isLoadingMoreNotes) {
      return;
    }
    emit(state.copyWith(isLoadingMoreNotes: true));
    try {
      final page = await _planRepository.listNotes(
        plan.id,
        cursor: state.notesNextCursor,
      );
      emit(
        state.copyWith(
          notes: [...state.notes, ...page.items],
          notesNextCursor: page.nextCursor,
          notesHasNextPage: page.hasNextPage,
          isLoadingMoreNotes: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoadingMoreNotes: false, message: error.toString()),
      );
    }
  }

  Future<void> loadMoreActivity() async {
    final plan = state.plan;
    if (plan == null ||
        !state.activityHasNextPage ||
        state.isLoadingMoreActivity) {
      return;
    }
    emit(state.copyWith(isLoadingMoreActivity: true));
    try {
      final page = await _planRepository.listActivity(
        plan.id,
        cursor: state.activityNextCursor,
      );
      emit(
        state.copyWith(
          activity: [...state.activity, ...page.items],
          activityNextCursor: page.nextCursor,
          activityHasNextPage: page.hasNextPage,
          isLoadingMoreActivity: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoadingMoreActivity: false, message: error.toString()),
      );
    }
  }

  Future<void> toggleLike() async {
    final plan = state.plan;
    if (plan == null || state.isLiking) {
      return;
    }
    final nextLiked = !plan.likedByMe;
    final nextCount = plan.likeCount + (nextLiked ? 1 : -1);
    final previousPlan = plan;
    emit(
      state.copyWith(
        plan: plan.copyWith(
          likedByMe: nextLiked,
          likeCount: nextCount < 0 ? 0 : nextCount,
        ),
        isLiking: true,
      ),
    );

    try {
      if (nextLiked) {
        await _likeRepository.likePlan(plan.id);
      } else {
        await _likeRepository.unlikePlan(plan.id);
      }
      emit(state.copyWith(isLiking: false));
    } catch (error) {
      emit(
        state.copyWith(
          plan: previousPlan,
          isLiking: false,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> addComment(String content, {String? parentCommentId}) async {
    final plan = state.plan;
    if (plan == null || content.trim().isEmpty || state.isPostingComment) {
      return;
    }
    emit(state.copyWith(isPostingComment: true));
    try {
      final comment = await _commentRepository.createComment(
        plan.id,
        content.trim(),
        parentCommentId: parentCommentId,
      );
      final comments = parentCommentId == null
          ? [...state.comments, comment]
          : _addReply(parentCommentId, comment);
      emit(
        state.copyWith(
          plan: plan.copyWith(commentCount: plan.commentCount + 1),
          comments: comments,
          isPostingComment: false,
          replyingTo: null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isPostingComment: false, message: error.toString()));
    }
  }

  void setReplyingTo(PlanComment comment) {
    emit(state.copyWith(replyingTo: comment));
  }

  void clearReplyingTo() {
    emit(state.copyWith(replyingTo: null));
  }

  Future<void> toggleCommentLike(PlanComment comment) async {
    final plan = state.plan;
    if (plan == null) {
      return;
    }
    final nextLiked = !comment.likedByMe;
    final nextCount = comment.likeCount + (nextLiked ? 1 : -1);
    final updated = comment.copyWith(
      likedByMe: nextLiked,
      likeCount: nextCount < 0 ? 0 : nextCount,
    );
    final previousComments = state.comments;
    emit(state.copyWith(comments: _replaceComment(updated)));

    try {
      if (nextLiked) {
        await _commentRepository.likeComment(plan.id, comment.id);
      } else {
        await _commentRepository.unlikeComment(plan.id, comment.id);
      }
    } catch (error) {
      emit(
        state.copyWith(comments: previousComments, message: error.toString()),
      );
    }
  }

  List<PlanComment> _addReply(String parentCommentId, PlanComment reply) {
    return state.comments.map((comment) {
      if (comment.id != parentCommentId) {
        return comment;
      }
      return comment.copyWith(
        replies: [...comment.replies, reply],
        replyCount: comment.replyCount + 1,
      );
    }).toList();
  }

  List<PlanComment> _replaceComment(PlanComment updated) {
    return state.comments.map((comment) {
      if (comment.id == updated.id) {
        return updated;
      }
      return comment.copyWith(
        replies: comment.replies
            .map((reply) => reply.id == updated.id ? updated : reply)
            .toList(),
      );
    }).toList();
  }

  Future<void> addTask(String title) async {
    final plan = state.plan;
    if (plan == null || title.trim().isEmpty) {
      return;
    }
    final task = await _planRepository.createTask(plan.id, title.trim());
    emit(state.copyWith(tasks: [task, ...state.tasks]));
  }

  Future<void> toggleTask(PlanTask task) async {
    final updated = await _planRepository.updateTaskDone(
      task.planId,
      task.id,
      !task.isDone,
    );
    emit(
      state.copyWith(
        tasks: state.tasks
            .map((item) => item.id == updated.id ? updated : item)
            .toList(),
      ),
    );
  }

  Future<void> addNote(String content) async {
    final plan = state.plan;
    if (plan == null || content.trim().isEmpty) {
      return;
    }
    final note = await _planRepository.createNote(plan.id, content.trim());
    emit(state.copyWith(notes: [note, ...state.notes]));
  }

  Future<void> createInvite({String? inviteeId}) async {
    final plan = state.plan;
    if (plan == null || state.isCreatingInvite) {
      return;
    }
    emit(state.copyWith(isCreatingInvite: true, inviteUrl: null));
    try {
      final invite = await _planRepository.createInvite(
        plan.id,
        inviteeId: inviteeId,
      );
      final inviteUrl = invite['url'] as String?;
      emit(
        state.copyWith(
          isCreatingInvite: false,
          inviteUrl: inviteeId == null ? inviteUrl : null,
          message: inviteeId == null ? null : 'Invite sent',
        ),
      );
    } catch (error) {
      emit(state.copyWith(isCreatingInvite: false, message: error.toString()));
    }
  }

  List<AppUser> _inviteableFriends(Plan plan, List<Friendship> friendships) {
    final currentUserId = _currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      return const [];
    }
    final hiddenUserIds = {plan.ownerId, ...plan.memberUserIds};
    return friendships
        .where((friendship) => friendship.status == FriendshipStatus.accepted)
        .map((friendship) => _friendUser(friendship, currentUserId))
        .whereType<AppUser>()
        .where((user) => user.id.isNotEmpty && !hiddenUserIds.contains(user.id))
        .toList();
  }

  AppUser? _friendUser(Friendship friendship, String currentUserId) {
    if (friendship.requesterId == currentUserId) {
      return friendship.addressee;
    }
    if (friendship.addresseeId == currentUserId) {
      return friendship.requester;
    }
    return friendship.requester ?? friendship.addressee;
  }
}
