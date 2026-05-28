import '../../domain/models/app_user.dart';

class AppUserDto {
  const AppUserDto({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;

  factory AppUserDto.fromJson(Map<String, dynamic> json) {
    return AppUserDto(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  AppUser toDomain() {
    return AppUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }
}
