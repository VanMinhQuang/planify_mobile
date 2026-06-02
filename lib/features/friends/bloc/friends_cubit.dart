import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> accept(String requestId) async {
    await _runAction(requestId, () async {
      final friendship = await _friendRepository.acceptRequest(requestId);
      _replace(friendship);
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
}
