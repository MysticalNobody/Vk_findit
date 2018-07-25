import 'dart:async';
import 'dart:convert';

import 'package:analyzer/file_system/file_system.dart';
import 'package:findit/classes/config.dart';
import 'package:flutter/material.dart';

class User {
  String token;
  String phone;
  Image profile;

  User({
    this.token,
    this.phone,
    this.profile
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return new User(
        token: data['token'],
        phone: data['phone'],
        profile: Image.memory(data['image'])
    );
  }
  static Future<User> fromDataBase() async {
    return new User.fromJson(await Config.loadFromConfig("u_"));
  }
}