import 'package:findit/classes/app.dart';
import 'package:findit/screens/intro.dart';
import 'package:findit/routes.dart';
import 'package:findit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main() {
  Routes.initRoutes();
  startHome();
}

void startHome() async {
  var db = new DataBase();
  if (!await db.open()) {
    await db.open();
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  App.processMain();

  runApp(new MaterialApp(
    title: "/run/user/run",
    home: new IntroScreen()
  ));
}