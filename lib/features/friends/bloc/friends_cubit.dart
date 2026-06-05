import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/friend_search_result.dart';
import '../../../domain/models/friendship.dart';
import '../../../domain/repository/friend_repository.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit({required FriendRepository friendRepository})
    : _friendRepository = friendRepository,
      super(const FriendsState());

  final FriendRepository _friendRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final items = await _friendRepository.listFriends();
      emit(state.copyWith(isLoading: false, items: items));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    emit(
      state.copyWith(
        query: query,
        isSearching: trimmed.isNotEmpty,
        searchError: '',
        searchResults: trimmed.isEmpty ? [] : null,
      ),
    );
    if (trimmed.isEmpty) return;

    try {
      final results = await _friendRepository.searchFriends(trimmed);
      if (state.query.trim() != trimmed) return;
      emit(state.copyWith(isSearching: false, searchResults: results));
    } catch (error) {
      emit(state.copyWith(isSearching: false, searchError: error.toString()));
    }
  }

  Future<void> addFriend(String userId) async {
    await _runAction(userId, () async {
      final friendship = await _friendRepository.createRequest(userId);
      emit(state.copyWith(items: _upsertFriendship(friendship)));
      await search(state.query);
    });
  }

  Future<void> accept(String requestId) async {
    await _runAction(requestId, () async {
      final friendship = await _friendRepository.acceptRequest(requestId);
      _replace(friendship);
      await search(state.query);
    });
  }

  Future<void> reject(String requestId) async {
    await _runAction(requestId, () async {
      await _friendRepository.rejectRequest(requestId);
      emit(
        state.copyWith(
          items: state.items.where((item) => item.id != requestId).toList(),
        ),
      );
      await search(state.query);
    });
  }

  Future<void> remove(String userId) async {
    await _runAction(userId, () async {
      await _friendRepository.removeFriend(userId);
      emit(
        state.copyWith(
          items: state.items
              .where(
                (item) =>
                    item.requesterId != userId && item.addresseeId != userId,
              )
              .toList(),
        ),
      );
      await search(state.query);
    });
  }

  Future<void> _runAction(String requestId, Future<void> Function() fn) async {
    emit(
      state.copyWith(
        actionIds: {...state.actionIds, requestId},
        actionError: '',
      ),
    );
    try {
      await fn();
    } catch (error) {
      emit(state.copyWith(actionError: error.toString()));
    } finally {
      final ids = {...state.actionIds}..remove(requestId);
      emit(state.copyWith(actionIds: ids));
    }
  }

  void _replace(Friendship friendship) {
    emit(
      state.copyWith(
        items: state.items
            .map((item) => item.id == friendship.id ? friendship : item)
            .toList(),
      ),
    );
  }

  List<Friendship> _upsertFriendship(Friendship friendship) {
    final exists = state.items.any((item) => item.id == friendship.id);
    if (!exists) return [friendship, ...state.items];
    return state.items
        .map((item) => item.id == friendship.id ? friendship : item)
        .toList();
  }
}
