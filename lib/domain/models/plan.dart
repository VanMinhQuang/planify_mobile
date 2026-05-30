import 'package:equatable/equatable.dart';

enum PlanCategory { travel, event, work, personal }

enum PlanVisibility { private, friends, public }

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
    this.visibility = PlanVisibility.private,
    this.isSharedToFeed = false,
    this.commentCount = 0,
    this.likeCount = 0,
    this.likedByMe = false,
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
  ];
}
