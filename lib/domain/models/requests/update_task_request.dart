import 'package:app_core/app_core.dart';

class UpdateTaskRequest {
  const UpdateTaskRequest({
    this.title,
    this.description,
    this.locationName,
    this.locationLat,
    this.locationLng,
    this.isDone,
    this.assignedTo,
    this.dueDate,
  });

  final String? title;
  final String? description;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final bool? isDone;
  final String? assignedTo;
  final DateTime? dueDate;

  Map<String, dynamic> toJson() {
    return {
      ...?(title == null ? null : {'title': title}),
      ...?(description == null ? null : {'description': description}),
      ...?(locationName == null ? null : {'locationName': locationName}),
      ...?(locationLat == null ? null : {'locationLat': locationLat}),
      ...?(locationLng == null ? null : {'locationLng': locationLng}),
      ...?(isDone == null ? null : {'isDone': isDone}),
      ...?(assignedTo == null ? null : {'assignedTo': assignedTo}),
      ...?(dueDate == null
          ? null
          : {'dueDate': dueDate!.toExactUtcIsoString()}),
    };
  }
}
