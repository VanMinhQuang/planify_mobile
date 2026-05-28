import '../../domain/models/plan.dart';

class PlanDto {
  const PlanDto({
    required this.id,
    required this.title,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.ownerId,
    required this.isArchived,
    this.description,
    this.coverImageUrl,
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

  factory PlanDto.fromJson(Map<String, dynamic> json) {
    return PlanDto(
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

  static Map<String, dynamic> createBody(Plan plan) {
    return {
      'title': plan.title,
      'description': plan.description,
      'category': plan.category.name.toUpperCase(),
      'coverImageUrl': plan.coverImageUrl,
      'startDate': plan.startDate.toIso8601String(),
      'endDate': plan.endDate.toIso8601String(),
    };
  }

  Plan toDomain() {
    return Plan(
      id: id,
      title: title,
      description: description,
      category: category,
      coverImageUrl: coverImageUrl,
      startDate: startDate,
      endDate: endDate,
      ownerId: ownerId,
      isArchived: isArchived,
    );
  }

  static PlanCategory _categoryFromApi(String? value) {
    return PlanCategory.values.firstWhere(
      (category) => category.name.toUpperCase() == value,
      orElse: () => PlanCategory.personal,
    );
  }
}
