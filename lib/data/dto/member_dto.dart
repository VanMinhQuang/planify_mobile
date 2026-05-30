import 'package:planify_mobile/data/dto/app_user_dto.dart';

class MemberDto {
  final String? id;
  final String? planId;
  final String? userId;
  final String? role;
  final DateTime? joinedAt;
  final AppUserDto? user;

  const MemberDto({
    required this.id,
    required this.planId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    required this.user,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
      id: json['id'] as String?,
      planId: json['planId'] as String?,
      userId: json['userId'] as String?,
      role: json['role'] as String?,
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : null,
      user: json['user'] != null
          ? AppUserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
