import 'package:findit/classes/app.dart';
import 'package:findit/classes/config.dart';
import 'package:findit/screens/game/hacked.dart';
import 'package:findit/screens/game/target.dart';
import 'package:findit/services/connection.dart';
import 'package:flutter/material.dart';
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
int startHack;
int rating = -1;
bool started = false;

getSize(BuildContext context) {
  return MediaQuery
      .of(context)
      .size
      .width - 100;
}

Widget loadingBar() {
  var loadingWidget = [Text('/',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900
      ))
  ];
  for (int i = 0; i < 10; i++) {
    if (i < 10 - startHack / 2) {
      loadingWidget.add(
          Text('*',
              style: TextStyle(
                  color: Colors.white
              )
          )
      );
    }
    else {
      loadingWidget.add(Text('-',
          style: TextStyle(
              color: Colors.white
          )));
    }
  }
  loadingWidget.add(Text('/',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900
      )));
  return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: loadingWidget
  );
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        if (rating != -1) {
          if (params["rating"] > rating) {
            showRatingUp();
            status = 2;
          } else if (params["rating"] < rating) {
            showRatingDown();
            status = 2;
          }
        }
        rating = params["rating"];
        if (params['start_hack'] != null) {
          startHack = params['start_hack'];
        }
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
        body: status < 3 ? TargetScreen() : HackedScreen());
  }

  void showRatingUp() {
    showDialog(context: this.context, builder: (build) {
      return new Dialog(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Вы захватили часть кода!\nПродолжайте..",
          style: TextStyle(fontSize: 26.0), textAlign: TextAlign.center,),
      ),);
    });
  }

  void showRatingDown() {
    showDialog(context: this.context, builder: (build) {
      return new Dialog(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Вас взломали.\nЧасть кода утеряна.!\nБудьте осторожнее..",
          style: TextStyle(fontSize: 26.0), textAlign: TextAlign.center,),
      ),);
    });
  }

}
