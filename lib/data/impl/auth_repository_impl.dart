import 'package:app_core/app_core.dart';
import 'package:planify_mobile/data/api/auth_session.dart';
import 'package:planify_mobile/domain/models/app_user.dart';

import '../../domain/repository/auth_repository.dart';
import '../api/api_client.dart';
import '../constants/api_url.dart';
import '../services/realtime_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required RealtimeService realtimeService,
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  }) : _apiClient = apiClient,
       _realtimeService = realtimeService,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final ApiClient _apiClient;
  final RealtimeService _realtimeService;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<AppUser> loginWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    try {
      final result = await _apiClient.authenticate(
        path: ApiUrl.authPhoneLogin,
        body: {'phone': phone, 'password': password},
      );
      _realtimeService.connect(result.accessToken);
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerWithPhonePassword({
    required String phone,
    required String password,
    String? name,
  }) async {
    try {
      await _apiClient.post(
        path: ApiUrl.authPhoneRegister,
        body: {'phone': phone, 'password': password, 'name': name},
        parser: (json) => '',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthSession?> restoreSession() async {
    return null;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
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

      final result = await _apiClient.authenticate(
        path: ApiUrl.authFirebase,
        body: {'idToken': firebaseIdToken},
      );
      _realtimeService.connect(result.accessToken);
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _apiClient.post(
        path: ApiUrl.authLogout,
        body: {},
        parser: (_) => null,
      );
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _apiClient.clearToken();
      _realtimeService.disconnect();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerDevice() async {
    try {
      final token = await CommonUtils.getFcmToken();

      if (token.isEmpty) {
        return;
      }

      await _apiClient.post(
        path: ApiUrl.deviceTokens,
        body: {'token': token, 'platform': 'mobile'},
        parser: (_) => null,
      );
    } catch (e) {
      rethrow;
    }
  }
}
