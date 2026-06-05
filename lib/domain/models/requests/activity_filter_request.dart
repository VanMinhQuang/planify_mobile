import 'package:app_core/app_core.dart';

class ActivityFilterRequest extends Equatable {
  const ActivityFilterRequest({this.userId, this.from, this.to});

  final String? userId;
  final DateTime? from;
  final DateTime? to;

  bool get isActive {
    return userId != null && userId!.trim().isNotEmpty ||
        from != null ||
        to != null;
  }

  Map<String, dynamic> toQueryParameters() {
    return {
      ...?(userId == null || userId!.trim().isEmpty
          ? null
          : {'userId': userId!.trim()}),
      ...?(from == null ? null : {'from': from!.toUtc().toIso8601String()}),
      ...?(to == null ? null : {'to': to!.toUtc().toIso8601String()}),
    };
  }

  ActivityFilterRequest copyWith({
    Object? userId = _unchanged,
    Object? from = _unchanged,
    Object? to = _unchanged,
  }) {
    return ActivityFilterRequest(
      userId: userId == _unchanged ? this.userId : userId as String?,
      from: from == _unchanged ? this.from : from as DateTime?,
      to: to == _unchanged ? this.to : to as DateTime?,
    );
  }

  @override
  List<Object?> get props => [userId, from, to];
}

const _unchanged = Object();
