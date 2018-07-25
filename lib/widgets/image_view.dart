import 'package:findit/classes/config.dart';
import 'package:findit/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          imageProvider: NetworkImage(
              'http://137.117.155.208:6456/uploads/$enemyId.jpg?auth_token=' +
                  Config.token),
          minScale: 0.1,
          maxScale: 4.0,
        ));
  }
}
