import 'package:findit/classes/app.dart';
import 'package:findit/screens/game.dart';
import 'package:findit/screens/registration/phone.dart';
import 'package:findit/screens/registration/photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => new _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  VideoPlayerController _controller;
  int screenNum = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    App.pushScaffoldKey(_scaffoldKey);
  }

  @override
  void dispose() {
    super.dispose();
    App.popScaffoldKey();
  }

  Widget setScreen() {
    switch (screenNum) {
      case 0:
        return PhoneScreen(onPressedButton: () {
          setState(() => screenNum = 1);
        });
        break;
      default:
        return PhotoScreen(onPressedButton: () async {
          userImg = await ImagePicker.pickImage(source: ImageSource.camera);
//          img.Image image = img.decodeImage(userImg.readAsBytesSync());
//          img.Image thumbnail = img.copyResize(image, image.width * 512 ~/ image.height, 512);
//          Map<String, dynamic> data =
//              await HttpQuery.executeJsonQuery("/auth/send_img", params: thumbnail.getBytes(), method: "post");
//          if (userImg != null) Routes.navigateTo(context, '/game', transition: TransitionType.fadeIn, replace: true);
          App.processMain();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(fit: StackFit.expand, children: <Widget>[
          new Positioned.fill(
              child: _controller.value.initialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container()),
          Container(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[setScreen()]))
        ]));
  }
}
