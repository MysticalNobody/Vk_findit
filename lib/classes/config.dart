import 'dart:async';
import 'dart:convert';

import 'package:findit/services/database.dart';

class Config {
  static final String dbName = "games.run";
  static final int dbVersion = 1;

  static String token;
  static int targetId;

  static Future loadFromDB() async {
    token = await loadRowFromConfig("token");
    try {
      targetId = int.parse((await loadRowFromConfig("targetId")) ?? "0");
    } on Exception {
      targetId = 0;
    }
  }

  static Future saveToDB() async {
    await saveRowToConfig("token", token);
    await saveRowToConfig("targetId", targetId.toString());
  }

  static Future saveRowToConfig(String key, dynamic value,
      {String keyPrefix}) async {
    if (keyPrefix != null) key = keyPrefix + key;
    var db = new DataBase();
    return await db.updateOrInsert("config", {"key": key, "value": value});
  }

  static Future<dynamic> loadRowFromConfig(String key,
      {String keyPrefix}) async {
    if (keyPrefix != null) key = keyPrefix + key;
    var db = new DataBase();
    return await db.getField("config", key, "value", filterField: "key");
  }

  static Future saveToConfig(Map<String, dynamic> data,
      String keyPrefix) async {
    var db = new DataBase();
    List<Map<String, dynamic>> list = [];
    data.forEach((String k, dynamic v) {
      if (v is Map || v is List) json.encode(v);
      if (v is bool) v = v ? "1" : "0";
      list.add({"key": keyPrefix + k, "value": v});
    });
    await db.insertList("config", list);
  }

  static Future<Map<String, dynamic>> loadFromConfig(String keyPrefix) async {
    var db = new DataBase();
    Map<String, dynamic> data = {};
    var _ = (await db.filterLike("key", keyPrefix + "%").get<
        Map<String, dynamic>>("config"))
        .forEach((_) =>
    data[(_['key'] as String).substring(keyPrefix.length)] = _['value']);
    print(data);
    return data;
  }
}
