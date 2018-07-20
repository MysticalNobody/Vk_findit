import 'dart:ui' as UI;

import 'package:flutter/material.dart';

class Utils {
  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String getDateTimeNow() {
    var now = DateTime.now();
    return "${twoDigits(now.day)}"
        ".${twoDigits(now.month)}"
        ".${fourDigits(now.year)}"
        "T${twoDigits(now.hour)}"
        ":${twoDigits(now.minute)}"
        ":${twoDigits(now.second)}";
  }

  static showInSnackBar(GlobalKey<ScaffoldState> key, String value) {
    key.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  static showInAlertDialog(GlobalKey<ScaffoldState> key, Widget title, Widget content) {
    showDialog(
      context: key.currentState.context,
      builder: (_) => AlertDialog(title: Center(child: title), content: content),
    );
  }

  static Stack buildBlurredContainer(Widget backgroundWidget,
      {BoxConstraints constraints = const BoxConstraints.expand(), double sigma = 10.0}) {
    return Stack(
      children: <Widget>[
        Container(constraints: constraints, child: backgroundWidget),
        ClipRect(
          child: BackdropFilter(
            filter: UI.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: Stack(
              children: <Widget>[
                Container(
                  constraints: constraints,
                  decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.1)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  static buildCheckboxRow(bool value, void callback(bool), String hint, {IconData icon}) {
    value = value ?? false;

    Widget label = Text(hint, style: TextStyle(color: Colors.white));
    if (icon != null) {
      label = Row(
        children: <Widget>[Icon(icon), Padding(padding: EdgeInsets.only(left: 12.0), child: label)],
      );
    }
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
            onChanged: (bool value) => callback(value),
            activeColor: Colors.white,
            value: value,
          ),
          Padding(padding: const EdgeInsets.only(left: 8.0), child: label),
        ],
      ),
      onTap: () => callback(!value),
    );
  }
}