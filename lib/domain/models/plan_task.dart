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

  factory PlanTask.fromJson(Map<String, dynamic> json) {
    return PlanTask(
      id: json['id'] as String,
      planId: json['planId'] as String,
      title: json['title'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
      assignedTo: json['assignedTo'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
    );
  }

  @override
  List<Object?> get props => [id, planId, title, isDone, assignedTo, dueDate];
}
