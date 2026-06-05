import 'package:app_core/app_core.dart';
import 'package:planify_mobile/domain/models/plan_note.dart';

class NoteFilterRequest extends Equatable {
  const NoteFilterRequest({
    this.q,
    this.type,
    this.assignedTo,
    this.taskId,
    this.createdBy,
    this.from,
    this.to,
  });

  final String? q;
  final NoteType? type;
  final String? assignedTo;
  final String? taskId;
  final String? createdBy;
  final DateTime? from;
  final DateTime? to;

  bool get isActive {
    return _hasText(q) ||
        type != null ||
        _hasText(assignedTo) ||
        _hasText(taskId) ||
        _hasText(createdBy) ||
        from != null ||
        to != null;
  }

  Map<String, dynamic> toQueryParameters() {
    return {
      ...?(_hasText(q) ? {'q': q!.trim()} : null),
      ...?(type == null ? null : {'type': type!.apiValue}),
      ...?(_hasText(assignedTo) ? {'assignedTo': assignedTo!.trim()} : null),
      ...?(_hasText(taskId) ? {'taskId': taskId!.trim()} : null),
      ...?(_hasText(createdBy) ? {'createdBy': createdBy!.trim()} : null),
      ...?(from == null ? null : {'from': from!.toUtc().toIso8601String()}),
      ...?(to == null ? null : {'to': to!.toUtc().toIso8601String()}),
    };
  }

  NoteFilterRequest copyWith({
    Object? q = _unchanged,
    Object? type = _unchanged,
    Object? assignedTo = _unchanged,
    Object? taskId = _unchanged,
    Object? createdBy = _unchanged,
    Object? from = _unchanged,
    Object? to = _unchanged,
  }) {
    return NoteFilterRequest(
      q: q == _unchanged ? this.q : q as String?,
      type: type == _unchanged ? this.type : type as NoteType?,
      assignedTo: assignedTo == _unchanged
          ? this.assignedTo
          : assignedTo as String?,
      taskId: taskId == _unchanged ? this.taskId : taskId as String?,
      createdBy: createdBy == _unchanged
          ? this.createdBy
          : createdBy as String?,
      from: from == _unchanged ? this.from : from as DateTime?,
      to: to == _unchanged ? this.to : to as DateTime?,
    );
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  @override
  List<Object?> get props => [q, type, assignedTo, taskId, createdBy, from, to];
}

const _unchanged = Object();
