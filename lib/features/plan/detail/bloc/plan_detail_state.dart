part of 'plan_detail_cubit.dart';

class PlanDetailState extends Equatable {
  const PlanDetailState({
    this.isLoading = false,
    this.plan,
    this.tasks = const [],
    this.notes = const [],
    this.activity = const [],
    this.comments = const [],
    this.friends = const [],
    this.isLiking = false,
    this.isPostingComment = false,
    this.isLoadingFriends = false,
    this.isCreatingInvite = false,
    this.isLoadingMoreTasks = false,
    this.isLoadingMoreNotes = false,
    this.isLoadingMoreActivity = false,
    this.isLoadingMoreComments = false,
    this.commentsNextCursor,
    this.commentsHasNextPage = false,
    this.tasksNextCursor,
    this.tasksHasNextPage = false,
    this.notesNextCursor,
    this.notesHasNextPage = false,
    this.activityNextCursor,
    this.activityHasNextPage = false,
    this.replyingTo,
    this.inviteUrl,
    this.message,
  });

  final bool isLoading;
  final Plan? plan;
  final List<PlanTask> tasks;
  final List<PlanNote> notes;
  final List<ActivityEntry> activity;
  final List<PlanComment> comments;
  final List<AppUser> friends;
  final bool isLiking;
  final bool isPostingComment;
  final bool isLoadingFriends;
  final bool isCreatingInvite;
  final bool isLoadingMoreTasks;
  final bool isLoadingMoreNotes;
  final bool isLoadingMoreActivity;
  final bool isLoadingMoreComments;
  final String? commentsNextCursor;
  final bool commentsHasNextPage;
  final String? tasksNextCursor;
  final bool tasksHasNextPage;
  final String? notesNextCursor;
  final bool notesHasNextPage;
  final String? activityNextCursor;
  final bool activityHasNextPage;
  final PlanComment? replyingTo;
  final String? inviteUrl;
  final String? message;

  bool canViewMemberContent(String? userId) {
    final currentPlan = plan;
    if (currentPlan == null || userId == null || userId.isEmpty) {
      return false;
    }
    return currentPlan.ownerId == userId ||
        currentPlan.memberUserIds.contains(userId);
  }

  PlanDetailState copyWith({
    bool? isLoading,
    Plan? plan,
    List<PlanTask>? tasks,
    List<PlanNote>? notes,
    List<ActivityEntry>? activity,
    List<PlanComment>? comments,
    List<AppUser>? friends,
    bool? isLiking,
    bool? isPostingComment,
    bool? isLoadingFriends,
    bool? isCreatingInvite,
    bool? isLoadingMoreTasks,
    bool? isLoadingMoreNotes,
    bool? isLoadingMoreActivity,
    bool? isLoadingMoreComments,
    Object? commentsNextCursor = _unchanged,
    bool? commentsHasNextPage,
    Object? tasksNextCursor = _unchanged,
    bool? tasksHasNextPage,
    Object? notesNextCursor = _unchanged,
    bool? notesHasNextPage,
    Object? activityNextCursor = _unchanged,
    bool? activityHasNextPage,
    Object? replyingTo = _unchanged,
    Object? inviteUrl = _unchanged,
    String? message,
  }) {
    return PlanDetailState(
      isLoading: isLoading ?? this.isLoading,
      plan: plan ?? this.plan,
      tasks: tasks ?? this.tasks,
      notes: notes ?? this.notes,
      activity: activity ?? this.activity,
      comments: comments ?? this.comments,
      friends: friends ?? this.friends,
      isLiking: isLiking ?? this.isLiking,
      isPostingComment: isPostingComment ?? this.isPostingComment,
      isLoadingFriends: isLoadingFriends ?? this.isLoadingFriends,
      isCreatingInvite: isCreatingInvite ?? this.isCreatingInvite,
      isLoadingMoreTasks: isLoadingMoreTasks ?? this.isLoadingMoreTasks,
      isLoadingMoreNotes: isLoadingMoreNotes ?? this.isLoadingMoreNotes,
      isLoadingMoreActivity:
          isLoadingMoreActivity ?? this.isLoadingMoreActivity,
      isLoadingMoreComments:
          isLoadingMoreComments ?? this.isLoadingMoreComments,
      commentsNextCursor: commentsNextCursor == _unchanged
          ? this.commentsNextCursor
          : commentsNextCursor as String?,
      commentsHasNextPage: commentsHasNextPage ?? this.commentsHasNextPage,
      tasksNextCursor: tasksNextCursor == _unchanged
          ? this.tasksNextCursor
          : tasksNextCursor as String?,
      tasksHasNextPage: tasksHasNextPage ?? this.tasksHasNextPage,
      notesNextCursor: notesNextCursor == _unchanged
          ? this.notesNextCursor
          : notesNextCursor as String?,
      notesHasNextPage: notesHasNextPage ?? this.notesHasNextPage,
      activityNextCursor: activityNextCursor == _unchanged
          ? this.activityNextCursor
          : activityNextCursor as String?,
      activityHasNextPage: activityHasNextPage ?? this.activityHasNextPage,
      replyingTo: replyingTo == _unchanged
          ? this.replyingTo
          : replyingTo as PlanComment?,
      inviteUrl: inviteUrl == _unchanged
          ? this.inviteUrl
          : inviteUrl as String?,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    plan,
    tasks,
    notes,
    activity,
    comments,
    friends,
    isLiking,
    isPostingComment,
    isLoadingFriends,
    isCreatingInvite,
    isLoadingMoreTasks,
    isLoadingMoreNotes,
    isLoadingMoreActivity,
    isLoadingMoreComments,
    commentsNextCursor,
    commentsHasNextPage,
    tasksNextCursor,
    tasksHasNextPage,
    notesNextCursor,
    notesHasNextPage,
    activityNextCursor,
    activityHasNextPage,
    replyingTo,
    inviteUrl,
    message,
  ];
}

const _unchanged = Object();
