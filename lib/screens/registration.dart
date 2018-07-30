import 'dart:convert';
import 'dart:io';

import 'package:findit/classes/app.dart';
import 'package:findit/screens/registration/phone.dart';
import 'package:findit/screens/registration/photo.dart';
import 'package:findit/services/http_query.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => new _RegistrationScreenState();
}

var photoChosen = false;

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
        return Column(children: <Widget>[
          Center(
              child: Text(
                'Вчера произошла крупная утечка данных, в результате которой различным хакерским группировкам удалось похитить фрагменты секретного кода.',
                style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              )),
          IconButton(
            icon: Icon(Icons.arrow_forward, size: 48.0),
            iconSize: 48.0,
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: () async {
              setState(() => screenNum = 1);
            },
          )
        ]);
        break;
      case 1:
        return Column(children: <Widget>[
          Center(
              child: Text(
                'Найди враждебных хакеров и продержись в зоне действия связи 20 секунд чтобы взломать его устройство и украсть фрагмент кода. Боевое приложение поможет тебе в этом.',
                style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              )),
          IconButton(
            icon: Icon(Icons.arrow_forward, size: 48.0),
            iconSize: 48.0,
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: () async {
              setState(() => screenNum = 2);
            },
          )
        ]);
        break;
      case 2:
        return PhoneScreen(onPressedButton: () {
          print("rot");
          setState(() => screenNum = 3);
        });
        break;
      case 3:
        return PhotoScreen(onPressedButton: () async {
          if (photoChosen) {
            return;
          }
          File userImg = await ImagePicker.pickImage(source: ImageSource.camera);
          setState(() {
            photoChosen = true;
          });
          await HttpQuery.executeJsonQuery("/auth/send_img",
              params: {'photo': base64Encode(userImg.readAsBytesSync())}, method: "post");
          App.processMain();
        });
        break;
    }
    return Text("");
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
