import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/plan.dart';
import 'package:planify_mobile/domain/models/plan_task.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/detail/widgets/load_more_tile.dart';

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
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreateTaskSheet(selectedDay: selectedDay),
    );
  }

  Future<void> _showTaskDetailSheet(BuildContext context, PlanTask task) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TaskDetailSheet(task: task),
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
    final colorScheme = Theme.of(context).colorScheme;
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
            IconButton.filled(
              tooltip: 'Add itinerary item',
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
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
    required this.onTap,
  });

  final PlanTask task;
  final bool isFirst;
  final bool isLast;
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
                          onChanged: (_) =>
                              context.read<PlanDetailCubit>().toggleTask(task),
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
                              if (_hasText(task.description)) ...[
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
                              if (_hasLocation(task)) ...[
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
                                        _locationLabel(task),
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

class _CreateTaskSheet extends StatefulWidget {
  const _CreateTaskSheet({required this.selectedDay});

  final DateTime selectedDay;

  @override
  State<_CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<_CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _locationLatController = TextEditingController();
  final _locationLngController = TextEditingController();
  var _time = const TimeOfDay(hour: 8, minute: 0);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    _locationLatController.dispose();
    _locationLngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, bottomInset + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add itinerary item',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Task',
                hintText: 'Visit museum, dinner reservation...',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Tickets, notes, what to see...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Location name',
                hintText: 'Restaurant, landmark, hotel...',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationLatController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _locationLngController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormat(
                              'MMM d, yyyy',
                            ).format(widget.selectedDay),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.schedule),
                  label: Text(_time.format(context)),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _titleController.text.trim().isEmpty ? null : _save,
              icon: const Icon(Icons.add),
              label: const Text('Add to day'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _save() async {
    final dueDate = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _time.hour,
      _time.minute,
    );
    await context.read<PlanDetailCubit>().addTask(
      _titleController.text,
      description: _descriptionController.text,
      locationName: _locationNameController.text,
      locationLat: double.tryParse(_locationLatController.text.trim()),
      locationLng: double.tryParse(_locationLngController.text.trim()),
      dueDate: dueDate,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _TaskDetailSheet extends StatelessWidget {
  const _TaskDetailSheet({required this.task});

  final PlanTask task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dueDate = task.dueDate?.toLocal();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DetailChip(
                  icon: Icons.schedule,
                  label: dueDate == null
                      ? 'Anytime'
                      : DateFormat('MMM d, h:mm a').format(dueDate),
                ),
                _DetailChip(
                  icon: task.isDone
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                  label: task.isDone ? 'Completed' : 'Planned',
                ),
              ],
            ),
            if (_hasLocation(task)) ...[
              const SizedBox(height: 18),
              Text(
                'Location',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.place_outlined, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_locationLabel(task))),
                ],
              ),
            ],
            if (_hasText(task.description)) ...[
              const SizedBox(height: 18),
              Text(
                'Description',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(task.description!.trim()),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () {
                context.read<PlanDetailCubit>().toggleTask(task);
                Navigator.of(context).pop();
              },
              icon: Icon(task.isDone ? Icons.undo : Icons.check),
              label: Text(task.isDone ? 'Mark planned' : 'Mark complete'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

bool _hasLocation(PlanTask task) {
  return _hasText(task.locationName) ||
      task.locationLat != null ||
      task.locationLng != null;
}

String _locationLabel(PlanTask task) {
  final parts = <String>[
    if (_hasText(task.locationName)) task.locationName!.trim(),
    if (task.locationLat != null || task.locationLng != null)
      [
        if (task.locationLat != null)
          'lat ${task.locationLat!.toStringAsFixed(5)}',
        if (task.locationLng != null)
          'lng ${task.locationLng!.toStringAsFixed(5)}',
      ].join(', '),
  ];
  return parts.join(' - ');
}
