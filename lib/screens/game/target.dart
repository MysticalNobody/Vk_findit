import 'package:findit/classes/config.dart';
import 'package:findit/routes.dart';
import 'package:findit/screens/game.dart';
import 'package:findit/widgets/transition.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:findit/widgets/network_image.dart' as netimg;

class TargetScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Positioned.fill(
        child: controllerBg.value.initialized
            ? AspectRatio(
          aspectRatio: controllerBg.value.aspectRatio,
          child: VideoPlayer(controllerBg),
        )
            : Container(),
      ),
      Container(
          margin: EdgeInsets.only(top: 64.0),
          child: Column(children: <Widget>[
            Text(
              "ENEMY\nHACKER",
              style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w200),
              textAlign: TextAlign.center,
            ),
            status == 2
                ? InkWell(
                onTap: () {
                  Routes.navigateTo(context, 'image_view', transition: TransitionType.fadeIn);
                },
                child: Stack(alignment: Alignment.center, children: <Widget>[
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
                    margin: EdgeInsets.only(top: 12.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: netimg.NetworkImage(
                              'http://137.117.155.208:6456/uploads/${Config.targetId}.jpg?auth_token=' +
                                  Config.token),
                          fit: BoxFit.cover,
                          alignment: Alignment.center),
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
                ]))
                : new PivotTransition(
              alignment: FractionalOffset.center,
              turns: animationController,
              speed: 1.2,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                height: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                child: Image.asset('assets/wheel_0.png'),
              ),
            )
          ])),
      Container(
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.3),
          child: Stack(children: <Widget>[
            Center(
                child: new PivotTransition(
                  alignment: FractionalOffset.center,
                  turns: animationController,
                  speed: status == 2 ? 2.0 : -1.0,
                  child: Container(
                    width: getSize(context) + 20,
                    height: getSize(context) + 20,
                    child: Image.asset('assets/wheel_0.png'),
                  ),
                )),
            Center(
                child: Container(
                    width: getSize(context), height: getSize(context), child: Image.asset('assets/wheel_1.png'))),
            Center(
                child: Container(
                    width: getSize(context), height: getSize(context), child: Image.asset('assets/wheel_2.png'))),
            Center(
                child: new PivotTransition(
                  alignment: FractionalOffset.center,
                  turns: animationController,
                  speed: status == 2 ? 4.0 : -1.5,
                  child: Container(
                    width: getSize(context) + 25,
                    height: getSize(context) + 25,
                    child: Image.asset('assets/wheel_3.png'),
                  ),
                )),
            Center(
                child: Container(
                    width: getSize(context) - 40,
                    height: getSize(context) - 40,
                    child: Image.asset('assets/wheel_4.png'))),
            Center(
              child: new SizedBox(
                height: getSize(context) * 0.25,
                width: getSize(context) - 160,
                child: new FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: Text (
                    distance != null && status == 2 ? (distance.toString() + 'м') : "Wait..",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontSize: getSize(context) * 0.2),
                  ),
                ),
              ),
            )
          ]))
    ]);
  }

}