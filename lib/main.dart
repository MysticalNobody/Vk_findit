import 'package:findit/classes/app.dart';
import 'package:findit/classes/config.dart';
import 'package:findit/routes.dart';
import 'package:findit/services/database.dart';
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
  await Config.loadFromDB();
  if (Config.token == null)
    App.processAuth();
  else
    App.processMain();
}
