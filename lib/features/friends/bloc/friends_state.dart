part of 'friends_cubit.dart';

class FriendsState extends Equatable {
  const FriendsState({
    this.isLoading = false,
    this.items = const [],
    this.actionIds = const {},
    this.error = '',
    this.actionError = '',
  });

  final bool isLoading;
  final List<Friendship> items;
  final Set<String> actionIds;
  final String error;
  final String actionError;

  FriendsState copyWith({
    bool? isLoading,
    List<Friendship>? items,
    Set<String>? actionIds,
    String? error,
    String? actionError,
  }) {
    return FriendsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      actionIds: actionIds ?? this.actionIds,
      error: error ?? this.error,
      actionError: actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, actionIds, error, actionError];
}
