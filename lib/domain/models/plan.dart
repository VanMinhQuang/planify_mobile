import 'package:equatable/equatable.dart';

enum PlanCategory { travel, event, work, personal }

class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.title,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.ownerId,
    this.description,
    this.coverImageUrl,
    this.isArchived = false,
  });

  final String id;
  final String title;
  final String? description;
  final PlanCategory category;
  final String? coverImageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String ownerId;
  final bool isArchived;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    coverImageUrl,
    startDate,
    endDate,
    ownerId,
    isArchived,
  ];
}
