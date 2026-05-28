part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.message,
    this.phone = '',
    this.password = '',
    this.isObsecure = true,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? message;
  final String phone;
  final String password;
  final bool isObsecure;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? message,
    bool clearUser = false,
    String? phone,
    String? password,
    bool? isObsecure,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      message: message,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isObsecure: isObsecure ?? this.isObsecure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    message,
    phone,
    password,
    isObsecure,
  ];
}
