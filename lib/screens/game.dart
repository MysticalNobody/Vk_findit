import 'dart:async';

import 'package:findit/classes/app.dart';
import 'package:findit/classes/config.dart';
import 'package:findit/screens/game/target.dart';
import 'package:findit/screens/game/hacked.dart';
import 'package:findit/services/connection.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:video_player/video_player.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => new _GameScreenState();
}

VideoPlayerController controllerBg;
VideoPlayerController controllerBgHacked;
AnimationController animationController;
int distance;
int status = 1;

bool started = false;

getSize(BuildContext context) {
  return MediaQuery
      .of(context)
      .size
      .width - 100;
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getSize(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width - 100;
  }

  @override
  initState() {
    super.initState();
    controllerBg = VideoPlayerController.asset('assets/bg.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    controllerBg.setLooping(true);
    controllerBg.play();

    controllerBgHacked = VideoPlayerController.asset('assets/bg_hacked.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    controllerBgHacked.setLooping(true);
    controllerBgHacked.play();

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );

    animationController.repeat();
    Connection.listen("game.status", (params) {
      setState(() {
        distance = params['distance'];
        status = params['status'];
        if (Config.targetId != params['target_id']) {
          Config.targetId = params['target_id'];
          Config.saveToDB();
        }
      });
      return false;
    });

    Connection.listenUp("open", () {
      setState(() {
        status = 1;
      });
      return false;
    });
    App.pushScaffoldKey(_scaffoldKey);
  }

  @override
  void dispose() {
    super.dispose();
    App.popScaffoldKey();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: status < 3 ? TargetScreen(): HackedScreen());
  }

}
