import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/app_user.dart';
import 'package:planify_mobile/domain/models/plan_note.dart';
import 'package:planify_mobile/domain/models/plan_task.dart';
import 'package:planify_mobile/domain/models/requests/requests.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> with ListBaseMixin {
  final _searchController = TextEditingController();
  late PlanDetailCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PlanDetailCubit>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanDetailCubit>().state;
    final members = state.plan?.memberUsers ?? const <AppUser>[];
    final filters = state.noteFilters;
    _syncSearchController(filters.q);
    return StickyHeaderScrollView(
      onRefresh: () => _bloc.reloadNotes(),
      scrollController: scrollController,
      collapsingContent: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: _NoteFilters(
          searchController: _searchController,
          type: filters.type,
          assignedTo: filters.assignedTo,
          taskId: filters.taskId,
          from: filters.from,
          to: filters.to,
          members: members,
          tasks: state.tasks,
          isActive: filters.isActive,
          onSearch: _applyFilters,
          onTypeChanged: (value) {
            _bloc.updateNoteFilters(filters.copyWith(type: value));
          },
          onAssignedToChanged: (value) {
            _bloc.updateNoteFilters(filters.copyWith(assignedTo: value));
          },
          onTaskChanged: (value) {
            _bloc.updateNoteFilters(filters.copyWith(taskId: value));
          },
          onPickRange: () => _pickRange(context),
          onClear: () => _clearFilters(context),
        ),
      ),
      stickyContent: _NotesStickyHeader(
        onAddNote: () =>
            _openAddNoteDialog(context, members: members, tasks: state.tasks),
      ),
      listBuilder: (_) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            if (state.notes.isEmpty && !state.isLoadingMoreNotes)
              const EmptyDataWidget(
                text: 'No matching notes yet',
                icon: Icons.sticky_note_2_outlined,
              ),
            for (final note in state.notes) ...[
              _NoteCard(note: note),
              const SizedBox(height: 10),
            ],
            if (state.isLoadingMoreNotes) const _BottomLoadingIndicator(),
          ]),
        ),
      ),
    );
  }

  void _syncSearchController(String? query) {
    final value = query ?? '';
    if (_searchController.text == value) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _openAddNoteDialog(
    BuildContext parentContext, {
    required List<AppUser> members,
    required List<PlanTask> tasks,
  }) async {
    await showDialog<void>(
      context: parentContext,
      builder: (_) => BlocProvider.value(
        value: _bloc,
        child: _AddNoteDialog(members: members, tasks: tasks),
      ),
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final filters = _bloc.state.noteFilters;
    final result = await CommonUtils.showAdaptiveDateRangePicker(
      context: context,
      initialStartDate: filters.from,
      initialEndDate: filters.to,
    );
    if (result == null || !context.mounted) {
      return;
    }

    _bloc.updateNoteFilters(
      filters.copyWith(
        from: DateUtils.dateOnly(result.start),
        to: DateTime(
          result.end.year,
          result.end.month,
          result.end.day,
          23,
          59,
          59,
        ),
      ),
    );
  }

  void _applyFilters() {
    final filters = _bloc.state.noteFilters;
    _bloc.reloadNotes(filters: filters.copyWith(q: _searchController.text));
  }

  void _clearFilters(BuildContext context) {
    _searchController.clear();
    _bloc.clearNoteFilters();
  }

  @override
  void onReachBottom() {
    _bloc.loadMoreNotes();
  }
}

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog({required this.members, required this.tasks});

  final List<AppUser> members;
  final List<PlanTask> tasks;

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final _contentController = TextEditingController();
  final _topicController = TextEditingController();
  var _type = NoteType.general;
  String? _assignedTo;
  String? _taskId;

  @override
  void dispose() {
    _contentController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _NoteComposer(
            contentController: _contentController,
            topicController: _topicController,
            type: _type,
            assignedTo: _assignedTo,
            taskId: _taskId,
            members: widget.members,
            tasks: widget.tasks,
            onTypeChanged: (value) => setState(() => _type = value),
            onAssignedToChanged: (value) => setState(() => _assignedTo = value),
            onTaskChanged: (value) => setState(() => _taskId = value),
            onSave: _save,
          ),
        ),
      ),
    );
  }

  void _save() {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      return;
    }
    context.read<PlanDetailCubit>().addNote(
      CreateNoteRequest(
        content: content,
        topic: _topicController.text,
        type: _type,
        assignedTo: _assignedTo,
        taskId: _taskId,
      ),
    );
    Navigator.of(context).pop();
  }
}

class _NoteComposer extends StatelessWidget {
  const _NoteComposer({
    required this.contentController,
    required this.topicController,
    required this.type,
    required this.assignedTo,
    required this.taskId,
    required this.members,
    required this.tasks,
    required this.onTypeChanged,
    required this.onAssignedToChanged,
    required this.onTaskChanged,
    required this.onSave,
  });

