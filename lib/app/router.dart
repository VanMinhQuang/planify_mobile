import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/domain/repository/auth_repository.dart';
import 'package:planify_mobile/domain/repository/comment_repository.dart';
import 'package:planify_mobile/domain/repository/feed_repository.dart';
import 'package:planify_mobile/domain/repository/friend_repository.dart';
import 'package:planify_mobile/domain/repository/like_repository.dart';
import 'package:planify_mobile/domain/repository/plan_repository.dart';
import 'package:planify_mobile/domain/repository/profile_repository.dart';
import 'package:planify_mobile/domain/repository/upload_repository.dart';
import 'package:planify_mobile/features/features.dart';
import 'package:planify_mobile/features/plan/create/cubit/create_plan_cubit.dart';

class Routes {
  static const splash = "/splash";
  static const home = "/";
  static const signIn = "/sign-in";
  static const signUp = "/sign-up";
  static const plansNew = "/plans/new";
  static const plansDetail = "/plans/:planId";
  static const calendar = "/calendar";
  static const notifications = "/notifications";
  static const profile = "/profile";
  static const friends = "/friends";
  static const settings = "/settings";

  static String planDetailPath(String planId) => '/plans/$planId';
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter? _routerInstance;

GoRouter createRouter(AuthBloc authBloc) {
  if (_routerInstance != null) return _routerInstance!;
  _routerInstance = GoRouter(
    initialLocation: Routes.splash,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isAuthRoute =
          state.matchedLocation == Routes.signIn ||
          state.matchedLocation == Routes.signUp;
      final isSplashRoute = state.matchedLocation == Routes.splash;

      if (status == AuthStatus.unknown) {
        return isSplashRoute ? null : Routes.splash;
      }
      if (status == AuthStatus.loading) {
        return null;
      }
      if (isSplashRoute) {
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
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
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
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeCubit()),
            BlocProvider(
              create: (context) => FeedCubit(
                feedRepository: context.read<FeedRepository>(),
                likeRepository: context.read<LikeRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) =>
                  CalendarCubit(planRepository: context.read<PlanRepository>()),
            ),
            BlocProvider(
              create: (context) => ProfileCubit(
                profileRepository: context.read<ProfileRepository>(),
                uploadRepository: context.read<UploadRepository>(),
              ),
            ),
          ],
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.plansNew,
        builder: (context, state) => BlocProvider(
          create: (context) => CreatePlanCubit(
            planRepository: context.read<PlanRepository>(),
            uploadRepository: context.read<UploadRepository>(),
          ),
          child: const CreatePlanScreen(),
        ),
      ),
      GoRoute(
        path: Routes.plansDetail,
        builder: (context, state) => BlocProvider(
          create: (context) => PlanDetailCubit(
            planRepository: context.read<PlanRepository>(),
            commentRepository: context.read<CommentRepository>(),
            likeRepository: context.read<LikeRepository>(),
            friendRepository: context.read<FriendRepository>(),
            currentUserId: context.read<AuthBloc>().state.user?.id,
          )..load(state.pathParameters['planId']!),
          child: const PlanDetailScreen(),
        ),
      ),
      GoRoute(
        path: Routes.calendar,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              CalendarCubit(planRepository: context.read<PlanRepository>()),
          child: const CalendarScreen(),
        ),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileCubit(
            profileRepository: context.read<ProfileRepository>(),
            uploadRepository: context.read<UploadRepository>(),
          ),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: Routes.friends,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              FriendsCubit(friendRepository: context.read<FriendRepository>()),
          child: const FriendListScreen(),
        ),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
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
