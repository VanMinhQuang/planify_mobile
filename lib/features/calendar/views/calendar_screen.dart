import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar<void>(
          firstDay: DateTime(now.year - 2),
          lastDay: DateTime(now.year + 3),
          focusedDay: now,
        ),
      ),
    );
  }
}
