import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/domain/repository/auth_repository.dart';
import 'package:planify_mobile/domain/repository/notification_repository.dart';
import 'package:planify_mobile/domain/repository/plan_repository.dart';
import 'package:planify_mobile/features/features.dart';

class Routes {
  static const home = "/";
  static const signIn = "/sign-in";
  static const signUp = "/sign-up";
  static const plansNew = "/plans/new";
  static const plansDetail = "/plans/:planId";
  static const calendar = "/calendar";
  static const notifications = "/notifications";
  static const profile = "/profile";
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter? _routerInstance;

GoRouter createRouter(AuthBloc authBloc) {
  if (_routerInstance != null) return _routerInstance!;
  _routerInstance = GoRouter(
    initialLocation: Routes.signIn,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isAuthRoute =
          state.matchedLocation == Routes.signIn ||
          state.matchedLocation == Routes.signUp;

      if (status == AuthStatus.loading || status == AuthStatus.unknown) {
        return null;
      }
      if (status == AuthStatus.unauthenticated || status == AuthStatus.error) {
        return isAuthRoute ? null : Routes.signIn;
      }
      if (isAuthRoute) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              SignUpBloc(authRepository: context.read<AuthRepository>()),
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              HomeCubit(planRepository: context.read<PlanRepository>())..load(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.plansNew,
        builder: (context, state) => const CreatePlanScreen(),
      ),
      GoRoute(
        path: Routes.plansDetail,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              PlanDetailCubit(planRepository: context.read<PlanRepository>())
                ..load(state.pathParameters['planId']!),
          child: const PlanDetailScreen(),
        ),
      ),
      GoRoute(
        path: Routes.calendar,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => BlocProvider(
          create: (context) => NotificationsCubit(
            notificationRepository: context.read<NotificationRepository>(),
          )..load(),
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  return _routerInstance!;
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
