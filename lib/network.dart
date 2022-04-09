import 'dart:convert';
import 'dart:io';

import 'package:april_spider/configs.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

///网络请求工具类
class Network {
  Network._();

  ///GET 请求字符串
  ///null 表示请求或者解析失败了
  static Future<String?> getString({
    required Uri uri,
    required RequestConfiguration configuration,
  }) async {
    var request = await HttpClient().getUrl(uri);
    configuration.withRequest(request);
    var response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      return null;
    }
    try {
      return await response.transform(utf8.decoder).join();
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
}
