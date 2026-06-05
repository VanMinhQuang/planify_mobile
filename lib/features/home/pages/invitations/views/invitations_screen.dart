import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router.dart';
import '../../../../../domain/models/plan_invitation.dart';
import '../bloc/invitations_cubit.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen>
    with AutomaticKeepAliveClientMixin {
  late final InvitationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<InvitationsCubit>();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppContainer(
      canGoBack: false,
      appBarTitle: 'Invitation',
      onRefresh: () => _cubit.load(),
      child: BlocConsumer<InvitationsCubit, InvitationsState>(
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
            return _InvitationMessage(
              title: 'Invitations unavailable',
              message: state.error,
              onRetry: _cubit.load,
            );
          }

          if (state.items.isEmpty) {
            return _InvitationMessage(
              title: 'No invitations',
              message: 'Plan invites from friends will show here.',
              onRetry: _cubit.load,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
            itemCount: state.items.length + (state.hasNextPage ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return Center(
                  child: TextButton(
                    onPressed: state.isLoadingMore ? null : _cubit.loadMore,
                    child: state.isLoadingMore
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Load more'),
                  ),
                );
              }

              final invitation = state.items[index];
              return _InvitationCard(
                invitation: invitation,
                isBusy: state.actionIds.contains(invitation.id),
                onAccept: () => _cubit.accept(invitation.id),
                onDecline: () => _cubit.decline(invitation.id),
                onOpen: invitation.planId.isEmpty
                    ? null
                    : () => context.push(
                        Routes.planDetailPath(invitation.planId),
                      ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _InvitationCard extends StatelessWidget {
  const _InvitationCard({
    required this.invitation,
    required this.isBusy,
    required this.onAccept,
    required this.onDecline,
    this.onOpen,
  });

  final PlanInvitation invitation;
  final bool isBusy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (invitation.planCoverImageUrl?.isNotEmpty == true)
              AspectRatio(
                aspectRatio: 16 / 8,
                child: AppImage(
                  url: invitation.planCoverImageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAppImage(
                        radius: 18,
                        imageUrl: invitation.creator?.avatarUrl,
                        name: invitation.creator?.name,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${invitation.creator?.name ?? 'Friend'} invited you',
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      _StatusChip(invitation: invitation),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    invitation.planTitle.isEmpty
                        ? 'Plan invitation'
                        : invitation.planTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${invitation.planCategory.name} • ${_range(invitation)} • ${invitation.role.toLowerCase()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (invitation.isPending) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isBusy ? null : onDecline,
                            child: const Text('Decline'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: isBusy ? null : onAccept,
                            child: isBusy
                                ? const SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _range(PlanInvitation invitation) {
    final start = invitation.planStartDate;
    final end = invitation.planEndDate;
    if (start == null || end == null) return 'No date';
    return '${DateFormat.MMMd().format(start)} - ${DateFormat.MMMd().format(end)}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.invitation});

  final PlanInvitation invitation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = invitation.isAccepted
        ? colorScheme.primary
        : invitation.isDeclined
        ? colorScheme.error
        : colorScheme.tertiary;
    return Chip(
      label: Text(invitation.status.toLowerCase()),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color.withValues(alpha: .35)),
      backgroundColor: color.withValues(alpha: .12),
      labelStyle: TextStyle(color: color),
    );
  }
}

class _InvitationMessage extends StatelessWidget {
  const _InvitationMessage({
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
              Icons.mail_outline,
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
