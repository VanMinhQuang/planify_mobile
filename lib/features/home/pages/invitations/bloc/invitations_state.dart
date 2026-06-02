part of 'invitations_cubit.dart';

class InvitationsState extends Equatable {
  const InvitationsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.nextCursor,
    this.hasNextPage = false,
    this.totalCount = 0,
    this.actionIds = const {},
    this.error = '',
    this.actionError = '',
  });

  final bool isLoading;
  final bool isLoadingMore;
  final List<PlanInvitation> items;
  final String? nextCursor;
  final bool hasNextPage;
  final int totalCount;
  final Set<String> actionIds;
  final String error;
  final String actionError;

  InvitationsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<PlanInvitation>? items,
    Object? nextCursor = _unchanged,
    bool? hasNextPage,
    int? totalCount,
    Set<String>? actionIds,
    String? error,
    String? actionError,
  }) {
    return InvitationsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      items: items ?? this.items,
      nextCursor: nextCursor == _unchanged
          ? this.nextCursor
          : nextCursor as String?,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      totalCount: totalCount ?? this.totalCount,
      actionIds: actionIds ?? this.actionIds,
      error: error ?? this.error,
      actionError: actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    items,
    nextCursor,
    hasNextPage,
    totalCount,
    actionIds,
    error,
    actionError,
  ];
}

const _unchanged = Object();
