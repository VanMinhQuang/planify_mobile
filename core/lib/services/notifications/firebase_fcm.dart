import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_core/app_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'showing.dart';

typedef FcmTokenRefreshCallback = FutureOr<void> Function(String token);

/// -------------------------------
/// FCM Handler
/// -------------------------------
@pragma('vm:entry-point')
class FirebaseFCM {
  FirebaseFCM._();

  static final shared = FirebaseFCM._();

  static FirebaseOptions? _options;
  static ShowingNotification? _showingNotification;
  StreamSubscription<String>? _tokenRefreshSubscription;
  FcmTokenRefreshCallback? _tokenRefreshCallback;
  String? _lastSubmittedToken;

  /// Initialize FCM
  Future<void> initialize({
    FirebaseOptions? options,
    required ShowingNotification showingNotification,
  }) async {
    _options = options;
    _showingNotification = showingNotification;

    await CommonUtils.askNotificationPermission();
    await _showingNotification!.initial();
    await iosConfiguration();

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showingNotification!.showNotification(
        message.toShowingData(),
        message.data,
      );
      ShowingNotification.onReceiveNotification(message.data);
    });

    // User taps notification (background -> foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      ShowingNotification.onHandleNotification(message.data);
      ShowingNotification.onReceiveNotification(message.data);
    });

    // Background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Starts listening to FCM token refresh after the user is authenticated.
  Future<void> startTokenRefreshCallback({
    required FcmTokenRefreshCallback onTokenRefresh,
    bool syncCurrentToken = true,
  }) async {
    _tokenRefreshCallback = onTokenRefresh;
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen(_handleTokenRefresh);

    if (syncCurrentToken) {
      final token = await CommonUtils.getFcmToken();
      await _handleTokenRefresh(token);
    }
  }

  Future<void> stopTokenRefreshCallback() async {
    _tokenRefreshCallback = null;
    _lastSubmittedToken = null;
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }

  Future<void> handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return;

    ShowingNotification.onHandleNotification(message.data);
    ShowingNotification.onReceiveNotification(message.data);
  }

  Future<void> _handleTokenRefresh(String token) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty || normalizedToken == _lastSubmittedToken) {
      return;
    }

    final callback = _tokenRefreshCallback;
    if (callback == null) return;

    try {
      await callback(normalizedToken);
      _lastSubmittedToken = normalizedToken;
    } catch (error, stackTrace) {
      developer.log(
        'Failed to handle FCM token refresh',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// iOS foreground presentation
  static Future<void> iosConfiguration() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// -------------------------------
  /// Background handler (release-safe)
  /// -------------------------------
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(options: _options);

    if (message.notification == null) {
      final localShowing = Showing();
      await localShowing.initial();
      localShowing.showNotification(message.toShowingData(), message.data);
    }
  }

  /// -------------------------------
  /// Set callbacks
  /// -------------------------------
  set notiOpened(Function(Map<String, dynamic>? data) onHandleNotification) {
    ShowingNotification.onHandleNotification = onHandleNotification;
  }

  set notiReceived(Function(Map<String, dynamic>? data) onReceived) {
    ShowingNotification.onReceiveNotification = onReceived;
  }

  void handleNotification(Map<String, dynamic>? data) {
    ShowingNotification.onHandleNotification(data);
  }

  void onReceiveNotification(Map<String, dynamic>? data) {
    ShowingNotification.onReceiveNotification(data);
  }
}

/// Extension to convert RemoteMessage to displayable notification
extension RemoteMessageX on RemoteMessage {
  NotificationShowingData? toShowingData() {
    if (notification == null) return null;

    return NotificationShowingData(
      notiHashCode: notification!.hashCode,
      isAndroid: notification!.android != null,
      title: notification!.title,
      body: notification!.body,
    );
  }
}

class PendingFcmNavigation {
  Map<String, dynamic>? _payload;

  void set(Map<String, dynamic> payload) {
    _payload = payload;
  }

  Map<String, dynamic>? consume() {
    final data = _payload;
    _payload = null;
    return data;
  }

  bool get hasPending => _payload != null;
}
