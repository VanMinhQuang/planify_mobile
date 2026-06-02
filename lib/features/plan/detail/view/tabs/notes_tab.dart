import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/detail/widgets/load_more_tile.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key, required this.controller});

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
            itemCount: state.notes.length + (state.notesHasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.notes.length) {
                return LoadMoreTile(
                  isLoading: state.isLoadingMoreNotes,
                  label: 'Load more notes',
                  onPressed: context.read<PlanDetailCubit>().loadMoreNotes,
                );
              }
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
