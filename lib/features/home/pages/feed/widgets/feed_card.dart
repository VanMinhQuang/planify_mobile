import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/app/router.dart';
import 'package:planify_mobile/domain/models/feed_post.dart';
import 'package:planify_mobile/features/home/pages/feed/bloc/feed_cubit.dart';
import 'package:planify_mobile/features/home/pages/feed/widgets/feed_comment_modal.dart';
import 'package:share_plus/share_plus.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({required this.post, super.key});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    final plan = post.plan;
    final dateText = _formatRange(plan.startDate, plan.endDate);
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
                child: AppImage(url: plan.coverImageUrl!, fit: BoxFit.cover),
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
                    icon: const Icon(LucideIcons.messageCircleMore400),
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
                    icon: const Icon(LucideIcons.forward400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'No date';
    }
    return '${startDate.toMMdd()} - ${endDate.toMMdd()}';
  }

  void _openComments(BuildContext context, FeedPost post) {
    SheetUtils.openCustomBottomSheet(
      context: context,
      builder: (context) {
        return CommentsSheet(post: post);
      },
    );
  }
}
