import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repository/auth_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../dto/app_user_dto.dart';
import '../services/realtime_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required RealtimeService realtimeService,
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
    FirebaseMessaging? firebaseMessaging,
  }) : _apiClient = apiClient,
       _realtimeService = realtimeService,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  final ApiClient _apiClient;
  final RealtimeService _realtimeService;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _firebaseMessaging;

  @override
  Future<AuthSession?> restoreSession() async {
    final accessToken = await _apiClient.tokenStore.readAccessToken();
    final refreshToken = await _apiClient.tokenStore.readRefreshToken();
    if (accessToken == null || refreshToken == null) {
      return null;
    }

    final user = await _apiClient.get(
      ApiUrl.me,
      parser: (json) =>
          AppUserDto.fromJson(json as Map<String, dynamic>).toDomain(),
    );
    _realtimeService.connect(accessToken);
    await _registerDeviceToken();
    return AuthSession(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    final account = await _googleSignIn.authenticate();
    final googleAuth = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final firebaseUser = (await _firebaseAuth.signInWithCredential(
      credential,
    )).user;
    final firebaseIdToken = await firebaseUser?.getIdToken();
    if (firebaseIdToken == null) {
      throw StateError('Firebase Auth did not return an ID token');
    }

    return _createBackendSession(ApiUrl.authFirebase, {
      'idToken': firebaseIdToken,
    });
  }

  @override
  Future<AuthSession> registerWithPhonePassword({
    required String phone,
    required String password,
    String? name,
  }) {
    return _createBackendSession(ApiUrl.authPhoneRegister, {
      'phone': phone,
      'password': password,
      'name': name,
    });
  }

  @override
  Future<AuthSession> loginWithPhonePassword({
    required String phone,
    required String password,
  }) {
    return _createBackendSession(ApiUrl.authPhoneLogin, {
      'phone': phone,
      'password': password,
    });
  }

  @override
  Future<void> signOut() async {
    try {
      await _apiClient.post(ApiUrl.authLogout, parser: (_) => null);
    } finally {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _apiClient.tokenStore.clear();
      _realtimeService.disconnect();
    }
  }

  Future<AuthSession> _createBackendSession(
    String path,
    Map<String, dynamic> body,
  ) async {
    final session = await _apiClient.post(
      path,
      data: body,
      parser: (json) {
        final data = json as Map<String, dynamic>;
        return AuthSession(
          user: AppUserDto.fromJson(
            data['user'] as Map<String, dynamic>,
          ).toDomain(),
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
      },
    );

    await _apiClient.tokenStore.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    _realtimeService.connect(session.accessToken);
    await _registerDeviceToken();
    return session;
  }

  Future<void> _registerDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await _apiClient.post(
      ApiUrl.deviceTokens,
      data: {'token': token, 'platform': 'mobile'},
      parser: (_) => null,
    );
  }
}
