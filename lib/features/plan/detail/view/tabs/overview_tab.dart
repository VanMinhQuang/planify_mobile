import 'package:app_core/ui/ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify_mobile/domain/models/plan_comment.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';
import 'package:planify_mobile/features/plan/widgets/comment_tile.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key, required this.state});

  final PlanDetailState state;

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlanDetailCubit>();
    final state = widget.state;
    final plan = state.plan;
    final replyingTo = state.replyingTo;
    if (plan == null) {
      return const Center(child: Text('Plan not found'));
    }
    final daysLeft = plan.startDate?.difference(DateTime.now()).inDays ?? 0;
    final imageUrls = plan.imageUrls.isNotEmpty
        ? plan.imageUrls
        : [if (plan.coverImageUrl?.isNotEmpty == true) plan.coverImageUrl!];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: PageView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: imageUrls[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              if (imageUrls.isNotEmpty) const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        daysLeft <= 0
                            ? 'Starting soon'
                            : '$daysLeft days to go',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        plan.description?.isEmpty ?? true
                            ? 'No description yet.'
                            : plan.description!,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            tooltip: plan.likedByMe ? 'Unlike' : 'Like',
                            onPressed: state.isLiking ? null : bloc.toggleLike,
                            icon: Icon(
                              plan.likedByMe
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: plan.likedByMe
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                            ),
                          ),
                          Text('${plan.likeCount} likes'),
                          const SizedBox(width: 18),
                          const Icon(Icons.mode_comment_outlined),
                          const SizedBox(width: 6),
                          Text('${plan.commentCount} comments'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Comments', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (state.comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(child: Text('No comments yet.')),
                )
              else
                ...state.comments.map(
                  (comment) => CommentTile(
                    comment: comment,
                    onToggleLike: (comment) => bloc.toggleCommentLike(comment),
                    onReply: () {
                      bloc.setReplyingTo(comment);
                      _commentController.clear();
                    },
                  ),
                ),
              if (state.commentsHasNextPage)
                Center(
                  child: TextButton(
                    onPressed: state.isLoadingMoreComments
                        ? null
                        : bloc.loadMoreComments,
                    child: state.isLoadingMoreComments
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Load more comments'),
                  ),
                ),
            ],
          ),
        ),
        _StickyCommentComposer(
          controller: _commentController,
          replyingTo: replyingTo,
          isPostingComment: state.isPostingComment,
          onClearReply: bloc.clearReplyingTo,
          onPost: () => _postComment(bloc),
        ),
      ],
    );
  }

  Future<void> _postComment(PlanDetailCubit bloc) async {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      return;
    }
    final replyTarget = bloc.state.replyingTo;
    await bloc.addComment(content, parentCommentId: replyTarget?.id);
    if (!mounted) {
      return;
    }
    _commentController.clear();
  }
}

class _StickyCommentComposer extends StatelessWidget {
  const _StickyCommentComposer({
    required this.controller,
    required this.replyingTo,
    required this.isPostingComment,
    required this.onClearReply,
    required this.onPost,
  });

  final TextEditingController controller;
  final PlanComment? replyingTo;
  final bool isPostingComment;
  final VoidCallback onClearReply;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: .96),
          border: Border(top: BorderSide(color: colors.outlineVariant)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (replyingTo != null) ...[
                InputChip(
                  label: Text(
                    'Replying to ${replyingTo!.user?.name ?? 'comment'}',
                  ),
                  onDeleted: onClearReply,
                ),
                const SizedBox(height: 6),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormFieldComponent(
                      controller: controller,
                      minLine: 1,
                      maxLine: 4,
                      placeholder: replyingTo == null
                          ? 'Add a comment'
                          : 'Write a reply',
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: replyingTo == null ? 'Comment' : 'Reply',
                    onPressed: isPostingComment ? null : onPost,
                    icon: const Icon(Icons.send_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
