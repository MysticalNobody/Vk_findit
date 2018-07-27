import 'package:findit/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HackedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Positioned.fill(
        child: controllerBgHacked.value.initialized
            ? AspectRatio(
          aspectRatio: controllerBgHacked.value.aspectRatio,
          child: VideoPlayer(controllerBgHacked),
        )
            : Container(),
      ),
      Center(
          child: status == 3 ? Column(
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('You are under',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ), Text('/hack/',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.italic
                ),
                textAlign: TextAlign.center,
              )
              ]
          ) : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('YOU ARE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.0,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ), Text('/hacked/',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic
                  ),
                  textAlign: TextAlign.center,
                )
              ]
          )
      )
    ]);
  }
}