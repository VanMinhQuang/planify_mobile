import '../../domain/models/user_profile.dart';
import 'app_user_dto.dart';
import 'friendship_dto.dart';
import 'plan_dto.dart';

class UserProfileDto {
  const UserProfileDto({
    required this.user,
    required this.plans,
    this.friendship,
  });

  final AppUserDto user;
  final FriendshipDto? friendship;
  final List<PlanDto> plans;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      user: AppUserDto.fromJson(json['user'] as Map<String, dynamic>),
      friendship: json['friendship'] == null
          ? null
          : FriendshipDto.fromJson(json['friendship'] as Map<String, dynamic>),
      plans: (json['plans'] as List<dynamic>? ?? [])
          .map((item) => PlanDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  UserProfile toDomain() {
    return UserProfile(
      user: user.toDomain(),
      friendship: friendship?.toDomain(),
      plans: plans.map((plan) => plan.toDomain()).toList(),
    );
  }
}
