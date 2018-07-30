import 'package:findit/screens/registration.dart';
import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  PhotoScreen({this.onPressedButton});

  final VoidCallback onPressedButton;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Center(
              child: Text(
                photoChosen
                    ? 'Идёт обработка фото...'
                    : 'Теперь пройди идентификацию по биометрии лица',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,)
          ),
          Center(
              child: IconButton(
                  icon: Icon(photoChosen ? Icons.done : Icons.add_a_photo,
                    color: Colors.white70,
                  ),
                  iconSize: 72.0,
                  onPressed: photoChosen ? null : onPressedButton
              )
          )
        ]);
  }
}