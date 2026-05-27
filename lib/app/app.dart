import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/api/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/plan_repository.dart';
import '../data/repositories/upload_repository.dart';
import '../data/services/realtime_service.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'router.dart';
import 'theme.dart';

class PlanifyApp extends StatelessWidget {
  const PlanifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final realtimeService = RealtimeService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiClient),
        RepositoryProvider.value(value: realtimeService),
        RepositoryProvider(
          create: (_) => AuthRepository(
            apiClient: apiClient,
            realtimeService: realtimeService,
          ),
        ),
        RepositoryProvider(create: (_) => PlanRepository(apiClient: apiClient)),
        RepositoryProvider(
          create: (_) => NotificationRepository(apiClient: apiClient),
        ),
        RepositoryProvider(
          create: (_) => UploadRepository(apiClient: apiClient),
        ),
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
              routerConfig: router,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
