import 'dart:async';

import 'package:flutter/services.dart';

class RunUserRun {
  static const MethodChannel _channel = const MethodChannel('itis.games.run');
  static const EventChannel _streamChannel = const EventChannel(
      'itis.games.run/stream');


  static startConnection(String token) async {
    return await _channel.invokeMethod('startConnection', token);
  }

  static stopConnection() async {
    return await _channel.invokeMethod('stopConnection');
  }

  static sendConnectionData(String data) async {
    print("sending: " + data);
    return await _channel.invokeMethod('sendConnectionData', data);
  }

  static Stream<List<String>> get receiveData {
    return _streamChannel.receiveBroadcastStream().map((_) {
      String type = (_ as String).substring(0, 4);
      String data = (_ as String).substring(4);
      print([type, data]);
      return [type, data];
    });
  }
}