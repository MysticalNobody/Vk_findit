import 'dart:collection';

import 'package:findit/screens/game.dart';
import 'package:findit/screens/intro.dart';
import 'package:findit/screens/registration.dart';
import 'package:findit/screens/registration/photo.dart';
import 'package:findit/services/connection.dart';
import 'package:findit/services/utils.dart';
import 'package:flutter/material.dart';

class App {
  static var _scaffoldKeys = new Queue<GlobalKey<ScaffoldState>>();

  static GlobalKey<ScaffoldState> get lastScaffoldKey {
    return _scaffoldKeys.last;
  }

  static pushScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKeys.addLast(key);
  }

  static GlobalKey<ScaffoldState> popScaffoldKey() {
    return _scaffoldKeys.removeLast();
  }

  static processAuth() async {
    runApp(new MaterialApp(
      title: "run/user/run",
      home: new IntroScreen(),
    ));
  }

  static processMain() async {
    Connection.open(true);
    Connection.listenDown("app", down);
    Connection.listenUp("app", up);


    runApp(new MaterialApp(
      title: "run/user/run",
      home: new GameScreen(),
    ));
  }

  static void down() {
    Utils.showInSnackBar(App.lastScaffoldKey, "Нет связи с сервером. Пытаемся восстановить");
  }

  static void up() {
    Utils.showInSnackBar(App.lastScaffoldKey, "Связь с сервером восстановлена");
  }
}
