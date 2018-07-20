import 'package:findit/screens/registration/phone.dart';
import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => new _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Positioned.fill(child: new FluttieAnimation(gradient)),

              Container(
                margin: EdgeInsets.only(top: 48.0),
                  child: Text('Регистрация',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lobster',
                        fontSize: 48.0,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,)),
              Container(
                  margin: EdgeInsets.only(top: 48.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PhoneScreen()
                      ])
              )
            ]
        )
    );
  }
}