import 'dart:async';

import 'package:findit/screens/game.dart';
import 'package:findit/screens/intro.dart';
import 'package:findit/screens/registration.dart';
import 'package:findit/screens/registration/code.dart';
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
    _router.define("/register", handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new RegistrationScreen();
    }));
    _router.define("/code", handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new CodeScreen();
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
