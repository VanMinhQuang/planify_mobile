import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/plan_task.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/detail/widgets/load_more_tile.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key, required this.controller});

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
            itemCount: state.tasks.length + (state.tasksHasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.tasks.length) {
                return LoadMoreTile(
                  isLoading: state.isLoadingMoreTasks,
                  label: 'Load more tasks',
                  onPressed: context.read<PlanDetailCubit>().loadMoreTasks,
                );
              }
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
