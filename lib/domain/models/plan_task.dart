import 'package:equatable/equatable.dart';

class PlanTask extends Equatable {
  const PlanTask({
    required this.id,
    required this.planId,
    required this.title,
    required this.isDone,
    this.assignedTo,
    this.dueDate,
  });

  final String id;
  final String planId;
  final String title;
  final bool isDone;
  final String? assignedTo;
  final DateTime? dueDate;

  @override
  List<Object?> get props => [id, planId, title, isDone, assignedTo, dueDate];
}
