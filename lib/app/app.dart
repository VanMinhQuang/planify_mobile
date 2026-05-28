import 'package:app_core/ui/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/repository/plan_repository.dart';
import '../domain/repository/sign_up_repository.dart';
import '../domain/repository/upload_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'router.dart';
import 'theme.dart';
import 'theme_controller.dart';

class PlanifyApp extends StatefulWidget {
  const PlanifyApp({super.key});

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
    return Sizer(
      builder: (context, orientation) {
        return PlanifyThemeScope(
          controller: _themeController,
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: getIt<AuthRepository>()),
              RepositoryProvider.value(value: getIt<PlanRepository>()),
              RepositoryProvider.value(value: getIt<NotificationRepository>()),
              RepositoryProvider.value(value: getIt<SignUpRepository>()),
              RepositoryProvider.value(value: getIt<UploadRepository>()),
            ],
            child: BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())
                    ..add(AuthStarted()),
              child: Builder(
                builder: (context) {
                  final router = createRouter(context.read<AuthBloc>());
                  return AnimatedBuilder(
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
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
