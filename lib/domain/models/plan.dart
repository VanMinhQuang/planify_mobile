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

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      category: _categoryFromApi(json['category'] as String?),
      coverImageUrl: json['coverImageUrl'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      ownerId: json['ownerId'] as String? ?? '',
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'category': category.name.toUpperCase(),
      'coverImageUrl': coverImageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  static PlanCategory _categoryFromApi(String? value) {
    return PlanCategory.values.firstWhere(
      (category) => category.name.toUpperCase() == value,
      orElse: () => PlanCategory.personal,
    );
  }

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
