import '../../domain/models/plan_note.dart';

class PlanNoteDto {
  const PlanNoteDto({
    required this.id,
    required this.planId,
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String planId;
  final String content;
  final String createdBy;
  final DateTime createdAt;

  factory PlanNoteDto.fromJson(Map<String, dynamic> json) {
    return PlanNoteDto(
      id: json['id'] as String,
      planId: json['planId'] as String,
      content: json['content'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  PlanNote toDomain() {
    return PlanNote(
      id: id,
      planId: planId,
      content: content,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }
}
