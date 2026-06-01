import 'package:app_core/app_core.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

import '../bloc/feed_cubit.dart';
import '../widgets/feed_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  late FeedCubit bloc;
  @override
  void initState() {
    super.initState();
    bloc = context.read<FeedCubit>();
    bloc.load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppContainer(
      onRefresh: () => bloc.refresh(),
      hasCustomAppBar: true,
      customAppBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 56.h, 12.w, 8.h),
        child: Row(
          children: [
            Expanded(child: AppLogo()),

            IconButton(
              onPressed: () {
                context.push(Routes.notifications);
              },
              icon: Icon(LucideIcons.bell600),
            ),
            IconButton(
              onPressed: () {
                context.push(Routes.plansNew);
              },
              icon: Icon(LucideIcons.plus600),
            ),
          ],
        ),
      ),
      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state.isLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error.isNotEmpty && state.posts.isEmpty) {
            return _FeedMessage(
              title: 'Feed unavailable',
              message: state.error,
              onRetry: bloc.load,
            );
          }
          if (state.posts.isEmpty) {
            return _FeedMessage(
              title: 'No shared plans yet',
              message: 'Shared plans from you and friends will show here.',
              onRetry: bloc.load,
            );
          }

          return AppSkeleton(
            isLoading: state.isLoading,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 96),
              itemCount: state.posts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return FeedCard(post: post);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _FeedMessage extends StatelessWidget {
  const _FeedMessage({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
