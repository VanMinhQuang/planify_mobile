class AttachmentItem {
  final String id;
  final String path;
  final bool isImage;
  final bool isLocal;

  const AttachmentItem({
    required this.id,
    required this.path,
    required this.isImage,
    this.isLocal = true,
  });

  AttachmentItem copyWith({
    String? id,
    String? path,
    bool? isImage,
    bool? isLocal,
  }) {
    return AttachmentItem(
      id: id ?? this.id,
      path: path ?? this.path,
      isImage: isImage ?? this.isImage,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
