import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/config/app_config.dart';

class RealtimeService {
  io.Socket? _socket;
  final _events = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _events.stream;

  void connect(String token) {
    _socket?.dispose();
    _socket = io.io(
      AppConfig.realtimeUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    for (final event in [
      'plan:updated',
      'task:created',
      'task:updated',
      'task:deleted',
      'note:created',
      'note:updated',
      'note:deleted',
      'member:joined',
      'member:removed',
      'activity:created',
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
