import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../app/config.dart';

class RealtimeService {
  RealtimeService({required AppConfig config}) : _config = config;

  final AppConfig _config;
  io.Socket? _socket;
  final _events = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _events.stream;

  void connect(String token) {
    _socket?.dispose();
    _socket = io.io(
      _config.realtimeUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    for (final event in [
      'plan:updated',
      'plan:liked',
      'plan:unliked',
      'task:created',
      'task:updated',
      'task:deleted',
      'note:created',
      'note:updated',
      'note:deleted',
      'member:joined',
      'member:removed',
      'member:updated',
      'activity:created',
      'feed:plan_shared',
      'comment:created',
      'comment:deleted',
      'friend:request_created',
      'friend:request_accepted',
    ]) {
      _socket!.on(event, (payload) {
        _events.add({'event': event, 'payload': payload});
      });
    }

    _socket!.connect();
  }

  void joinPlan(String planId) =>
      _socket?.emit('plan:join', {'planId': planId});

  void leavePlan(String planId) =>
      _socket?.emit('plan:leave', {'planId': planId});

  void disconnect() => _socket?.dispose();
}