  final TextEditingController contentController;
  final TextEditingController topicController;
  final NoteType type;
  final String? assignedTo;
  final String? taskId;
  final List<AppUser> members;
  final List<PlanTask> tasks;
  final ValueChanged<NoteType> onTypeChanged;
  final ValueChanged<String?> onAssignedToChanged;
  final ValueChanged<String?> onTaskChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add note',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextFormFieldComponent(
            controller: topicController,
            labelText: 'Topic',
            placeholder: 'What is this note about?',
          ),
          const SizedBox(height: 10),
          _NoteTypeDropdown(value: type, onChanged: onTypeChanged),
          const SizedBox(height: 10),
          _UserDropdown(
            label: 'Assign to',
            value: assignedTo,
            users: members,
            onChanged: onAssignedToChanged,
          ),
          const SizedBox(height: 10),
          _TaskDropdown(value: taskId, tasks: tasks, onChanged: onTaskChanged),
          const SizedBox(height: 10),
          TextFormFieldComponent(
            controller: contentController,
            minLine: 3,
            maxLine: 5,
            labelText: 'Content',
            placeholder: 'Write details, links, reminders, or context...',
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Save note'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesStickyHeader extends StatelessWidget {
  const _NotesStickyHeader({required this.onAddNote});

  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Notes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          FilledButton.icon(
            onPressed: onAddNote,
            icon: const Icon(Icons.add),
            label: const Text('Add note'),
          ),
        ],
      ),
    );
  }
}

class _NoteFilters extends StatelessWidget {
  const _NoteFilters({
    required this.searchController,
    required this.type,
    required this.assignedTo,
    required this.taskId,
    required this.from,
    required this.to,
    required this.members,
    required this.tasks,
    required this.isActive,
    required this.onSearch,
    required this.onTypeChanged,
    required this.onAssignedToChanged,
    required this.onTaskChanged,
    required this.onPickRange,
    required this.onClear,
  });

  final TextEditingController searchController;
  final NoteType? type;
  final String? assignedTo;
  final String? taskId;
  final DateTime? from;
  final DateTime? to;
  final List<AppUser> members;
  final List<PlanTask> tasks;
  final bool isActive;
  final VoidCallback onSearch;
  final ValueChanged<NoteType?> onTypeChanged;
  final ValueChanged<String?> onAssignedToChanged;
  final ValueChanged<String?> onTaskChanged;
  final VoidCallback onPickRange;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final rangeLabel = from == null || to == null
        ? 'Date range'
        : '${DateFormat('MMM d').format(from!)} - ${DateFormat('MMM d').format(to!)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormFieldComponent(
          controller: searchController,
          labelText: 'Search notes',
          placeholder: 'Search topic or content',
          suffixIcon: IconButton(
            tooltip: 'Search',
            onPressed: onSearch,
            icon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _OptionalNoteTypeDropdown(value: type, onChanged: onTypeChanged),
            _UserDropdown(
              label: 'Assignee',
              value: assignedTo,
              users: members,
              onChanged: onAssignedToChanged,
            ),
            _TaskDropdown(
              value: taskId,
              tasks: tasks,
              onChanged: onTaskChanged,
            ),
            OutlinedButton.icon(
              onPressed: onPickRange,
              icon: const Icon(Icons.date_range_outlined),
              label: Text(rangeLabel),
            ),
            if (isActive)
              TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: const Text('Clear'),
              ),
          ],
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final PlanNote note;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(note.type.label),
                visualDensity: VisualDensity.compact,
              ),
              const Spacer(),
              Text(
                DateFormat('MMM d, h:mm a').format(note.createdAt.toLocal()),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (note.topic != null && note.topic!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              note.topic!.trim(),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
          const SizedBox(height: 8),
          Text(note.content),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _MetaChip(
                icon: Icons.person_outline,
                label: 'By ${note.creator?.name ?? note.createdBy}',
              ),
              if (note.assignee != null)
                _MetaChip(
                  icon: Icons.assignment_ind_outlined,
                  label: 'For ${note.assignee!.name}',
                ),
              if (note.taskTitle != null)
                _MetaChip(
                  icon: Icons.task_alt_outlined,
                  label: note.taskTitle!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoteTypeDropdown extends StatelessWidget {
  const _NoteTypeDropdown({required this.value, required this.onChanged});

  final NoteType value;
  final ValueChanged<NoteType> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<NoteType>(
      key: ValueKey(value),
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Type'),
      items: NoteType.values
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(
                type.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _OptionalNoteTypeDropdown extends StatelessWidget {
  const _OptionalNoteTypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final NoteType? value;
  final ValueChanged<NoteType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: DropdownButtonFormField<NoteType?>(
        key: ValueKey(value),
        initialValue: value,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Type'),
        items: [
          const DropdownMenuItem(value: null, child: Text('Any type')),
          ...NoteType.values.map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(
                type.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _UserDropdown extends StatelessWidget {
  const _UserDropdown({
    required this.label,
    required this.value,
    required this.users,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<AppUser> users;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: DropdownButtonFormField<String?>(
        key: ValueKey('$label-$value'),
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          const DropdownMenuItem(value: null, child: Text('Anyone')),
          ...users.map(
            (user) => DropdownMenuItem(
              value: user.id,
              child: Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _TaskDropdown extends StatelessWidget {
  const _TaskDropdown({
    required this.value,
    required this.tasks,
    required this.onChanged,
  });

  final String? value;
  final List<PlanTask> tasks;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: DropdownButtonFormField<String?>(
        key: ValueKey(value),
        initialValue: value,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Linked task'),
        items: [
          const DropdownMenuItem(value: null, child: Text('No task')),
          ...tasks.map(
            (task) => DropdownMenuItem(
              value: task.id,
              child: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _BottomLoadingIndicator extends StatelessWidget {
  const _BottomLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
