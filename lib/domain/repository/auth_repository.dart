import 'package:planify_mobile/data/api/auth_session.dart';

import '../models/app_user.dart';

abstract interface class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AppUser> signInWithGoogle();

  Future<void> registerWithPhonePassword({
    required String phone,
    required String password,
    String? name,
  });

  Future<AppUser> loginWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<void> signOut();

  Future<void> registerDevice();
}
