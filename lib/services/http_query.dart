import 'dart:async';
import 'dart:convert';

import 'package:findit/classes/config.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class HttpQuery {
  static final String protocol = "http";
  static final String baseUrl = "137.117.155.208";
  static final int port = 6456;

  static String hrefTo(String path, {String protocol, String baseUrl, int port, String file, Map query}) {
    return new Uri(
        scheme: protocol ?? HttpQuery.protocol,
        host: baseUrl ?? HttpQuery.baseUrl,
        path: join(path, file),
        port: port ?? HttpQuery.port,
        queryParameters: query)
        .toString();
  }

  static Future<Map<String, dynamic>> executeJsonQuery(String action, {dynamic params, String method = "get"}) async {
    if (params == null) params = {};
    Map<String, String> _headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (Config.token != null) _headers["auth_token"] = Config.token;
    print(hrefTo(action));
    print(params);
    print(method);
    http.Response response;
    try {
      if (method == "post") {
        response = await http.post(hrefTo(action), body: json.encode(params), headers: _headers);
      } else if (method == "get") {
        response = await http.get(hrefTo(action, query: params), headers: _headers);
      }
    } on Exception {
      return {"error": true, "response": "Нет интернет соединения"};
    }

    try {
      var ret = json.decode(response.body) as Map<String, dynamic>;
      print(ret);
      return ret;
    } on Exception {
      return {"error": true, "response": "Что-то пошло не так"};
    }
  }
}
