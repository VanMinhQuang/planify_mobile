import '../../domain/models/plan_task.dart';

class PlanTaskDto {
  const PlanTaskDto({
    required this.id,
    required this.planId,
    required this.title,
    required this.isDone,
    this.description,
    this.locationName,
    this.locationLat,
    this.locationLng,
    this.assignedTo,
    this.dueDate,
  });

  final String id;
  final String planId;
  final String title;
  final String? description;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final bool isDone;
  final String? assignedTo;
  final DateTime? dueDate;

  factory PlanTaskDto.fromJson(Map<String, dynamic> json) {
    return PlanTaskDto(
      id: json['id'] as String,
      planId: json['planId'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      locationName: json['locationName'] as String?,
      locationLat: _doubleFromJson(json['locationLat']),
      locationLng: _doubleFromJson(json['locationLng']),
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
      description: description,
      locationName: locationName,
      locationLat: locationLat,
      locationLng: locationLng,
      isDone: isDone,
      assignedTo: assignedTo,
      dueDate: dueDate,
    );
  }

  static double? _doubleFromJson(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}
