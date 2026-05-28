import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/repository/plan_repository.dart';
import '../domain/repository/upload_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'router.dart';
import 'theme.dart';

class PlanifyApp extends StatelessWidget {
  const PlanifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: getIt<AuthRepository>()),
        RepositoryProvider.value(value: getIt<PlanRepository>()),
        RepositoryProvider.value(value: getIt<NotificationRepository>()),
        RepositoryProvider.value(value: getIt<UploadRepository>()),
      ],
      child: BlocProvider(
        create: (context) =>
            AuthBloc(authRepository: context.read<AuthRepository>())
              ..add(AuthStarted()),
        child: Builder(
          builder: (context) {
            final router = createRouter(context.read<AuthBloc>());
            return MaterialApp.router(
              title: 'Planify',
              theme: PlanifyTheme.light(),
              darkTheme: PlanifyTheme.dark(),
              themeMode: ThemeMode.system,
              routerConfig: router,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
