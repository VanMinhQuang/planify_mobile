import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/app_notification.dart';
import '../../../domain/repository/notification_repository.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.isLoading = false,
    this.items = const [],
    this.nextCursor,
    this.hasNextPage = false,
    this.isLoadingMore = false,
  });

  final bool isLoading;
  final List<AppNotification> items;
  final String? nextCursor;
  final bool hasNextPage;
  final bool isLoadingMore;

  NotificationsState copyWith({
    bool? isLoading,
    List<AppNotification>? items,
    Object? nextCursor = _unchanged,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      nextCursor: nextCursor == _unchanged
          ? this.nextCursor
          : nextCursor as String?,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    items,
    nextCursor,
    hasNextPage,
    isLoadingMore,
  ];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(const NotificationsState());

  final NotificationRepository _notificationRepository;

  Future<void> load() async {
    emit(const NotificationsState(isLoading: true));
    final page = await _notificationRepository.listNotifications();
    emit(
      NotificationsState(
        items: page.items,
        nextCursor: page.nextCursor,
        hasNextPage: page.hasNextPage,
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasNextPage || state.isLoadingMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    final page = await _notificationRepository.listNotifications(
      cursor: state.nextCursor,
    );
    emit(
      state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
        hasNextPage: page.hasNextPage,
        isLoadingMore: false,
      ),
    );
  }
}

const _unchanged = Object();
