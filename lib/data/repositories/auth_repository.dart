import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/app_user.dart';
import '../api/api_client.dart';
import '../services/realtime_service.dart';

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

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required RealtimeService realtimeService,
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
    FirebaseMessaging? messaging,
  }) : _apiClient = apiClient,
       _realtimeService = realtimeService,
       _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']),
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _messaging = messaging ?? FirebaseMessaging.instance;

  final ApiClient _apiClient;
  final RealtimeService _realtimeService;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _messaging;

  Future<AuthSession?> restoreSession() async {
    final accessToken = await _apiClient.tokenStore.readAccessToken();
    final refreshToken = await _apiClient.tokenStore.readRefreshToken();
    if (accessToken == null || refreshToken == null) {
      return null;
    }

    final response = await _apiClient.dio.get<Map<String, dynamic>>('/me');
    final user = AppUser.fromJson(response.data!);
    _realtimeService.connect(accessToken);
    await _registerDeviceToken();
    return AuthSession(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<AuthSession> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw StateError('Google sign in was cancelled');
    }

    final googleAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final firebaseUser = (await _firebaseAuth.signInWithCredential(
      credential,
    )).user;
    final firebaseIdToken = await firebaseUser?.getIdToken();
    if (firebaseIdToken == null) {
      throw StateError('Firebase Auth did not return an ID token');
    }

    return _createBackendSession('/auth/firebase', {
      'idToken': firebaseIdToken,
    });
  }

  Future<AuthSession> registerWithPhonePassword({
    required String phone,
    required String password,
    String? name,
  }) {
    return _createBackendSession('/auth/phone/register', {
      'phone': phone,
      'password': password,
      'name': name,
    });
  }

  Future<AuthSession> loginWithPhonePassword({
    required String phone,
    required String password,
  }) {
    return _createBackendSession('/auth/phone/login', {
      'phone': phone,
      'password': password,
    });
  }

  Future<void> signOut() async {
    await _apiClient.dio.post('/auth/logout');
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _apiClient.tokenStore.clear();
    _realtimeService.disconnect();
  }

  Future<AuthSession> _createBackendSession(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      path,
      data: body,
    );
    final data = response.data!;
    final session = AuthSession(
      user: AppUser.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
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
    final token = await _messaging.getToken();
    if (token == null) {
      return;
    }
    await _apiClient.dio.post(
      '/device-tokens',
      data: {'token': token, 'platform': 'mobile'},
    );
  }
}
