import 'dart:async';

import 'package:findit/game.dart';
import 'package:findit/intro.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static Router _router = new Router();

  static void initRoutes() {
    _router.define("/intro", handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new IntroScreen();
    }));
    _router.define("/game", handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new GameScreen();
    }));
  }

  static Future<dynamic> navigateTo(BuildContext context, String route,
      {TransitionType transition = TransitionType.fadeIn, bool replace = false}) {
    return _router.navigateTo(context, route, replace: replace, transition: transition);
  }

  static void backTo(BuildContext context, String path) {
    Navigator.of(context).popUntil((Route<dynamic> route) {
      return route == null || route is ModalRoute && route.settings.name == path;
    });
  }
}
