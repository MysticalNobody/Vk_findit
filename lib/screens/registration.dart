import 'package:findit/routes.dart';
import 'package:findit/screens/game.dart';
import 'package:findit/screens/registration/phone.dart';
import 'package:findit/screens/registration/photo.dart';
import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluro/fluro.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => new _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FluttieAnimationController gradient;
  int screenNum = 0;

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

  Widget setScreen() {
    switch (screenNum) {
      case 0:
        return PhoneScreen(
            onPressedButton: () {
              setState(() {
                screenNum = 1;
              });
            });
        break;
      default:
        return PhotoScreen(
            onPressedButton: () {
              setState(() async {
                var image = await ImagePicker.pickImage(source: ImageSource.camera);
                user_img = image;
                if(image!=null)
                  Routes.navigateTo(context, 'game',transition: TransitionType.fadeIn, replace: true);
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Positioned.fill(child: new FluttieAnimation(gradient)),
              Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        setScreen()
                      ])
              )
            ]
        )
    );
  }
}