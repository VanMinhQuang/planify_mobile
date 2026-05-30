import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/router.dart';
import '../../../domain/models/feed_post.dart';
import '../../../domain/models/plan_comment.dart';
import '../../../domain/repository/comment_repository.dart';
import '../bloc/feed_cubit.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state.isLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error.isNotEmpty && state.posts.isEmpty) {
            return _FeedMessage(
              title: 'Feed unavailable',
              message: state.error,
              onRetry: context.read<FeedCubit>().load,
            );
          }
          if (state.posts.isEmpty) {
            return _FeedMessage(
              title: 'No shared plans yet',
              message: 'Shared plans from you and friends will show here.',
              onRetry: context.read<FeedCubit>().load,
            );
          }

          return RefreshIndicator(
            onRefresh: context.read<FeedCubit>().refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: state.posts.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                    'Feed',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
                final post = state.posts[index - 1];
                return _FeedCard(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    final plan = post.plan;
    final dateText =
        '${DateFormat.MMMd().format(plan.startDate)} - ${DateFormat.MMMd().format(plan.endDate)}';
    final isLiking = context.select(
      (FeedCubit cubit) => cubit.state.isLikingPlanIds.contains(plan.id),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Routes.planDetailPath(plan.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: post.owner?.avatarUrl?.isNotEmpty == true
                    ? NetworkImage(post.owner!.avatarUrl!)
                    : null,
                child: post.owner?.avatarUrl?.isNotEmpty == true
                    ? null
                    : const Icon(Icons.person_outline),
              ),
              title: Text(post.owner?.name ?? 'Planify user'),
              subtitle: Text(dateText),
              trailing: Chip(
                label: Text(plan.category.name),
                visualDensity: VisualDensity.compact,
              ),
            ),
            if (plan.coverImageUrl?.isNotEmpty == true)
              AspectRatio(
                aspectRatio: 16 / 10,
                child: CachedNetworkImage(
                  imageUrl: plan.coverImageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                plan.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (plan.description?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                child: Text(
                  plan.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: post.likedByMe ? 'Unlike' : 'Like',
                    onPressed: isLiking
                        ? null
                        : () => context.read<FeedCubit>().toggleLike(post),
                    icon: Icon(
                      post.likedByMe
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: post.likedByMe
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                  Text('${post.likeCount}'),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Comments',
                    onPressed: () => _openComments(context, post),
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                  Text('${post.commentCount}'),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Share',
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(
                        text:
                            '${plan.title}\n$dateText\nplanify://plans/${plan.id}',
                      ),
                    ),
                    icon: const Icon(Icons.ios_share_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openComments(BuildContext context, FeedPost post) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<FeedCubit>(),
        child: _CommentsSheet(post: post),
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet({required this.post});

  final FeedPost post;

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _controller = TextEditingController();
  late Future<List<PlanComment>> _future;
  List<PlanComment> _comments = [];
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _future = context
        .read<CommentRepository>()
        .listComments(widget.post.plan.id)
        .then((value) {
          _comments = value;
          return value;
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<PlanComment>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_comments.isEmpty) {
                      return const Center(child: Text('No comments yet.'));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                comment.user?.avatarUrl?.isNotEmpty == true
                                ? NetworkImage(comment.user!.avatarUrl!)
                                : null,
                            child: comment.user?.avatarUrl?.isNotEmpty == true
                                ? null
                                : const Icon(Icons.person_outline),
                          ),
                          title: Text(comment.user?.name ?? 'Planify user'),
                          subtitle: Text(comment.content),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _isPosting ? null : _post,
                      icon: const Icon(Icons.send_outlined),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _post() async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      return;
    }
    setState(() => _isPosting = true);
    try {
      final comment = await context.read<CommentRepository>().createComment(
        widget.post.plan.id,
        content,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _comments = [..._comments, comment];
        _controller.clear();
        _isPosting = false;
      });
      context.read<FeedCubit>().incrementCommentCount(widget.post.plan.id);
    } catch (_) {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }
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
