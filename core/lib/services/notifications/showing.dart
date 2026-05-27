import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// -------------------------------
/// Base class for showing notifications
/// -------------------------------
@pragma('vm:entry-point')
abstract class ShowingNotification {
  static late Function(Map<String, dynamic>? data) onHandleNotification;
  static late Function(Map<String, dynamic>? data) onReceiveNotification;

  Future<void> initial();
  void showNotification(
    NotificationShowingData? showingData,
    Map<String, dynamic> payload,
  );
}

/// -------------------------------
/// Local notifications implementation
/// -------------------------------
@pragma('vm:entry-point')
class Showing extends ShowingNotification {
  static late AndroidNotificationChannel channel;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static bool isFlutterLocalNotificationsInitialized = false;

  @override
  Future<void> initial() async {
    if (isFlutterLocalNotificationsInitialized) return;

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _createNotificationChannel();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: [
            DarwinNotificationAction.plain(
              'id_3',
              'Open Screen',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  /// -------------------------------
  /// Show a notification
  /// -------------------------------
  @override
  void showNotification(
    NotificationShowingData? showingData,
    Map<String, dynamic> payload,
  ) {
    if (showingData == null || kIsWeb) return;

    flutterLocalNotificationsPlugin.show(
      id: showingData.notiHashCode,
      title: showingData.title,
      body: showingData.body,
      notificationDetails: NotificationDetails(
        android: showingData.isAndroid
            ? AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              )
            : null,
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'demoCategory',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(payload),
    );
  }

  /// -------------------------------
  /// Android notification channel
  /// -------------------------------
  Future<void> _createNotificationChannel() async {
    if (!Platform.isAndroid) return;

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}

/// -------------------------------
/// Notification data model
/// -------------------------------
class NotificationShowingData {
  final int notiHashCode;
  final String? title;
  final String? body;
  final bool isAndroid;

  NotificationShowingData({
    required this.notiHashCode,
    required this.isAndroid,
    this.title,
    this.body,
  });
}

/// -------------------------------
/// Notification response handlers
/// -------------------------------
@pragma('vm:entry-point')
void _onDidReceiveNotificationResponse(NotificationResponse details) {
  if (details.payload == null) return;
  final data = jsonDecode(details.payload!);
  ShowingNotification.onHandleNotification(data);
}

@pragma('vm:entry-point')
void _onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
  if (details.payload == null) return;
  final data = jsonDecode(details.payload!);
  ShowingNotification.onHandleNotification(data);
}
