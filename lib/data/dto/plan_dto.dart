import 'package:planify_mobile/data/dto/member_dto.dart';
import 'package:planify_mobile/domain/models/app_user.dart';

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
    required this.visibility,
    required this.isSharedToFeed,
    required this.commentCount,
    required this.likeCount,
    required this.likedByMe,
    this.imageUrls = const [],
    this.description,
    this.coverImageUrl,
    this.members = const [],
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
  final PlanVisibility visibility;
  final bool isSharedToFeed;
  final int commentCount;
  final int likeCount;
  final bool likedByMe;
  final List<MemberDto> members;
  final List<String> imageUrls;

  factory PlanDto.fromJson(Map<String, dynamic> json) {
    final count = json['_count'] as Map<String, dynamic>?;
    final likes = json['likes'] as List<dynamic>? ?? [];
    final uploadedFiles = json['uploadedFiles'] as List<dynamic>? ?? [];
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
      visibility: _visibilityFromApi(json['visibility'] as String?),
      isSharedToFeed: json['isSharedToFeed'] as bool? ?? false,
      commentCount: count?['comments'] as int? ?? 0,
      likeCount: count?['likes'] as int? ?? 0,
      likedByMe: likes.isNotEmpty,
      imageUrls: uploadedFiles
          .map((item) => (item as Map<String, dynamic>)['publicUrl'] as String?)
          .whereType<String>()
          .toList(),
      members:
          (json['members'] as List<dynamic>?)
              ?.map((item) => MemberDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static Map<String, dynamic> createBody(Plan plan) {
    final startDate = plan.startDate;
    final endDate = plan.endDate;
    if (startDate == null || endDate == null) {
      throw ArgumentError('Plan startDate and endDate are required');
    }
    return {
      'title': plan.title,
      'description': plan.description,
      'category': plan.category.name.toUpperCase(),
      'coverImageUrl': plan.coverImageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'visibility': plan.visibility.name.toUpperCase(),
      'isSharedToFeed': plan.isSharedToFeed,
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
      visibility: visibility,
      isSharedToFeed: isSharedToFeed,
      commentCount: commentCount,
      likeCount: likeCount,
      likedByMe: likedByMe,
      imageUrls: imageUrls,
      memberUserIds: members
          .map((member) => member.userId)
          .whereType<String>()
          .toList(),
      memberUsers: members
          .map((member) => member.user?.toDomain())
          .whereType<AppUser>()
          .toList(),
    );
  }

  static PlanCategory _categoryFromApi(String? value) {
    return PlanCategory.values.firstWhere(
      (category) => category.name.toUpperCase() == value,
      orElse: () => PlanCategory.personal,
    );
  }

  static PlanVisibility _visibilityFromApi(String? value) {
    return PlanVisibility.values.firstWhere(
      (visibility) => visibility.name.toUpperCase() == value,
      orElse: () => PlanVisibility.private,
    );
  }
}
