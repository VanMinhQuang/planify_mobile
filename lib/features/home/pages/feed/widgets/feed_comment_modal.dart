import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/feed_post.dart';
import 'package:planify_mobile/domain/models/paged_result.dart';
import 'package:planify_mobile/domain/models/plan_comment.dart';
import 'package:planify_mobile/domain/repository/comment_repository.dart';
import 'package:planify_mobile/features/home/pages/feed/bloc/feed_cubit.dart';

class CommentsSheet extends StatefulWidget {
  const CommentsSheet({super.key, required this.post});

  final FeedPost post;

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _controller = TextEditingController();
  late Future<PagedResult<PlanComment>> _future;
  List<PlanComment> _comments = [];
  bool _isPosting = false;
  bool _isLoadingMore = false;
  String? _nextCursor;
  bool _hasNextPage = false;
  PlanComment? _replyingTo;

  @override
  void initState() {
    super.initState();
    _future = context
        .read<CommentRepository>()
        .listComments(widget.post.plan.id)
        .then((value) {
          _comments = value.items;
          _nextCursor = value.nextCursor;
          _hasNextPage = value.hasNextPage;
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
    final colors = Theme.of(context).colorScheme;
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
          return SafeArea(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: context.gradients.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: .32),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Comments',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<PagedResult<PlanComment>>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colors.primary,
                            ),
                          );
                        }
                        if (_comments.isEmpty) {
                          return Center(
                            child: Text(
                              'No comments yet.',
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: _comments.length + (_hasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _comments.length) {
                              return Center(
                                child: TextButton(
                                  onPressed: _isLoadingMore ? null : _loadMore,
                                  child: _isLoadingMore
                                      ? const SizedBox.square(
                                          dimension: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Load more comments'),
                                ),
                              );
                            }
                            final comment = _comments[index];
                            return _SheetCommentTile(
                              comment: comment,
                              onReply: () {
                                setState(() {
                                  _replyingTo = comment;
                                  _controller.clear();
                                });
                              },
                              onToggleLike: _toggleCommentLike,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: .86),
                      border: Border(
                        top: BorderSide(color: colors.outlineVariant),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_replyingTo != null)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InputChip(
                                      backgroundColor: colors.primaryContainer,
                                      labelStyle: TextStyle(
                                        color: colors.onPrimaryContainer,
                                      ),
                                      deleteIconColor:
                                          colors.onPrimaryContainer,
                                      label: Text(
                                        'Replying to ${_replyingTo!.user?.name ?? 'comment'}',
                                      ),
                                      onDeleted: () =>
                                          setState(() => _replyingTo = null),
                                    ),
                                  ),
                                TextFormFieldComponent(
                                  controller: _controller,
                                  maxLine: 3,
                                  minLine: 1,
                                  placeholder: _replyingTo == null
                                      ? 'Add a comment'
                                      : 'Write a reply',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              disabledBackgroundColor:
                                  colors.surfaceContainerHighest,
                              disabledForegroundColor: colors.onSurfaceVariant,
                            ),
                            onPressed: _isPosting ? null : _post,
                            icon: const Icon(Icons.send_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        parentCommentId: _replyingTo?.id,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _comments = _replyingTo == null
            ? [..._comments, comment]
            : _addReply(_replyingTo!.id, comment);
        _controller.clear();
        _replyingTo = null;
        _isPosting = false;
      });
      context.read<FeedCubit>().incrementCommentCount(widget.post.plan.id);
    } catch (_) {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  Future<void> _loadMore() async {
    if (!_hasNextPage || _isLoadingMore) {
      return;
    }
    setState(() => _isLoadingMore = true);
    try {
      final page = await context.read<CommentRepository>().listComments(
        widget.post.plan.id,
        cursor: _nextCursor,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _comments = [..._comments, ...page.items];
        _nextCursor = page.nextCursor;
        _hasNextPage = page.hasNextPage;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _toggleCommentLike(PlanComment comment) async {
    final nextLiked = !comment.likedByMe;
    final nextCount = comment.likeCount + (nextLiked ? 1 : -1);
    final previous = _comments;
    setState(() {
      _comments = _replaceComment(
        comment.copyWith(
          likedByMe: nextLiked,
          likeCount: nextCount < 0 ? 0 : nextCount,
        ),
      );
    });

    try {
      if (nextLiked) {
        await context.read<CommentRepository>().likeComment(
          widget.post.plan.id,
          comment.id,
        );
      } else {
        await context.read<CommentRepository>().unlikeComment(
          widget.post.plan.id,
          comment.id,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _comments = previous);
      }
    }
  }

  List<PlanComment> _addReply(String parentCommentId, PlanComment reply) {
    return _comments.map((comment) {
      if (comment.id != parentCommentId) {
        return comment;
      }
      return comment.copyWith(
        replies: [...comment.replies, reply],
        replyCount: comment.replyCount + 1,
      );
    }).toList();
  }

  List<PlanComment> _replaceComment(PlanComment updated) {
    return _comments.map((comment) {
      if (comment.id == updated.id) {
        return updated;
      }
      return comment.copyWith(
        replies: comment.replies
            .map((reply) => reply.id == updated.id ? updated : reply)
            .toList(),
      );
    }).toList();
  }
}

class _SheetCommentTile extends StatelessWidget {
  const _SheetCommentTile({
    required this.comment,
    required this.onReply,
    required this.onToggleLike,
    this.isReply = false,
  });

  final PlanComment comment;
  final VoidCallback onReply;
  final ValueChanged<PlanComment> onToggleLike;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 42 : 0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              backgroundImage: comment.user?.avatarUrl?.isNotEmpty == true
                  ? NetworkImage(comment.user!.avatarUrl!)
                  : null,
              child: comment.user?.avatarUrl?.isNotEmpty == true
                  ? null
                  : Icon(
                      Icons.person_outline,
                      color: colors.onPrimaryContainer,
                    ),
            ),
            title: Text(
              comment.user?.name ?? 'Planify user',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.content,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    InkWell(
                      onTap: () => onToggleLike(comment),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            comment.likedByMe
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            size: 16,
                            color: comment.likedByMe
                                ? Theme.of(context).colorScheme.error
                                : colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likeCount}',
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    if (!isReply) ...[
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: onReply,
                        child: Text(
                          'Reply',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!isReply)
            ...comment.replies.map(
              (reply) => _SheetCommentTile(
                comment: reply,
                onReply: onReply,
                onToggleLike: onToggleLike,
                isReply: true,
              ),
            ),
        ],
      ),
    );
  }
}
