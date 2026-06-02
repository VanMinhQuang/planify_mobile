import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/models/plan.dart';
import '../../../../../domain/repository/plan_repository.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({required PlanRepository planRepository})
    : _planRepository = planRepository,
      super(CalendarState.initial());

  final PlanRepository _planRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final plans = <Plan>[];
      String? cursor;
      var hasNextPage = true;
      while (hasNextPage) {
        final page = await _planRepository.listPlans(cursor: cursor, limit: 50);
        plans.addAll(page.items);
        cursor = page.nextCursor;
        hasNextPage = page.hasNextPage;
      }
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
      final startDate = plan.startDate;
      final endDate = plan.endDate;
      if (startDate == null || endDate == null) {
        return false;
      }
      final start = _dateOnly(startDate);
      final end = _dateOnly(endDate);
      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
