import 'dart:async';

import 'package:app_core/ui/widgets/container/app_container.dart';
import 'package:app_core/ui/widgets/circle_app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/app_user.dart';
import '../../../domain/models/friend_search_result.dart';
import '../../../domain/models/friendship.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/friends_cubit.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    context.read<FriendsCubit>().load();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
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

          return ListView(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 96),
            children: [
              _SearchBox(
                controller: _searchController,
                isSearching: state.isSearching,
                onChanged: _onSearchChanged,
                onClear: () {
                  _searchController.clear();
                  context.read<FriendsCubit>().search('');
                },
              ),
              if (state.query.trim().isNotEmpty) ...[
                _SectionTitle('Find people'),
                if (state.isSearching)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.searchError.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: const Text('Search failed'),
                    subtitle: Text(state.searchError),
                  )
                else if (state.searchResults.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.search_off_outlined),
                    title: Text('No people found'),
                  )
                else
                  ...state.searchResults.map(
                    (item) => _SearchResultTile(
                      result: item,
                      isBusy:
                          state.actionIds.contains(item.user.id) ||
                          state.actionIds.contains(item.friendship?.id),
                      onAdd: () =>
                          context.read<FriendsCubit>().addFriend(item.user.id),
                      onAccept: item.friendship == null
                          ? null
                          : () => context.read<FriendsCubit>().accept(
                              item.friendship!.id,
                            ),
                      onRemove: () =>
                          context.read<FriendsCubit>().remove(item.user.id),
                    ),
                  ),
              ],
              if (accepted.isEmpty &&
                  incoming.isEmpty &&
                  outgoing.isEmpty &&
                  state.query.trim().isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _FriendMessage(
                    title: 'No friends yet',
                    message:
                        'Search people above or accept pending requests here.',
                    onRetry: context.read<FriendsCubit>().load,
                  ),
                ),
              if (incoming.isNotEmpty) ...[
                _SectionTitle('Requests'),
                ...incoming.map(
                  (item) => _FriendTile(
                    friendship: item,
                    currentUserId: currentUserId,
                    isBusy:
                        state.actionIds.contains(item.id) ||
                        state.actionIds.contains(
                          _otherUserId(item, currentUserId),
                        ),
                    onAccept: () =>
                        context.read<FriendsCubit>().accept(item.id),
                    onReject: () =>
                        context.read<FriendsCubit>().reject(item.id),
                    onRemove: () => context.read<FriendsCubit>().remove(
                      _otherUserId(item, currentUserId),
                    ),
                  ),
                ),
              ],
              if (accepted.isNotEmpty) ...[
                _SectionTitle('Friends'),
                ...accepted.map(
                  (item) => _FriendTile(
                    friendship: item,
                    currentUserId: currentUserId,
                    isBusy:
                        state.actionIds.contains(item.id) ||
                        state.actionIds.contains(
                          _otherUserId(item, currentUserId),
                        ),
                    onRemove: () => context.read<FriendsCubit>().remove(
                      _otherUserId(item, currentUserId),
                    ),
                  ),
                ),
              ],
              if (outgoing.isNotEmpty) ...[
                _SectionTitle('Sent'),
                ...outgoing.map(
                  (item) => _FriendTile(
                    friendship: item,
                    currentUserId: currentUserId,
                    isBusy:
                        state.actionIds.contains(item.id) ||
                        state.actionIds.contains(
                          _otherUserId(item, currentUserId),
                        ),
                    onRemove: () => context.read<FriendsCubit>().remove(
                      _otherUserId(item, currentUserId),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      context.read<FriendsCubit>().search(value);
    });
  }

  String _otherUserId(Friendship friendship, String currentUserId) {
    return friendship.requesterId == currentUserId
        ? friendship.addresseeId
        : friendship.requesterId;
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.isSearching,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search people',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null
              : IconButton(
                  tooltip: 'Clear',
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.result,
    required this.isBusy,
    required this.onAdd,
    required this.onRemove,
    this.onAccept,
  });

  final FriendSearchResult result;
  final bool isBusy;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    final user = result.user;
    return Card(
      child: ListTile(
        leading: _UserAvatar(user),
        title: Text(user.name.isEmpty ? 'Planify user' : user.name),
        subtitle: Text(_contact(user)),
        trailing: _searchAction(),
      ),
    );
  }

  Widget _searchAction() {
    if (isBusy) {
      return const SizedBox.square(
        dimension: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (result.isFriend) {
      return TextButton(onPressed: onRemove, child: const Text('Remove'));
    }
    if (result.isIncomingRequest) {
      return FilledButton(onPressed: onAccept, child: const Text('Accept'));
    }
    if (result.isOutgoingRequest) {
      return TextButton(onPressed: onRemove, child: const Text('Cancel'));
    }
    return FilledButton(onPressed: onAdd, child: const Text('Add'));
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({
    required this.friendship,
    required this.currentUserId,
    required this.isBusy,
    this.onAccept,
    this.onReject,
    this.onRemove,
  });

  final Friendship friendship;
  final String currentUserId;
  final bool isBusy;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final user = _otherUser();
    final isIncoming =
        friendship.status == FriendshipStatus.pending &&
        friendship.addresseeId == currentUserId;

    return Card(
      child: ListTile(
        leading: _UserAvatar(user),
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
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusLabel(status: friendship.status),
                  if (onRemove != null)
                    IconButton(
                      tooltip: friendship.status == FriendshipStatus.accepted
                          ? 'Remove friend'
                          : 'Cancel request',
                      onPressed: isBusy ? null : onRemove,
                      icon: const Icon(Icons.person_remove_outlined),
                    ),
                ],
              ),
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

class _UserAvatar extends StatelessWidget {
  const _UserAvatar(this.user);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return CircleAppImage(imageUrl: user.avatarUrl, name: user.name);
  }
}

String _contact(AppUser user) {
  return user.email.isNotEmpty ? user.email : user.phone ?? '';
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
