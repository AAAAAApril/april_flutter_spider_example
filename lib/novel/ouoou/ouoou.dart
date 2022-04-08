import 'package:april_spider/configs.dart';
import 'package:april_spider/extensions.dart';
import 'package:april_spider/network.dart';
import 'package:html/dom.dart';

import 'bean/classify.dart';

///ou 中文网
///网站：http://www.ouoou.com/
///手机站：http://m.ouoou.net/
class OuOou {
  OuOou._();

  static const RequestConfiguration webRequestConfiguration =
      RequestConfiguration(
    cookie:
        'Hm_lvt_907a8916ebaa0ea6bfe4cfff2327c242=1647649569; Hm_lpvt_907a8916ebaa0ea6bfe4cfff2327c242=1647649569; __51cke__=; Hm_lvt_907a8916ebaa0ea6bfe4cfff2327c242=1647649569; __tins__4289838=%7B%22sid%22%3A%201649440306332%2C%20%22vd%22%3A%2011%2C%20%22expires%22%3A%201649442546154%7D; __51laig__=31; Hm_lpvt_907a8916ebaa0ea6bfe4cfff2327c242=1649440746',
    userAgent:
        ' Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
  );

  static const RequestConfiguration phoneRequestConfiguration =
      RequestConfiguration(
    cookie:
        'Hm_lvt_907a8916ebaa0ea6bfe4cfff2327c242=1647649569; Hm_lpvt_907a8916ebaa0ea6bfe4cfff2327c242=1647649569; __51cke__=; Hm_lvt_907a8916ebaa0ea6bfe4cfff2327c242=1647649569; __tins__4289838=%7B%22sid%22%3A%201649440306332%2C%20%22vd%22%3A%2012%2C%20%22expires%22%3A%201649442621086%7D; __51laig__=32; Hm_lpvt_907a8916ebaa0ea6bfe4cfff2327c242=1649440821',
    userAgent:
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Mobile Safari/537.36',
  );

  ///所有的小说列表分类
  static Future<List<ClassifyBean>> allClassifies({
    RequestConfiguration? configuration,
  }) async {
    //这个接口数据量小，不需要另开线程处理，否则反而会变慢
    return _allClassifies(phoneRequestConfiguration.merge(configuration))
        .printRequestTime('Ou小说分类列表');
  }
}

Future<List<ClassifyBean>> _allClassifies(
    RequestConfiguration configuration) async {
  Document? document = await Network.getHtmlDocument(
    url: 'http://m.ouoou.net/list.html',
    configuration: configuration,
  );
  if (document == null) {
    return <ClassifyBean>[];
  }
  return document
      .nonnullChildrenElement(
    'div[class="content"]',
    childrenSelector: 'ul > li > a',
  )
      .map<ClassifyBean>((e) {
    return ClassifyBean(
      id: e.id,
      name: e.text,
      path: (e.attributes['href'] ?? '').replaceAll('/', ''),
    );
  }).toList();
}
