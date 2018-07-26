import 'dart:async';
import 'dart:convert';

import 'package:findit/classes/config.dart';
import 'package:findit/runuserrun.dart';

typedef bool ListenCallback(dynamic params);
typedef bool ListenDownCallback();
typedef bool ListenUpCallback();

class Connection {
  static Map<String, ListenCallback> _handlers = {};
  static Map<String, ListenDownCallback> _downHandlers = {};
  static Map<String, ListenUpCallback> _upHandlers = {};

  static int status = 0;

  static open() async {
    if (Config.token == null) return;
    RunUserRun.startConnection(Config.token);
    RunUserRun.receiveData.listen(onMessage);
  }

  static close() {
    RunUserRun.stopConnection();
  }

  static send(dynamic type, [dynamic data]) {
    if (type is String && data != null)
      data = {"type": type, "params": data};
    else if (data == null) data = type;
    RunUserRun.sendConnectionData(json.encode(data));
  }

  static onMessage(List<String> input) {
    print(input[0]);
    if (!input[0].startsWith("w")) return;
    if (input[0] == "wcls") {
      onDone();
      return;
    }
    if (input[0] != "wmsg") return;
    dynamic message = input[1];
    try {
      message = json.decode(message) as Map<String, dynamic>;
    } on Exception {
      return;
    }
    if (!(message is Map) || !message.containsKey("type")) return;
    switch (message['type']) {
      case "token":
        send(Config.token);
        break;
      case "ping":
        onUp();
        break;
      default:
        ListenCallback cb = _handlers[message["type"]];
        if (cb != null)
          if (cb(message["params"])) _handlers.remove(message["type"]);
    }
  }

  static listen(String type, ListenCallback callback) {
    _handlers[type] = callback;
  }

  static unListen(String type) {
    _handlers.remove(type);
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
    List deleteHandlers = [];
    if (status != 0) _downHandlers.forEach((k, c) =>
        deleteHandlers.add(c() ? k : null));
    deleteHandlers.forEach((n) {
      if (n != null) _downHandlers.remove(n);
    });
    status = 1;
    await new Future.delayed(new Duration(seconds: 2));
    open();
  }

  static void onUp() async {
    await new Future.delayed(new Duration(seconds: 2));
    List deleteHandlers = [];
    _upHandlers.forEach((k, c) => deleteHandlers.add(c() ? k : null));
    deleteHandlers.forEach((n) {
      if (n != null) _upHandlers.remove(n);
    });
    status = 2;
  }
}
