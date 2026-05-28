import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/repository/notification_repository.dart';
import '../domain/repository/plan_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/views/sign_in_screen.dart';
import '../features/calendar/views/calendar_screen.dart';
import '../features/home/bloc/home_cubit.dart';
import '../features/home/views/home_screen.dart';
import '../features/notifications/bloc/notifications_cubit.dart';
import '../features/notifications/views/notifications_screen.dart';
import '../features/plan/bloc/plan_detail_cubit.dart';
import '../features/plan/views/create_plan_screen.dart';
import '../features/plan/views/plan_detail_screen.dart';
import '../features/profile/views/profile_screen.dart';

class Routes {
  static const home = "/";
  static const signIn = "/sign-in";
  static const plansNew = "/plans/new";
  static const plansDetail = "/plans/:planId";
  static const calendar = "/calendar";
  static const notifications = "/notifications";
  static const profile = "/profile";
}

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isAuthRoute = state.matchedLocation == Routes.signIn;

      if (status == AuthStatus.loading || status == AuthStatus.unknown) {
        return null;
      }
      if (status == AuthStatus.unauthenticated) {
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
