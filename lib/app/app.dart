import 'package:app_core/app_core.dart';
import 'package:app_core/services/notifications/firebase_fcm.dart';
import 'package:app_core/services/notifications/showing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/features/features.dart';

import '../di/injection.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/comment_repository.dart';
import '../domain/repository/feed_repository.dart';
import '../domain/repository/friend_repository.dart';
import '../domain/repository/invitation_repository.dart';
import '../domain/repository/like_repository.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/repository/plan_repository.dart';
import '../domain/repository/profile_repository.dart';
import '../domain/repository/upload_repository.dart';
import 'router.dart';
import 'theme_controller.dart';

class PlanifyApp extends StatefulWidget {
  const PlanifyApp({super.key, required this.firebaseOptions});

  final FirebaseOptions firebaseOptions;

  @override
  State<PlanifyApp> createState() => _PlanifyAppState();
}

class _PlanifyAppState extends State<PlanifyApp> {
  final _themeController = PlanifyThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: Sizer(
        builder: (context, orientation) {
          return PlanifyThemeScope(
            controller: _themeController,
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(value: getIt<AuthRepository>()),
                RepositoryProvider.value(value: getIt<PlanRepository>()),
                RepositoryProvider.value(value: getIt<FeedRepository>()),
                RepositoryProvider.value(value: getIt<FriendRepository>()),
                RepositoryProvider.value(value: getIt<InvitationRepository>()),
                RepositoryProvider.value(value: getIt<CommentRepository>()),
                RepositoryProvider.value(value: getIt<LikeRepository>()),
                RepositoryProvider.value(value: getIt<ProfileRepository>()),
                RepositoryProvider.value(
                  value: getIt<NotificationRepository>(),
                ),
                RepositoryProvider.value(value: getIt<UploadRepository>()),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        AuthBloc(authRepository: context.read<AuthRepository>())
                          ..add(AuthStarted()),
                  ),
                  BlocProvider(
                    create: (context) => NotificationsCubit(
                      notificationRepository: context
                          .read<NotificationRepository>(),
                    )..load(),
                  ),
                  BlocProvider(
                    create: (context) => InvitationsCubit(
                      invitationRepository: context
                          .read<InvitationRepository>(),
                    ),
                  ),
                ],
                child: Builder(
                  builder: (context) {
                    final router = createRouter(context.read<AuthBloc>());
                    return _FcmLifecycleBridge(
                      firebaseOptions: widget.firebaseOptions,
                      child: AnimatedBuilder(
                        animation: _themeController,
                        builder: (context, _) {
                          return MaterialApp.router(
                            title: 'Planify',
                            theme: PlanifyTheme.light(),
                            darkTheme: PlanifyTheme.dark(),
                            themeMode: _themeController.themeMode,
                            routerConfig: router,
                            debugShowCheckedModeBanner: false,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FcmLifecycleBridge extends StatefulWidget {
  const _FcmLifecycleBridge({
    required this.firebaseOptions,
    required this.child,
  });

  final FirebaseOptions firebaseOptions;
  final Widget child;

  @override
  State<_FcmLifecycleBridge> createState() => _FcmLifecycleBridgeState();
}

class _FcmLifecycleBridgeState extends State<_FcmLifecycleBridge> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFcm();
  }

  @override
  void dispose() {
    FirebaseFCM.shared.stopTokenRefreshCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          _startTokenSync();
          return;
        }
        if (state.status == AuthStatus.unauthenticated ||
            state.status == AuthStatus.error) {
          FirebaseFCM.shared.stopTokenRefreshCallback();
        }
      },
      child: widget.child,
    );
  }

  Future<void> _initializeFcm() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseFCM.shared
      ..notiReceived = _handleNotificationReceived
      ..notiOpened = _handleNotificationOpened;

    await FirebaseFCM.shared.initialize(
      options: widget.firebaseOptions,
      showingNotification: Showing(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseFCM.shared.handleInitialMessage();
    });
  }

  Future<void> _startTokenSync() async {
    await FirebaseFCM.shared.startTokenRefreshCallback(
      onTokenRefresh: (_) async {
        if (!mounted) return;
        await context.read<AuthRepository>().registerDevice();
      },
    );
  }

  void _handleNotificationReceived(Map<String, dynamic>? data) {
    if (!mounted) return;
    context.read<NotificationsCubit>().load();
    if (_isInvitationPayload(data)) {
      context.read<InvitationsCubit>().load();
    }
  }

  void _handleNotificationOpened(Map<String, dynamic>? data) {
    if (!mounted || data == null) return;

    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext == null) return;

    final planId = data['planId']?.toString();
    if (planId != null && planId.isNotEmpty) {
      rootContext.push(Routes.planDetailPath(planId));
      return;
    }

    rootContext.push(Routes.notifications);
  }

  bool _isInvitationPayload(Map<String, dynamic>? data) {
    if (data == null) return false;
    final type = data['type']?.toString().toUpperCase();
    final inviteId = data['inviteId']?.toString();
    return type == 'PLAN_INVITATION' ||
        (inviteId != null && inviteId.isNotEmpty);
  }
}
