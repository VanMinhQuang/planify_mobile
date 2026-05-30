import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl = '',
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, avatarUrl];
}
