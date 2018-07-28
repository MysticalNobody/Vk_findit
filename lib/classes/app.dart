import 'dart:collection';

import 'package:findit/screens/game.dart';
import 'package:findit/screens/registration.dart';
import 'package:findit/services/connection.dart';
import 'package:findit/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:permissions/permissions.dart';

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
      home: new RegistrationScreen(),
    ));
  }

  static processMain() async {
    Connection.listenDown("app", down);
    Connection.listenUp("app", up);
    if (!await Permissions.checkPermission(Permission.AccessFineLocation))
      await Permissions.requestPermission(Permission.AccessFineLocation);

    Connection.open();


    runApp(new MaterialApp(
      title: "run/user/run",
      home: new GameScreen(),
    ));
  }

  static bool down() {
    Utils.showInSnackBar(App.lastScaffoldKey, "Нет связи с hack/net");
    return false;
  }

  static bool up() {
    Utils.showInSnackBar(App.lastScaffoldKey, "Связь с hack/net восстановлена");
    return false;
  }
}
