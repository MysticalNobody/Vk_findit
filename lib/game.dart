import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttie/fluttie.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => new _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  FluttieAnimationController gradient;

  @override
  initState() {
    super.initState();

    /// Load and prepare our animations after this widget has been added
    prepareAnimation();
  }

  prepareAnimation() async {
    // Checks if the platform we're running on is supported by the animation plugin
    bool canBeUsed = await Fluttie.isAvailable();
    if (!canBeUsed) {
      print("Animations are not supported on this platform");
      return;
    }

    var instance = new Fluttie();
    var bgComposition = await instance.loadAnimationFromAsset(
        "assets/gradient_animated_background.json"
    );
    gradient = await instance.prepareAnimation(
        bgComposition, duration: const Duration(minutes: 2),
        repeatCount: const RepeatCount.infinite(),
        repeatMode: RepeatMode.START_OVER);
    setState(() {
      gradient.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Positioned.fill(child: new FluttieAnimation(gradient)),
              Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 56.0),
                            child: Center(
                                child: Column(
                                    children: <Widget>[
                                      Text("Вы",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Lobster',
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w800)),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              12.0),
                                          color: Colors.white,
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
                        ),
                        Center(
                            child: Column(
                                children: <Widget>[
                                  Text("Между вами",
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w200,
                                          fontFamily: 'PoiretOne')),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Text("36",
                                          style: TextStyle(color: Colors.white,
                                              fontFamily: 'PoiretOne',
                                              fontSize: 48.0,
                                              fontWeight: FontWeight.w800))),
                                  Text("метров",
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w200,
                                          fontFamily: 'PoiretOne')),
                                ]
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 56.0),
                            child: Center(
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                12.0),
                                            color: Colors.white
                                        ),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 3,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 3,
                                      ),
                                      Text("Ваша пара",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Lobster',
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w800))
                                    ]
                                )
                            )
                        )
                      ]
                  )
              )
            ])
    );
  }
}