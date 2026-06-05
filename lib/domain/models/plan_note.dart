import 'package:equatable/equatable.dart';
import 'package:planify_mobile/domain/models/app_user.dart';

enum NoteType { general, itinerary, booking, packing, reminder, idea, warning }

extension NoteTypeX on NoteType {
  String get apiValue => name.toUpperCase();

  String get label {
    switch (this) {
      case NoteType.general:
        return 'General';
      case NoteType.itinerary:
        return 'Itinerary';
      case NoteType.booking:
        return 'Booking';
      case NoteType.packing:
        return 'Packing';
      case NoteType.reminder:
        return 'Reminder';
      case NoteType.idea:
        return 'Idea';
      case NoteType.warning:
        return 'Warning';
    }
  }

  static NoteType fromApi(String? value) {
    return NoteType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => NoteType.general,
    );
  }
}

class PlanNote extends Equatable {
  const PlanNote({
    required this.id,
    required this.planId,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    this.type = NoteType.general,
    this.topic,
    this.assignedTo,
    this.taskId,
    this.creator,
    this.assignee,
    this.taskTitle,
  });

  final String id;
  final String planId;
  final String content;
  final String createdBy;
  final DateTime createdAt;
  final NoteType type;
  final String? topic;
  final String? assignedTo;
  final String? taskId;
  final AppUser? creator;
  final AppUser? assignee;
  final String? taskTitle;

  @override
  List<Object?> get props => [
    id,
    planId,
    content,
    createdBy,
    createdAt,
    type,
    topic,
    assignedTo,
    taskId,
    creator,
    assignee,
    taskTitle,
  ];
}
