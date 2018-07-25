import 'dart:async';
import 'dart:convert';

import 'package:findit/classes/config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef void ListenCallback(dynamic params);
typedef void ListenDownCallback();
typedef void ListenUpCallback();

class Connection {
  static final String url = "137.117.155.208";
  static final int port = 6456;

  static IOWebSocketChannel _channel;
  static bool _isDown = false;

  static Map<String, ListenCallback> _handlers = {};
  static Map<String, ListenDownCallback> _downHandlers = {};
  static Map<String, ListenUpCallback> _upHandlers = {};

  static open([bool start]) async {
    _channel = IOWebSocketChannel.connect("ws://$url:$port");
    _channel.stream.listen(onMessage, onDone: onDone, onError: (error) {
      if (start) onDone();
    });
  }

  static close() {
    if (_channel == null) return;
    _channel.sink.close(status.goingAway);
  }

  static send(dynamic type, [dynamic data]) {
    if (_channel == null) return;
    if (type is String && data != null)
      data = {"type": type, "params": data};
    else if (data == null) data = type;
    _channel.sink.add(json.encode(data));
  }

  static listen(String type, ListenCallback callback) {
    _handlers[type] = callback;
  }

  static unListen(String type) {
    _handlers.remove(type);
  }

  static onMessage(dynamic message) {
    print('MESSAGE: '+ message);
    try {
      message = json.decode(message) as Map<String, dynamic>;
    } on Exception {
      return;
    }
    if (!(message is Map) || !message.containsKey("type")) return;
    print(message);
    dynamic params = message["params"];
    switch (message['type']) {
      case "ping":
        onUp();
        break;
      default:
        ListenCallback cb = _handlers[message["type"]];
        if (cb != null) cb(message["params"]);
    }
  }

  static listenDown(String type, ListenDownCallback callback) {
    _downHandlers[type] = callback;
  }

  static unListenDown(String type) {
    _downHandlers.remove(type);
  }

  static listenUp(String type, ListenUpCallback callback) {
    _upHandlers[type] = callback;
  }

  static unListenUp(String type) {
    _upHandlers.remove(type);
  }

  static void onDone() async {
    if (!_isDown) _downHandlers.forEach((k, c) => c());
    _isDown = true;
    await new Future.delayed(new Duration(seconds: 2));
    open();
  }

  static void onUp() {
    if (_isDown) _upHandlers.forEach((k, c) => c());
    _isDown = false;
  }
}