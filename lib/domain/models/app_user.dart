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

  @override
  List<Object?> get props => [id, name, email, phone, avatarUrl];
}
