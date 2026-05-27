import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/notification_repository.dart';
import '../../../domain/models/app_notification.dart';

class NotificationsState extends Equatable {
  const NotificationsState({this.isLoading = false, this.items = const []});

  final bool isLoading;
  final List<AppNotification> items;

  @override
  List<Object?> get props => [isLoading, items];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(const NotificationsState());

  final NotificationRepository _notificationRepository;

  Future<void> load() async {
    emit(const NotificationsState(isLoading: true));
    emit(
      NotificationsState(
        items: await _notificationRepository.listNotifications(),
      ),
    );
  }
}
