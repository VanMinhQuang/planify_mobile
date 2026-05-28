import 'package:get_it/get_it.dart';

import '../app/config.dart';
import '../data/api/api_client.dart';
import '../data/impl/auth_repository_impl.dart';
import '../data/impl/notification_repository_impl.dart';
import '../data/impl/plan_repository_impl.dart';
import '../data/impl/upload_repository_impl.dart';
import '../data/services/realtime_service.dart';
import '../data/services/secure_token_store.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/repository/plan_repository.dart';
import '../domain/repository/upload_repository.dart';

final getIt = GetIt.instance;

void setupDI(AppConfig config) {
  if (getIt.isRegistered<AppConfig>()) {
    return;
  }

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton<SecureTokenStore>(SecureTokenStore.new)
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        config: getIt<AppConfig>(),
        tokenStore: getIt<SecureTokenStore>(),
      ),
    )
    ..registerLazySingleton<RealtimeService>(
      () => RealtimeService(config: getIt<AppConfig>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        apiClient: getIt<ApiClient>(),
        realtimeService: getIt<RealtimeService>(),
      ),
    )
    ..registerLazySingleton<PlanRepository>(
      () => PlanRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<UploadRepository>(
      () => UploadRepositoryImpl(apiClient: getIt<ApiClient>()),
    );
}
