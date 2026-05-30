part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}

class AuthPhone extends AuthEvent {}

class ChangePhone extends AuthEvent {
  final String phone;
  const ChangePhone(this.phone);

  @override
  List<Object?> get props => [phone];
}

class ChangePassword extends AuthEvent {
  final String password;
  const ChangePassword(this.password);

  @override
  List<Object?> get props => [password];
}

class ChangeObsecure extends AuthEvent {}
