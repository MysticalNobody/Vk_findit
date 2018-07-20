import 'package:analyzer/file_system/file_system.dart';
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
                'Теперь сфотографируйся, чтобы твой напарник смог тебя найти',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PoiretOne',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,)
          ),
          Center(
              child: IconButton(
                  icon: Icon(Icons.add_a_photo,
                    color: Colors.white70,
                  ),
                  iconSize: 72.0,
                  onPressed: onPressedButton
              )
          )
        ]);
  }
}