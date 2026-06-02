import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }
          return ListView.builder(
            itemCount: state.items.length + (state.hasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return Center(
                  child: TextButton(
                    onPressed: state.isLoadingMore
                        ? null
                        : context.read<NotificationsCubit>().loadMore,
                    child: state.isLoadingMore
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Load more'),
                  ),
                );
              }
              final notification = state.items[index];
              return ListTile(
                leading: Icon(
                  notification.readAt == null
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_none,
                ),
                title: Text(notification.title),
                subtitle: Text(notification.body),
              );
            },
          );
        },
      ),
    );
  }
}
