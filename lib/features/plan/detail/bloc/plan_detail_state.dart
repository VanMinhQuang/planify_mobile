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
    replyingTo,
    inviteUrl,
    message,
  ];
}

const _unchanged = Object();
