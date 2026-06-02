import 'package:equatable/equatable.dart';

class PlanTask extends Equatable {
  const PlanTask({
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

  @override
  List<Object?> get props => [
    id,
    planId,
    title,
    description,
    locationName,
    locationLat,
    locationLng,
    isDone,
    assignedTo,
    dueDate,
  ];
}
