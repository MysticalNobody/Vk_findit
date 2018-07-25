import 'package:findit/routes.dart';
import 'package:findit/widgets/transition.dart';
import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';
import 'package:fluro/fluro.dart';
import 'dart:math' as math;
import 'package:video_player/video_player.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => new _GameScreenState();
}

var user_img = null;

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {

  VideoPlayerController _controller;
  AnimationController _animationController;

  getSize(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width - 100;
  }

  @override
  initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/bg.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setVolume(1.0);
    _controller.setLooping(true);
    _controller.play();

    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(child:
              _controller.value.initialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container()),
              Container(
                margin: EdgeInsets.only(top: 64.0),
                  child: Column(
                      children: <Widget>[
                        Text("ENEMY\nHACKER",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w200),
                          textAlign: TextAlign.center,),
                        InkWell(
                            onTap: () {
                              Routes.navigateTo(
                                  context, 'image_view',
                                  transition: TransitionType
                                      .fadeIn);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 12.0),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3 + 8,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3 + 8,
                                    child: Image.asset('assets/ava_border.png'),
                                  ),
                                  Container(
                              margin: EdgeInsets.only(
                                  top: 12.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(
                                        user_img),
                                    fit: BoxFit.cover,
                                    alignment: Alignment
                                        .center),
                              ),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3,
                            )
              ]
                            )
                        )
                      ]
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.3),
                  child: Stack(
                      children: <Widget>[
                        Center(
                            child: new PivotTransition(
                              alignment: FractionalOffset.center,
                              turns: _animationController,
                              child: Container(
                                width: getSize(context) + 20,
                                height: getSize(context) + 20,
                                child: Image.asset('assets/wheel_0.png'),
                              ),
                            )
                        ),
                        Center(
                            child: Container(
                                width: getSize(context),
                                height: getSize(context),
                                child: Image.asset('assets/wheel_1.png')
                            )
                        ),
                        Center(
                            child: Container(
                                width: getSize(context),
                                height: getSize(context),
                                child: Image.asset('assets/wheel_2.png')
                            )
                        ),
                        Center(
                            child: new PivotTransition(
                              alignment: FractionalOffset.center,
                              turns: _animationController,
                              speed: 4.0,
                              child: Container(
                                width: getSize(context) + 25,
                                height: getSize(context) + 25,
                                child: Image.asset('assets/wheel_3.png'),
                              ),
                            )
                        ),

                        Center(
                            child: Container(
                                width: getSize(context) - 40,
                                height: getSize(context) - 40,
                                child: Image.asset('assets/wheel_4.png')
                            )
                        ),
                        Center(
                          child: Text('36м',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontSize: getSize(context) * 0.2),),
                        )
                      ])
              )
            ])
    );
  }
}