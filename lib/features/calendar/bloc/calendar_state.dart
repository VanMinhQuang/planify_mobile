part of 'calendar_cubit.dart';

class CalendarState extends Equatable {
  const CalendarState({
    required this.focusedDay,
    required this.selectedDay,
    this.isLoading = false,
    this.plans = const [],
    this.error = '',
  });

  factory CalendarState.initial() {
    final now = DateTime.now();
    return CalendarState(
      focusedDay: now,
      selectedDay: DateTime(now.year, now.month, now.day),
    );
  }

  final DateTime focusedDay;
  final DateTime selectedDay;
  final bool isLoading;
  final List<Plan> plans;
  final String error;

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    bool? isLoading,
    List<Plan>? plans,
    String? error,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [focusedDay, selectedDay, isLoading, plans, error];
}
