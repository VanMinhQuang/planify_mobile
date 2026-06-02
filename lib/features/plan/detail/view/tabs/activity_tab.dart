import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/detail/widgets/load_more_tile.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab({super.key, required this.state});

  final PlanDetailState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.activity.length + (state.activityHasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.activity.length) {
          return LoadMoreTile(
            isLoading: state.isLoadingMoreActivity,
            label: 'Load more activity',
            onPressed: context.read<PlanDetailCubit>().loadMoreActivity,
          );
        }
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
