import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widgets/container/app_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify_mobile/features/plan/detail/view/tabs/overview_tab.dart';
import 'package:planify_mobile/features/plan/detail/widgets/modal/friend_modal.dart';
import 'package:planify_mobile/features/plan/widgets/comment_tile.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/models/app_user.dart';
import '../../../../domain/models/plan_comment.dart';
import '../../../../domain/models/plan_task.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../bloc/plan_detail_cubit.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({super.key});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _taskController = TextEditingController();
  final _noteController = TextEditingController();
  late PlanDetailCubit bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    bloc = context.read<PlanDetailCubit>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanDetailCubit, PlanDetailState>(
      listenWhen: (previous, current) =>
          previous.inviteUrl != current.inviteUrl ||
          previous.message != current.message,
      listener: (context, state) {
        final inviteUrl = state.inviteUrl;
        if (inviteUrl != null) {
          SharePlus.instance.share(ShareParams(text: inviteUrl));
        }
        final message = state.message;
        if (message != null && message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final plan = state.plan;
        final currentUserId = context.select(
          (AuthBloc bloc) => bloc.state.user?.id,
        );
        final canViewMemberContent = state.canViewMemberContent(currentUserId);
        return AppContainer(
          isFullScreen: true,
          appBarTitle: plan?.title ?? 'Plan',
          iconRight: IconButton(
            tooltip: 'Invite',
            onPressed:
                plan == null || !canViewMemberContent || state.isCreatingInvite
                ? null
                : () => _showInviteSheet(context, state),
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : canViewMemberContent
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    OverviewTab(state: state),
                    _TasksTab(controller: _taskController),
                    _NotesTab(controller: _noteController),
                    _ActivityTab(state: state),
                  ],
                )
              : OverviewTab(state: state),
        );
      },
    );
  }

  Future<void> _showInviteSheet(
    BuildContext context,
    PlanDetailState state,
  ) async {
    if (state.friends.isEmpty && !state.isLoadingFriends) {
      bloc.refreshFriends();
    }

    await SheetUtils.openCustomBottomSheet(
      context: context,
      builder: (sheetContext) {
        return FriendModal(bloc: bloc);
      },
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanDetailCubit>().state;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'New task'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Add task',
                onPressed: () {
                  context.read<PlanDetailCubit>().addTask(controller.text);
                  controller.clear();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return _TaskTile(task: task);
            },
          ),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final PlanTask task;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: task.isDone,
      onChanged: (_) => context.read<PlanDetailCubit>().toggleTask(task),
      title: Text(task.title),
    );
  }
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanDetailCubit>().state;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Add note',
              suffixIcon: IconButton(
                tooltip: 'Save note',
                onPressed: () {
                  context.read<PlanDetailCubit>().addNote(controller.text);
                  controller.clear();
                },
                icon: const Icon(Icons.send_outlined),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return ListTile(
                title: Text(note.content),
                subtitle: Text(note.createdAt.toLocal().toString()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab({required this.state});

  final PlanDetailState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.activity.length,
      itemBuilder: (context, index) {
        final entry = state.activity[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(entry.action),
          subtitle: Text(
            entry.targetTitle ?? entry.createdAt.toLocal().toString(),
          ),
        );
      },
    );
  }
}
