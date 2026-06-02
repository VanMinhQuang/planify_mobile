import 'package:equatable/equatable.dart';

import 'app_user.dart';
import 'plan.dart';

class PlanInvitation extends Equatable {
  const PlanInvitation({
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

  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isAccepted => status.toUpperCase() == 'ACCEPTED';
  bool get isDeclined => status.toUpperCase() == 'DECLINED';

  PlanInvitation copyWith({String? status, DateTime? respondedAt}) {
    return PlanInvitation(
      id: id,
      code: code,
      planId: planId,
      createdBy: createdBy,
      inviteeId: inviteeId,
      status: status ?? this.status,
      role: role,
      createdAt: createdAt,
      expiresAt: expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
      planTitle: planTitle,
      planCategory: planCategory,
      planCoverImageUrl: planCoverImageUrl,
      planStartDate: planStartDate,
      planEndDate: planEndDate,
      creator: creator,
    );
  }

  @override
  List<Object?> get props => [
    id,
    code,
    planId,
    createdBy,
    inviteeId,
    status,
    role,
    createdAt,
    expiresAt,
    respondedAt,
    planTitle,
    planCategory,
    planCoverImageUrl,
    planStartDate,
    planEndDate,
    creator,
  ];
}
