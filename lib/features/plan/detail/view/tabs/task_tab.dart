import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/plan.dart';
import 'package:planify_mobile/domain/models/plan_task.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/detail/widgets/load_more_tile.dart';
import 'package:planify_mobile/features/plan/detail/widgets/modal/create_task_modal.dart';
import 'package:planify_mobile/features/plan/detail/widgets/modal/task_detail_modal.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanDetailCubit>().state;
    final days = _planDays(state.plan);
    final selectedDay = _effectiveSelectedDay(days);
    final tasks = _tasksForDay(state.tasks, selectedDay, days.first);
    final doneCount = tasks.where((task) => task.isDone).length;
    final progress = tasks.isEmpty ? 0.0 : doneCount / tasks.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: _TimelineHeader(
                    selectedDay: selectedDay,
                    doneCount: doneCount,
                    totalCount: tasks.length,
                    progress: progress,
                    onAdd: () => _showCreateTaskSheet(context, selectedDay),
                  ),
                ),
                EasyDateTimeLinePicker.itemBuilder(
                  firstDate: days.first,
                  lastDate: days.last,
                  focusedDate: selectedDay,
                  itemExtent: 88,
                  daySeparatorPadding: 10,
                  headerOptions: const HeaderOptions(
                    headerType: HeaderType.none,
                  ),
                  timelineOptions: const TimelineOptions(
                    height: 82,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onDateChange: (date) {
                    setState(() => _selectedDay = DateUtils.dateOnly(date));
                  },
                  itemBuilder:
                      (context, date, isSelected, isDisabled, isToday, onTap) {
                        return _DatePickerDayItem(
                          day: date,
                          index: date.difference(days.first).inDays,
                          isSelected: isSelected,
                          isDisabled: isDisabled,
                          taskCount: _tasksForDay(
                            state.tasks,
                            date,
                            days.first,
                          ).length,
                          onPressed: onTap,
                        );
                      },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: tasks.isEmpty && !state.tasksHasNextPage
                      ? const EmptyDataWidget(
                          text: 'No itinerary items for this day yet',
                          icon: Icons.route_outlined,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount:
                              tasks.length + (state.tasksHasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= tasks.length) {
                              return LoadMoreTile(
                                isLoading: state.isLoadingMoreTasks,
                                label: 'Load more tasks',
                                onPressed: context
                                    .read<PlanDetailCubit>()
                                    .loadMoreTasks,
                              );
                            }
                            return _TimelineTaskTile(
                              task: tasks[index],
                              isFirst: index == 0,
                              isLast: index == tasks.length - 1,
                              isUpdating:
                                  state.taskStatus == PlanTaskStatus.updating &&
                                  state.activeTaskId == tasks[index].id,
                              onTap: () =>
                                  _showTaskDetailSheet(context, tasks[index]),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _effectiveSelectedDay(List<DateTime> days) {
    final selected = _selectedDay;
    if (selected != null &&
        days.any((day) => DateUtils.isSameDay(day, selected))) {
      return selected;
    }
    return days.first;
  }

  List<DateTime> _planDays(Plan? plan) {
    final start = plan?.startDate;
    final end = plan?.endDate;
    if (start == null || end == null) {
      return [DateUtils.dateOnly(DateTime.now())];
    }

    final startDay = DateUtils.dateOnly(start.toLocal());
    final endDay = DateUtils.dateOnly(end.toLocal());
    final dayCount = endDay.difference(startDay).inDays;
    if (dayCount <= 0) {
      return [startDay];
    }

    return List.generate(
      dayCount + 1,
      (index) => startDay.add(Duration(days: index)),
    );
  }

  List<PlanTask> _tasksForDay(
    List<PlanTask> tasks,
    DateTime selectedDay,
    DateTime firstDay,
  ) {
    final filtered = tasks.where((task) {
      final dueDate = task.dueDate;
      if (dueDate == null) {
        return DateUtils.isSameDay(selectedDay, firstDay);
      }
      return DateUtils.isSameDay(dueDate.toLocal(), selectedDay);
    }).toList();

    filtered.sort((a, b) {
      final first = a.dueDate;
      final second = b.dueDate;
      if (first == null && second == null) {
        return a.title.compareTo(b.title);
      }
      if (first == null) {
        return 1;
      }
      if (second == null) {
        return -1;
      }
      return first.compareTo(second);
    });
    return filtered;
  }

  Future<void> _showCreateTaskSheet(
    BuildContext context,
    DateTime selectedDay,
  ) {
    return SheetUtils.openCustomBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PlanDetailCubit>(),
        child: CreateTaskSheet(selectedDay: selectedDay),
      ),
    );
  }

  Future<void> _showTaskDetailSheet(BuildContext context, PlanTask task) {
    return SheetUtils.openCustomBottomSheet(
      context: context,
      height: 0.92,
      builder: (_) => BlocProvider.value(
        value: context.read<PlanDetailCubit>(),
        child: TaskDetailSheet(task: task),
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({
    required this.selectedDay,
    required this.doneCount,
    required this.totalCount,
    required this.progress,
    required this.onAdd,
  });

  final DateTime selectedDay;
  final int doneCount;
  final int totalCount;
  final double progress;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(selectedDay),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$doneCount of $totalCount completed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: context.gradients.primary),
                child: IconButton.filled(
                  tooltip: 'Add itinerary item',
                  onPressed: onAdd,
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      colorScheme.onPrimary,
                    ),
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.onPrimary.withValues(alpha: .12),
                    ),
                  ),
                  icon: const Icon(LucideIcons.plus600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _GradientProgressBar(progress: progress),
      ],
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  const _GradientProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final value = progress.clamp(0.0, 1.0).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: colorScheme.surfaceContainerHighest),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(end: value),
              duration: const Duration(milliseconds: 360),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: animatedValue,
                  child: child,
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: context.gradients.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerDayItem extends StatelessWidget {
  const _DatePickerDayItem({
    required this.day,
    required this.index,
    required this.isSelected,
    required this.isDisabled,
    required this.taskCount,
    required this.onPressed,
  });

  final DateTime day;
  final int index;
  final bool isSelected;
  final bool isDisabled;
  final int taskCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 88,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          backgroundColor: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          foregroundColor: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
          side: BorderSide(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Day ${index + 1}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 3),
            Text(
              DateFormat('MMM d').format(day),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              '$taskCount items',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineTaskTile extends StatelessWidget {
  const _TimelineTaskTile({
    required this.task,
    required this.isFirst,
    required this.isLast,
    required this.isUpdating,
    required this.onTap,
  });

  final PlanTask task;
  final bool isFirst;
  final bool isLast;
  final bool isUpdating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final time = task.dueDate == null
        ? 'Anytime'
        : DateFormat.jm().format(task.dueDate!.toLocal());
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 68,
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : colorScheme.outlineVariant,
                  ),
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: task.isDone
                        ? AppColor.planifyMint
                        : colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 3),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: task.isDone,
                          onChanged: isUpdating
                              ? null
                              : (_) => context
                                    .read<PlanDetailCubit>()
                                    .toggleTask(task),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                              if (task.hasText(task.description)) ...[
                                const SizedBox(height: 6),
                                Text(
                                  task.description!.trim(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                              if (task.hasText(task.locationName)) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place_outlined,
                                      size: 16,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        task.locationName ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: colorScheme.primary,
                                            ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
