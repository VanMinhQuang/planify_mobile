import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/plan.dart';
import '../../../domain/repository/plan_repository.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({required PlanRepository planRepository})
    : _planRepository = planRepository,
      super(CalendarState.initial());

  final PlanRepository _planRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final plans = await _planRepository.listPlans();
      emit(state.copyWith(isLoading: false, plans: plans));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    emit(
      state.copyWith(
        selectedDay: _dateOnly(selectedDay),
        focusedDay: focusedDay,
      ),
    );
  }

  List<Plan> plansForDay(DateTime day) {
    final date = _dateOnly(day);
    return state.plans.where((plan) {
      final start = _dateOnly(plan.startDate);
      final end = _dateOnly(plan.endDate);
      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
