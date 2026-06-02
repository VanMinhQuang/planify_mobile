import '../../domain/models/app_user.dart';
import '../../domain/models/plan.dart';
import '../../domain/models/plan_invitation.dart';
import 'app_user_dto.dart';

class PlanInvitationDto {
  const PlanInvitationDto({
    required this.id,
    required this.code,
    required this.planId,
    required this.createdBy,
    required this.status,
    required this.role,
    this.createdAt,
    this.inviteeId,
    this.expiresAt,
    this.respondedAt,
    this.planTitle = '',
    this.planCategory = PlanCategory.personal,
    this.planCoverImageUrl,
    this.planStartDate,
    this.planEndDate,
    this.creator,
  });

  final String id;
  final String code;
  final String planId;
  final String createdBy;
  final String? inviteeId;
  final String status;
  final String role;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? respondedAt;
  final String planTitle;
  final PlanCategory planCategory;
  final String? planCoverImageUrl;
  final DateTime? planStartDate;
  final DateTime? planEndDate;
  final AppUser? creator;

  factory PlanInvitationDto.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] as Map<String, dynamic>? ?? {};
    final creatorJson = json['creator'] as Map<String, dynamic>?;
    return PlanInvitationDto(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      planId: json['planId'] as String? ?? plan['id'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      inviteeId: json['inviteeId'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      role: json['role'] as String? ?? 'EDITOR',
      createdAt: _date(json['createdAt']),
      expiresAt: _date(json['expiresAt']),
      respondedAt: _date(json['respondedAt']),
      planTitle: plan['title'] as String? ?? '',
      planCategory: _category(plan['category'] as String?),
      planCoverImageUrl: plan['coverImageUrl'] as String?,
      planStartDate: _date(plan['startDate']),
      planEndDate: _date(plan['endDate']),
      creator: creatorJson == null
          ? null
          : AppUserDto.fromJson(creatorJson).toDomain(),
    );
  }

  PlanInvitation toDomain() {
    return PlanInvitation(
      id: id,
      code: code,
      planId: planId,
      createdBy: createdBy,
      inviteeId: inviteeId,
      status: status,
      role: role,
      createdAt: createdAt,
      expiresAt: expiresAt,
      respondedAt: respondedAt,
      planTitle: planTitle,
      planCategory: planCategory,
      planCoverImageUrl: planCoverImageUrl,
      planStartDate: planStartDate,
      planEndDate: planEndDate,
      creator: creator,
    );
  }

  static DateTime? _date(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static PlanCategory _category(String? value) {
    return PlanCategory.values.firstWhere(
      (category) => category.name.toUpperCase() == value,
      orElse: () => PlanCategory.personal,
    );
  }
}
