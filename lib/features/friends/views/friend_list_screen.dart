import 'package:app_core/ui/widgets/container/app_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/app_user.dart';
import '../../../domain/models/friendship.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/friends_cubit.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FriendsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.select(
      (AuthBloc bloc) => bloc.state.user?.id ?? '',
    );

    return AppContainer(
      appBarTitle: 'Friends',
      onRefresh: context.read<FriendsCubit>().load,
      child: BlocConsumer<FriendsCubit, FriendsState>(
        listenWhen: (previous, current) =>
            previous.actionError != current.actionError &&
            current.actionError.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionError)));
        },
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty && state.items.isEmpty) {
            return _FriendMessage(
              title: 'Friends unavailable',
              message: state.error,
              onRetry: context.read<FriendsCubit>().load,
            );
          }

          final accepted = state.items
              .where((item) => item.status == FriendshipStatus.accepted)
              .toList();
          final incoming = state.items
              .where(
                (item) =>
                    item.status == FriendshipStatus.pending &&
                    item.addresseeId == currentUserId,
              )
              .toList();
          final outgoing = state.items
              .where(
                (item) =>
                    item.status == FriendshipStatus.pending &&
                    item.requesterId == currentUserId,
              )
              .toList();

          if (accepted.isEmpty && incoming.isEmpty && outgoing.isEmpty) {
            return _FriendMessage(
              title: 'No friends yet',
              message: 'Accepted friends and pending requests will show here.',
              onRetry: context.read<FriendsCubit>().load,
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 96),
            children: [
              if (incoming.isNotEmpty) ...[
                _SectionTitle('Requests'),
                ...incoming.map(
                  (item) => _FriendTile(
                    friendship: item,
                    currentUserId: currentUserId,
                    isBusy: state.actionIds.contains(item.id),
                    onAccept: () =>
                        context.read<FriendsCubit>().accept(item.id),
                    onReject: () =>
                        context.read<FriendsCubit>().reject(item.id),
                  ),
                ),
              ],
              if (accepted.isNotEmpty) ...[
                _SectionTitle('Friends'),
                ...accepted.map(
                  (item) => _FriendTile(
                    friendship: item,
                    currentUserId: currentUserId,
                    isBusy: state.actionIds.contains(item.id),
                  ),
                ),
              ],
              if (outgoing.isNotEmpty) ...[
                _SectionTitle('Sent'),
                ...outgoing.map(
                  (item) => _FriendTile(
                    friendship: item,
                    currentUserId: currentUserId,
                    isBusy: state.actionIds.contains(item.id),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({
    required this.friendship,
    required this.currentUserId,
    required this.isBusy,
    this.onAccept,
    this.onReject,
  });

  final Friendship friendship;
  final String currentUserId;
  final bool isBusy;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final user = _otherUser();
    final isIncoming =
        friendship.status == FriendshipStatus.pending &&
        friendship.addresseeId == currentUserId;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.avatarUrl?.isNotEmpty == true
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl?.isNotEmpty == true
              ? null
              : const Icon(Icons.person_outline),
        ),
        title: Text(user.name.isEmpty ? 'Planify user' : user.name),
        subtitle: Text(_subtitle(user)),
        trailing: isIncoming
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Reject',
                    onPressed: isBusy ? null : onReject,
                    icon: const Icon(Icons.close),
                  ),
                  IconButton.filled(
                    tooltip: 'Accept',
                    onPressed: isBusy ? null : onAccept,
                    icon: isBusy
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                  ),
                ],
              )
            : _StatusLabel(status: friendship.status),
      ),
    );
  }

  AppUser _otherUser() {
    if (friendship.requesterId == currentUserId) {
      return friendship.addressee ?? const AppUser();
    }
    return friendship.requester ?? const AppUser();
  }

  String _subtitle(AppUser user) {
    final contact = user.email.isNotEmpty ? user.email : user.phone ?? '';
    if (friendship.status == FriendshipStatus.accepted) {
      return contact.isEmpty ? 'Friend' : contact;
    }
    return friendship.requesterId == currentUserId
        ? 'Request sent'
        : 'Wants to be your friend';
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final FriendshipStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      FriendshipStatus.accepted => 'Friend',
      FriendshipStatus.pending => 'Pending',
      FriendshipStatus.blocked => 'Blocked',
    };
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _FriendMessage extends StatelessWidget {
  const _FriendMessage({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
