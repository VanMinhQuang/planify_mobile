import '../../domain/models/plan_task.dart';

class PlanTaskDto {
  const PlanTaskDto({
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

  factory PlanTaskDto.fromJson(Map<String, dynamic> json) {
    return PlanTaskDto(
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

  PlanTask toDomain() {
    return PlanTask(
      id: id,
      planId: planId,
      title: title,
      isDone: isDone,
      assignedTo: assignedTo,
      dueDate: dueDate,
    );
  }
}
