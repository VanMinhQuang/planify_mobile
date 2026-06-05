part of 'friends_cubit.dart';

class FriendsState extends Equatable {
  const FriendsState({
    this.isLoading = false,
    this.isSearching = false,
    this.items = const [],
    this.searchResults = const [],
    this.query = '',
    this.actionIds = const {},
    this.error = '',
    this.actionError = '',
    this.searchError = '',
  });

  final bool isLoading;
  final bool isSearching;
  final List<Friendship> items;
  final List<FriendSearchResult> searchResults;
  final String query;
  final Set<String> actionIds;
  final String error;
  final String actionError;
  final String searchError;

  FriendsState copyWith({
    bool? isLoading,
    bool? isSearching,
    List<Friendship>? items,
    List<FriendSearchResult>? searchResults,
    String? query,
    Set<String>? actionIds,
    String? error,
    String? actionError,
    String? searchError,
  }) {
    return FriendsState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      items: items ?? this.items,
      searchResults: searchResults ?? this.searchResults,
      query: query ?? this.query,
      actionIds: actionIds ?? this.actionIds,
      error: error ?? this.error,
      actionError: actionError ?? this.actionError,
      searchError: searchError ?? this.searchError,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSearching,
    items,
    searchResults,
    query,
    actionIds,
    error,
    actionError,
    searchError,
  ];
}
