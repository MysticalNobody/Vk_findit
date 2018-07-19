import 'package:findit/routes.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:fluro/fluro.dart';

import 'package:intro_views_flutter/intro_views_flutter.dart';


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
final pages = [
  new PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      iconImageAssetPath: null,
      iconColor: null,
      bubbleBackgroundColor: null,
      body: Text(
        'Приветствуем тебя в интерактивной игре Find it',
          style: TextStyle(fontWeight: FontWeight.w200,
              fontFamily: 'PoiretOne')
      ),
      title: Text(
        'Find it',
        style: TextStyle(fontFamily: 'Lobster'),
      ),
      textStyle: TextStyle(color: Colors.white),
      mainImage: Image.asset(
        'assets/user.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      iconImageAssetPath: null,
      iconColor: null,
      bubbleBackgroundColor: null,
      body: Text(
          'Приветствуем тебя в интерактивной игре Find it',
          style: TextStyle(fontWeight: FontWeight.w200,
              fontFamily: 'PoiretOne')
      ),
      title: Text(
        'Find it',
        style: TextStyle(fontFamily: 'Lobster'),
      ),
      textStyle: TextStyle(color: Colors.white),
      mainImage: Image.asset(
        'assets/user.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ))
];
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find it',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Builder(
        builder: (context) => new IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            Routes.navigateTo(context, 'game', transition: TransitionType.fadeIn, replace: true);
          },
          showSkipButton:
          true,
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }

}
