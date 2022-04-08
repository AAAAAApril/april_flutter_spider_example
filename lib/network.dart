import 'dart:convert';
import 'dart:io';

import 'package:april_spider/configs.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

///网络请求工具类
class Network {
  Network._();

  ///请求一个 html 文本
  ///null 表示获取失败
  static Future<Document?> getHtmlDocument({
    required String url,
    required RequestConfiguration configuration,
  }) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    configuration.withRequest(request);
    var response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      return null;
    }
    try {
      String responseBody = await response.transform(utf8.decoder).join();
      if (responseBody.isEmpty) {
        return null;
      }
      return parse(responseBody);
    } catch (_) {
      return null;
    }
  }
}
