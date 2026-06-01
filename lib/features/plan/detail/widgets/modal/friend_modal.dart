import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/app_user.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';

class FriendModal extends StatelessWidget {
  final PlanDetailCubit bloc;
  const FriendModal({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<PlanDetailCubit, PlanDetailState>(
        builder: (context, sheetState) {
          final friends = sheetState.friends;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create invite',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (sheetState.isLoadingFriends)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (friends.isNotEmpty) ...[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return _InviteFriendTile(
                            friend: friend,
                            onTap: sheetState.isCreatingInvite
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<PlanDetailCubit>()
                                        .createInvite(inviteeId: friend.id);
                                  },
                          );
                        },
                      ),
                    ),
                    const Divider(height: 24),
                  ],
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.link_outlined),
                    ),
                    title: const Text('Share as link'),
                    subtitle: friends.isEmpty && !sheetState.isLoadingFriends
                        ? const Text('No friends available to invite.')
                        : null,
                    enabled: !sheetState.isCreatingInvite,
                    onTap: sheetState.isCreatingInvite
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            context.read<PlanDetailCubit>().createInvite();
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InviteFriendTile extends StatelessWidget {
  const _InviteFriendTile({required this.friend, required this.onTap});

  final AppUser friend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = friend.avatarUrl;
    final title = friend.name.isEmpty ? 'Planify user' : friend.name;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        child: avatarUrl?.isNotEmpty == true
            ? null
            : const Icon(Icons.person_outline),
      ),
      title: Text(title),
      subtitle: friend.email.isEmpty ? null : Text(friend.email),
      trailing: const Icon(Icons.chevron_right),
      enabled: onTap != null,
      onTap: onTap,
    );
  }
}
