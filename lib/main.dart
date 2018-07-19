import 'package:findit/intro.dart';
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
  runApp(new MaterialApp(
    title: "Itis.cards",
    home: new IntroScreen()
  ));
}