import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/notification_repository.dart';
import '../data/repositories/plan_repository.dart';
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

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isAuthRoute = state.matchedLocation == '/sign-in';

      if (status == AuthStatus.loading || status == AuthStatus.unknown) {
        return null;
      }
      if (status == AuthStatus.unauthenticated) {
        return isAuthRoute ? null : '/sign-in';
      }
      if (isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              HomeCubit(planRepository: context.read<PlanRepository>())..load(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/plans/new',
        builder: (context, state) => const CreatePlanScreen(),
      ),
      GoRoute(
        path: '/plans/:planId',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              PlanDetailCubit(planRepository: context.read<PlanRepository>())
                ..load(state.pathParameters['planId']!),
          child: const PlanDetailScreen(),
        ),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => BlocProvider(
          create: (context) => NotificationsCubit(
            notificationRepository: context.read<NotificationRepository>(),
          )..load(),
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
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
