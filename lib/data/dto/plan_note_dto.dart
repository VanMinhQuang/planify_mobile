import 'app_user_dto.dart';
import '../../domain/models/plan_note.dart';

class PlanNoteDto {
  const PlanNoteDto({
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
  final AppUserDto? creator;
  final AppUserDto? assignee;
  final String? taskTitle;

  factory PlanNoteDto.fromJson(Map<String, dynamic> json) {
    final task = json['task'] as Map<String, dynamic>?;
    return PlanNoteDto(
      id: json['id'] as String,
      planId: json['planId'] as String,
      content: json['content'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: NoteTypeX.fromApi(json['type'] as String?),
      topic: json['topic'] as String?,
      assignedTo: json['assignedTo'] as String?,
      taskId: json['taskId'] as String?,
      creator: json['creator'] is Map<String, dynamic>
          ? AppUserDto.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      assignee: json['assignee'] is Map<String, dynamic>
          ? AppUserDto.fromJson(json['assignee'] as Map<String, dynamic>)
          : null,
      taskTitle: task?['title'] as String?,
    );
  }

  PlanNote toDomain() {
    return PlanNote(
      id: id,
      planId: planId,
      content: content,
      createdBy: createdBy,
      createdAt: createdAt,
      type: type,
      topic: topic,
      assignedTo: assignedTo,
      taskId: taskId,
      creator: creator?.toDomain(),
      assignee: assignee?.toDomain(),
      taskTitle: taskTitle,
    );
  }
}
