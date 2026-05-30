import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/models/plan_task.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          previous.inviteUrl != current.inviteUrl,
      listener: (context, state) {
        final inviteUrl = state.inviteUrl;
        if (inviteUrl != null) {
          SharePlus.instance.share(ShareParams(text: inviteUrl));
        }
      },
      builder: (context, state) {
        final plan = state.plan;
        return Scaffold(
          appBar: AppBar(
            title: Text(plan?.title ?? 'Plan'),
            actions: [
              IconButton(
                tooltip: 'Invite',
                onPressed: plan == null
                    ? null
                    : () => context.read<PlanDetailCubit>().createInvite(),
                icon: const Icon(Icons.person_add_alt_1_outlined),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Tasks'),
                Tab(text: 'Notes'),
                Tab(text: 'Activity'),
              ],
            ),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _OverviewTab(state: state),
                    _TasksTab(controller: _taskController),
                    _NotesTab(controller: _noteController),
                    _ActivityTab(state: state),
                  ],
                ),
        );
      },
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.state});

  final PlanDetailState state;

  @override
  Widget build(BuildContext context) {
    final plan = state.plan;
    if (plan == null) {
      return const Center(child: Text('Plan not found'));
    }
    final daysLeft = plan.startDate.difference(DateTime.now()).inDays;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  daysLeft <= 0 ? 'Starting soon' : '$daysLeft days to go',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  plan.description?.isEmpty ?? true
                      ? 'No description yet.'
                      : plan.description!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      plan.likedByMe
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: plan.likedByMe
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Text('${plan.likeCount} likes'),
                    const SizedBox(width: 18),
                    const Icon(Icons.mode_comment_outlined),
                    const SizedBox(width: 6),
                    Text('${plan.commentCount} comments'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
