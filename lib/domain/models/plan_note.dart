import 'package:equatable/equatable.dart';

class PlanNote extends Equatable {
  const PlanNote({
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

  factory PlanNote.fromJson(Map<String, dynamic> json) {
    return PlanNote(
      id: json['id'] as String,
      planId: json['planId'] as String,
      content: json['content'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, planId, content, createdBy, createdAt];
}
