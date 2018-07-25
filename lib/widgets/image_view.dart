import 'package:findit/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return userImg == null ? Text("") : Container(
        child: PhotoView(
          imageProvider: FileImage(userImg),
          minScale: 0.1,
          maxScale: 4.0,
        ));
  }
}
