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

  @override
  List<Object?> get props => [id, planId, content, createdBy, createdAt];
}
