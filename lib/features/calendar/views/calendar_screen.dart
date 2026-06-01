import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/router.dart';
import '../bloc/calendar_cubit.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return SafeArea(
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          final cubit = context.read<CalendarCubit>();
          final selectedPlans = cubit.plansForDay(state.selectedDay);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              Text(
                'Calendar',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              if (state.isLoading) const LinearProgressIndicator(),
              Card(
                child: TableCalendar<dynamic>(
                  firstDay: DateTime(now.year - 2),
                  lastDay: DateTime(now.year + 3),
                  focusedDay: state.focusedDay,
                  selectedDayPredicate: (day) =>
                      isSameDay(day, state.selectedDay),
                  eventLoader: cubit.plansForDay,
                  onDaySelected: cubit.selectDay,
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                DateFormat.yMMMMd().format(state.selectedDay),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (selectedPlans.isEmpty)
                const ListTile(
                  leading: Icon(Icons.event_available_outlined),
                  title: Text('No plans on this day'),
                )
              else
                ...selectedPlans.map(
                  (plan) => Card(
                    child: ListTile(
                      title: Text(plan.title),
                      subtitle: Text(
                        _formatRange(plan.startDate, plan.endDate),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(Routes.planDetailPath(plan.id)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formatRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'No date';
    }
    return '${DateFormat.MMMd().format(startDate)} - ${DateFormat.MMMd().format(endDate)}';
  }
}
