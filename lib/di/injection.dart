import 'package:app_core/services/network/sample/restful_token.dart';
import 'package:get_it/get_it.dart';

import '../app/config.dart';
import '../data/api/api_client.dart';
import '../data/impl/auth_repository_impl.dart';
import '../data/impl/comment_repository_impl.dart';
import '../data/impl/feed_repository_impl.dart';
import '../data/impl/friend_repository_impl.dart';
import '../data/impl/invitation_repository_impl.dart';
import '../data/impl/like_repository_impl.dart';
import '../data/impl/notification_repository_impl.dart';
import '../data/impl/plan_repository_impl.dart';
import '../data/impl/profile_repository_impl.dart';
import '../data/impl/upload_repository_impl.dart';
import '../data/services/realtime_service.dart';
import '../data/services/secure_token_store.dart';
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

final getIt = GetIt.instance;

void setupDI(AppConfig config) {
  if (getIt.isRegistered<AppConfig>()) {
    return;
  }

  getIt
    ..registerSingleton<NetworkService>(
      NetworkService(baseUrl: config.apiBaseUrl),
    )
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton<SecureTokenStore>(SecureTokenStore.new)
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<NetworkService>()))
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
    ..registerLazySingleton<FeedRepository>(
      () => FeedRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<FriendRepository>(
      () => FriendRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<InvitationRepository>(
      () => InvitationRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<CommentRepository>(
      () => CommentRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<LikeRepository>(
      () => LikeRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(apiClient: getIt<ApiClient>()),
    )
    ..registerLazySingleton<UploadRepository>(
      () => UploadRepositoryImpl(apiClient: getIt<ApiClient>()),
    );
}
