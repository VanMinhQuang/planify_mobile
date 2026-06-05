import 'package:app_core/app_core.dart';

class CreateTaskRequest {
  const CreateTaskRequest({
    required this.title,
    this.description,
    this.locationName,
    this.locationLat,
    this.locationLng,
    this.dueDate,
  });

  final String title;
  final String? description;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final DateTime? dueDate;

  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      ...?(_blankToNull(description) == null
          ? null
          : {'description': description!.trim()}),
      ...?(_blankToNull(locationName) == null
          ? null
          : {'locationName': locationName!.trim()}),
      ...?(locationLat == null ? null : {'locationLat': locationLat}),
      ...?(locationLng == null ? null : {'locationLng': locationLng}),
      ...?(dueDate == null
          ? null
          : {'dueDate': dueDate!.toExactUtcIsoString()}),
    };
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
