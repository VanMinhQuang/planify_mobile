import 'package:flutter/material.dart';
import 'package:app_core/app_core.dart';
import 'package:planify_mobile/domain/models/plan_comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.onReply,
    required this.onToggleLike,
    this.isReply = false,
  });

  final PlanComment comment;
  final VoidCallback onReply;
  final Function(PlanComment) onToggleLike;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 42 : 0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAppImage(
              imageUrl: comment.user?.avatarUrl,
              name: comment.user?.name,
            ),
            title: Text(comment.user?.name ?? 'Planify user'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.content),
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
                                : null,
                          ),
                          const SizedBox(width: 4),
                          Text('${comment.likeCount}'),
                        ],
                      ),
                    ),
                    if (!isReply) ...[
                      const SizedBox(width: 16),
                      InkWell(onTap: onReply, child: const Text('Reply')),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!isReply)
            ...comment.replies.map(
              (reply) => CommentTile(
                comment: reply,
                onReply: onReply,
                isReply: true,
                onToggleLike: onToggleLike,
              ),
            ),
        ],
      ),
    );
  }
}
