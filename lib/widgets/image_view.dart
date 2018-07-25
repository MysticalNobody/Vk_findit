import 'package:findit/classes/config.dart';
import 'package:findit/widgets/network_image.dart' as netimg;
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          imageProvider:
          netimg.NetworkImage('http://137.117.155.208:6456/uploads/${Config.targetId}.jpg?auth_token=' + Config.token),
          minScale: 0.1,
          maxScale: 4.0,
        ));
  }
}
