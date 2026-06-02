import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/models/plan_invitation.dart';
import '../../../../../domain/repository/invitation_repository.dart';

part 'invitations_state.dart';

class InvitationsCubit extends Cubit<InvitationsState> {
  InvitationsCubit({required InvitationRepository invitationRepository})
    : _invitationRepository = invitationRepository,
      super(const InvitationsState());

  final InvitationRepository _invitationRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final page = await _invitationRepository.listInvitations();
      emit(
        state.copyWith(
          isLoading: false,
          items: page.items,
          nextCursor: page.nextCursor,
          hasNextPage: page.hasNextPage,
          totalCount: page.totalCount,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasNextPage || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final page = await _invitationRepository.listInvitations(
        cursor: state.nextCursor,
      );
      emit(
        state.copyWith(
          items: [...state.items, ...page.items],
          nextCursor: page.nextCursor,
          hasNextPage: page.hasNextPage,
          totalCount: page.totalCount,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoadingMore: false, error: error.toString()));
    }
  }

  Future<void> accept(String inviteId) async {
    await _runAction(inviteId, () async {
      await _invitationRepository.acceptInvitation(inviteId);
      _replaceInvite(inviteId, 'ACCEPTED');
    });
  }

  Future<void> decline(String inviteId) async {
    await _runAction(inviteId, () async {
      final invite = await _invitationRepository.declineInvitation(inviteId);
      emit(
        state.copyWith(
          items: state.items
              .map((item) => item.id == inviteId ? invite : item)
              .toList(),
        ),
      );
    });
  }

  Future<void> _runAction(String inviteId, Future<void> Function() fn) async {
    emit(
      state.copyWith(
        actionIds: {...state.actionIds, inviteId},
        actionError: '',
      ),
    );
    try {
      await fn();
    } catch (error) {
      emit(state.copyWith(actionError: error.toString()));
    } finally {
      final nextIds = {...state.actionIds}..remove(inviteId);
      emit(state.copyWith(actionIds: nextIds));
    }
  }

  void _replaceInvite(String inviteId, String status) {
    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => item.id == inviteId
                  ? item.copyWith(status: status, respondedAt: DateTime.now())
                  : item,
            )
            .toList(),
      ),
    );
  }
}
