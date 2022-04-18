import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spider/configs.dart';

import 'log.dart';

///网络请求工具类
class Network {
  Network._();

  ///GET 请求原始字符串
  ///null 表示请求失败了
  static Future<String?> getOriginString({
    required Uri uri,
    required RequestConfiguration configuration,
  }) async {
    Response response = await http.get(
      uri,
      headers: configuration.toHeaderMap(),
    );
    if (response.statusCode != 200) {
      Log.print(
        tag: 'GET请求错误响应',
        value: () => {
          'statusCode': response.statusCode,
          'headers': response.headers,
        },
      );
      return null;
    }
    return response.body;
  }

  ///GET 请求字符串
  ///null 表示请求或者解析失败了
  static Future<String?> getString({
    required Uri uri,
    required RequestConfiguration configuration,
  }) async {
    Response response = await http.get(
      uri,
      headers: configuration.toHeaderMap(),
    );
    if (response.statusCode != 200) {
      Log.print(
        tag: 'GET请求错误响应',
        value: () => {
          'statusCode': response.statusCode,
          'headers': response.headers,
        },
      );
      return null;
    }
    try {
      return utf8.decode(response.bodyBytes);
    } catch (_) {
      return null;
    }
  }

  ///Get 请求 json
  ///null 表示获取失败
  static Future<Map<String, dynamic>?> getJson({
    required Uri uri,
    required RequestConfiguration configuration,
  }) async {
    String? response = await getString(uri: uri, configuration: configuration);
    if (response == null) {
      return null;
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(response) as Map);
    } catch (_) {
      return null;
    }
  }

  ///GET 请求一个 html 文本
  ///null 表示获取失败
  static Future<Document?> getHtmlDocument({
    required Uri uri,
    required RequestConfiguration configuration,
  }) async {
    String? response = await getString(uri: uri, configuration: configuration);
    if (response == null) {
      return null;
    }
    try {
      return parse(response);
    } catch (_) {
      return null;
    }
  }

  ///Post 请求 String
  ///null 表示获取失败
  static Future<String?> postString({
    required Uri uri,
    required RequestConfiguration configuration,
    Map<String, String>? body,
  }) async {
    Response response = await http.post(
      uri,
      headers: configuration.toHeaderMap(),
      body: body,
    );
    if (response.statusCode != 200) {
      Log.print(
        tag: 'POST请求错误响应',
        value: () => {
          'statusCode': response.statusCode,
          'headers': response.headers,
        },
      );
      return null;
    }
    try {
      return utf8.decode(response.bodyBytes);
    } catch (_) {
      return null;
    }
  }

  ///Post 请求 json
  ///null 表示获取失败
  static Future<Map<String, dynamic>?> postJson({
    required Uri uri,
    required RequestConfiguration configuration,
    Map<String, String>? body,
  }) async {
    String? response = await postString(
      uri: uri,
      configuration: configuration,
      body: body,
    );
    if (response == null) {
      return null;
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(response) as Map);
    } catch (_) {
      return null;
    }
  }
}
