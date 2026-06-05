import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/activity_entry.dart';
import 'package:planify_mobile/domain/models/app_user.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({super.key, required this.state});

  final PlanDetailState state;

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> with ListBaseMixin {
  late PlanDetailCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PlanDetailCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanDetailCubit>().state;
    final users = _activityUsers(state);
    final filters = state.activityFilters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _ActivityFilters(
            users: users,
            userId: filters.userId,
            from: filters.from,
            to: filters.to,
            isActive: state.activityFilters.isActive,
            onUserChanged: (value) {
              _bloc.updateActivityFilters(filters.copyWith(userId: value));
            },
            onPickRange: () => _pickRange(context),
            onClear: () => _clearFilters(context),
          ),
        ),
        if (state.activity.isEmpty && !state.isLoadingMoreActivity)
          const Expanded(
            child: EmptyDataWidget(
              text: 'No activity matches these filters',
              icon: Icons.history_toggle_off_outlined,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount:
                  state.activity.length + (state.isLoadingMoreActivity ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.activity.length) {
                  return const _BottomLoadingIndicator();
                }
                return _ActivityTile(
                  entry: state.activity[index],
                  isLast: index == state.activity.length - 1,
                );
              },
            ),
          ),
      ],
    );
  }

  List<AppUser> _activityUsers(PlanDetailState state) {
    final usersById = <String, AppUser>{};
    for (final user in state.plan?.memberUsers ?? const <AppUser>[]) {
      usersById[user.id] = user;
    }
    for (final entry in state.activity) {
      final user = entry.user;
      if (user != null) {
        usersById[user.id] = user;
      }
    }
    return usersById.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> _pickRange(BuildContext context) async {
    final filters = _bloc.state.activityFilters;
    final result = await CommonUtils.showAdaptiveDateRangePicker(
      context: context,
      initialStartDate: filters.from,
      initialEndDate: filters.to,
    );
    if (result == null || !context.mounted) {
      return;
    }

    _bloc.updateActivityFilters(
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

  void _clearFilters(BuildContext context) {
    _bloc.clearActivityFilters();
  }

  @override
  void onReachBottom() {
    _bloc.loadMoreActivity();
  }
}

class _ActivityFilters extends StatelessWidget {
  const _ActivityFilters({
    required this.users,
    required this.userId,
    required this.from,
    required this.to,
    required this.isActive,
    required this.onUserChanged,
    required this.onPickRange,
    required this.onClear,
  });

  final List<AppUser> users;
  final String? userId;
  final DateTime? from;
  final DateTime? to;
  final bool isActive;
  final ValueChanged<String?> onUserChanged;
  final VoidCallback onPickRange;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final rangeLabel = from == null || to == null
        ? 'Date range'
        : '${DateFormat('MMM d').format(from!)} - ${DateFormat('MMM d').format(to!)}';
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 210,
          child: DropdownButtonFormField<String?>(
            key: ValueKey(userId),
            initialValue: userId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'User'),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text(
                  'All users',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
            onChanged: onUserChanged,
          ),
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
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry, required this.isLast});

  final ActivityEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = entry.user;
    final name = user?.name ?? entry.userId;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAppImage(radius: 18, imageUrl: user?.avatarUrl, name: name),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: colorScheme.outlineVariant),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: ' ${entry.action}'),
                      ],
                    ),
                  ),
                  if (entry.targetTitle != null &&
                      entry.targetTitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.targetTitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'MMM d, yyyy - h:mm a',
                    ).format(entry.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
