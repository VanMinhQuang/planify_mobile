import 'package:equatable/equatable.dart';
import 'package:planify_mobile/domain/enum/create_plan_enum.dart';

enum PlanCategory { travel, event, work, personal }

enum PlanVisibility { private, friends, public }

class Plan extends Equatable {
  const Plan({
    this.id = '',
    this.title = '',
    this.category = PlanCategory.personal,
    this.startDate,
    this.endDate,
    this.ownerId = '',
    this.description,
    this.coverImageUrl,
    this.isArchived = false,
    this.visibility = PlanVisibility.private,
    this.isSharedToFeed = false,
    this.commentCount = 0,
    this.likeCount = 0,
    this.likedByMe = false,
    this.memberUserIds = const [],
  });

  final String id;
  final String title;
  final String? description;
  final PlanCategory category;
  final String? coverImageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final String ownerId;
  final bool isArchived;
  final PlanVisibility visibility;
  final bool isSharedToFeed;
  final int commentCount;
  final int likeCount;
  final bool likedByMe;
  final List<String> memberUserIds;

  Plan copyWith({
    String? id,
    String? title,
    String? description,
    PlanCategory? category,
    String? coverImageUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? ownerId,
    bool? isArchived,
    PlanVisibility? visibility,
    bool? isSharedToFeed,
    int? commentCount,
    int? likeCount,
    bool? likedByMe,
    List<String>? memberUserIds,
  }) {
    return Plan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      ownerId: ownerId ?? this.ownerId,
      isArchived: isArchived ?? this.isArchived,
      visibility: visibility ?? this.visibility,
      isSharedToFeed: isSharedToFeed ?? this.isSharedToFeed,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
      memberUserIds: memberUserIds ?? this.memberUserIds,
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
    visibility,
    isSharedToFeed,
    commentCount,
    likeCount,
    likedByMe,
    memberUserIds,
  ];

  Plan copyWithField(CreatePlanField field, Object value) {
    switch (field) {
      case CreatePlanField.title:
        return copyWith(title: value as String);
      case CreatePlanField.description:
        return copyWith(description: value as String);
      case CreatePlanField.category:
        return copyWith(category: value as PlanCategory);
      case CreatePlanField.coverImageUrl:
        return copyWith(coverImageUrl: value as String);
      case CreatePlanField.startDate:
        return copyWith(startDate: value as DateTime);
      case CreatePlanField.endDate:
        return copyWith(endDate: value as DateTime);
      case CreatePlanField.visibility:
        return copyWith(visibility: value as PlanVisibility);
      case CreatePlanField.isSharedToFeed:
        return copyWith(isSharedToFeed: value as bool);
      case CreatePlanField.memberUsers:
        return copyWith(memberUserIds: value as List<String>);
    }
  }
}
