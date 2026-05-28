import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/activity_entry.dart';
import '../../../domain/models/plan.dart';
import '../../../domain/models/plan_note.dart';
import '../../../domain/models/plan_task.dart';
import '../../../domain/repository/plan_repository.dart';

class PlanDetailState extends Equatable {
  const PlanDetailState({
    this.isLoading = false,
    this.plan,
    this.tasks = const [],
    this.notes = const [],
    this.activity = const [],
    this.inviteUrl,
    this.message,
  });

  final bool isLoading;
  final Plan? plan;
  final List<PlanTask> tasks;
  final List<PlanNote> notes;
  final List<ActivityEntry> activity;
  final String? inviteUrl;
  final String? message;

  PlanDetailState copyWith({
    bool? isLoading,
    Plan? plan,
    List<PlanTask>? tasks,
    List<PlanNote>? notes,
    List<ActivityEntry>? activity,
    String? inviteUrl,
    String? message,
  }) {
    return PlanDetailState(
      isLoading: isLoading ?? this.isLoading,
      plan: plan ?? this.plan,
      tasks: tasks ?? this.tasks,
      notes: notes ?? this.notes,
      activity: activity ?? this.activity,
      inviteUrl: inviteUrl ?? this.inviteUrl,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    plan,
    tasks,
    notes,
    activity,
    inviteUrl,
    message,
  ];
}

class PlanDetailCubit extends Cubit<PlanDetailState> {
  PlanDetailCubit({required PlanRepository planRepository})
    : _planRepository = planRepository,
      super(const PlanDetailState());

  final PlanRepository _planRepository;

  Future<void> load(String planId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        _planRepository.getPlan(planId),
        _planRepository.listTasks(planId),
        _planRepository.listNotes(planId),
        _planRepository.listActivity(planId),
      ]);
      emit(
        state.copyWith(
          isLoading: false,
          plan: results[0] as Plan,
          tasks: results[1] as List<PlanTask>,
          notes: results[2] as List<PlanNote>,
          activity: results[3] as List<ActivityEntry>,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, message: error.toString()));
    }
  }

  Future<void> addTask(String title) async {
    final plan = state.plan;
    if (plan == null || title.trim().isEmpty) {
      return;
    }
    final task = await _planRepository.createTask(plan.id, title.trim());
    emit(state.copyWith(tasks: [task, ...state.tasks]));
  }

  Future<void> toggleTask(PlanTask task) async {
    final updated = await _planRepository.updateTaskDone(
      task.planId,
      task.id,
      !task.isDone,
    );
    emit(
      state.copyWith(
        tasks: state.tasks
            .map((item) => item.id == updated.id ? updated : item)
            .toList(),
      ),
    );
  }

  Future<void> addNote(String content) async {
    final plan = state.plan;
    if (plan == null || content.trim().isEmpty) {
      return;
    }
    final note = await _planRepository.createNote(plan.id, content.trim());
    emit(state.copyWith(notes: [note, ...state.notes]));
  }

  Future<void> createInvite() async {
    final plan = state.plan;
    if (plan == null) {
      return;
    }
    final invite = await _planRepository.createInvite(plan.id);
    emit(state.copyWith(inviteUrl: invite['url'] as String?));
  }
}
