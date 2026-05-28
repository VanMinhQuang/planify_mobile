import '../models/app_user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final AppUser user;
  final String accessToken;
  final String refreshToken;
}

abstract interface class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AuthSession> signInWithGoogle();

  Future<AuthSession> registerWithPhonePassword({
    required String phone,
    required String password,
    String? name,
  });

  Future<AuthSession> loginWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<void> signOut();
}
