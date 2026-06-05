class CreateCommentRequest {
  const CreateCommentRequest({required this.content, this.parentCommentId});

  final String content;
  final String? parentCommentId;

  Map<String, dynamic> toJson() {
    return {
      'content': content.trim(),
      ...?(parentCommentId == null
          ? null
          : {'parentCommentId': parentCommentId}),
    };
  }
}
