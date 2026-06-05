import 'package:planify_mobile/domain/models/plan_note.dart';

class CreateNoteRequest {
  const CreateNoteRequest({
    required this.content,
    this.topic,
    this.type = NoteType.general,
    this.assignedTo,
    this.taskId,
  });

  final String content;
  final String? topic;
  final NoteType type;
  final String? assignedTo;
  final String? taskId;

  Map<String, dynamic> toJson() {
    return {
      'content': content.trim(),
      'type': type.apiValue,
      ...?(_blankToNull(topic) == null ? null : {'topic': topic!.trim()}),
      ...?(_blankToNull(assignedTo) == null
          ? null
          : {'assignedTo': assignedTo!.trim()}),
      ...?(_blankToNull(taskId) == null ? null : {'taskId': taskId!.trim()}),
    };
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
