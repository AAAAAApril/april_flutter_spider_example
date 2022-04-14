import 'dart:convert';

import 'package:april_spider/configs.dart';
import 'package:april_spider/extensions.dart';
import 'package:april_spider/log.dart';
import 'package:april_spider/network.dart';
import 'package:april_spider/novel/ouoou/bean/chapter.dart';
import 'package:april_spider/novel/ouoou/bean/novel.dart';
import 'package:april_spider/novel/ouoou/bean/search.dart';
import 'package:flutter/foundation.dart';

import 'bean/classify.dart';

///ou 中文网
///网站：http://www.ouoou.com/
///手机站：http://m.ouoou.net/
class OuOou {
  OuOou._();

  static const String webHostUrl = 'http://www.ouoou.com/';
  static const String phoneHostUrl = 'http://m.ouoou.net/';

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
  }) {
    //这个接口数据量小，不需要另开线程处理，否则反而会变慢
    return _allClassifies(
      phoneRequestConfiguration.merge(configuration),
    ).printRequestTime('Ou小说分类列表');
  }

  ///搜索小说
  static Future<List<SearchResultBean>> searchNovel(
    //搜索关键词
    String keyword, {
    RequestConfiguration? configuration = const RequestConfiguration(
      cookie:
          'BIDUPSID=81FA0F4DF568B9A8AA230B575953C7F4; PSTM=1636130290; BAIDUID=81FA0F4DF568B9A814011DC1167BEC9E:FG=1; BDUSS=Wc1MnlGeDFtRmdMTEhlVHdLZWdiNm80OVM0dExMaFE1T35waDdmLUd-cHIzM05pRUFBQUFBJCQAAAAAAAAAAAEAAACaeEFP0rb0y7O9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGtSTGJrUkxiU; BDORZ=B490B5EBF6F3CD402E515D22BCDA1598; H_PS_PSSID=36069_31254_36004_36086_36167_34584_36142_36120_36195_36074_36125_36261_26350_36111_36100_36061; delPer=0; PSINO=7',
    ),
  }) async {
    final String? jsonString = await Network.getString(
      uri: Uri.http(
        'zhannei.baidu.com',
        'api/customsearch/searchwap',
        <String, String>{
          'q': keyword,
          'cc': 'ouoou.com',
        },
      ),
      configuration: phoneRequestConfiguration.merge(configuration),
    );
    if (jsonString == null || jsonString.isEmpty) {
      return <SearchResultBean>[];
    }
    final List<SearchResultBean> searchResults = <SearchResultBean>[];
    try {
      for (var item in ((jsonDecode(jsonString))['results'] as List)) {
        Log.print(tag: '搜索结果Map', value: () => item);
        //TODO 需要解析出所有有用的数据
        try {
          final Map target = item['data']['novel_struct_realtime'];
          final String author = target['penname'];
          final String name = target['bookname'];
          final int? novelId =
              (target['url'] as String).numberBetween('/ou_', '/');
          if (novelId == null || author.isEmpty || name.isEmpty) {
            continue;
          }
          if (author.contains(keyword) || name.contains(keyword)) {
            searchResults.add(SearchResultBean(
              novelId: 'ou_$novelId',
              novelName: name,
              novelAuthor: author,
            ));
          }
        } catch (_) {
          //ignore
        }
      }
    } catch (_) {
      //ignore
    }
    return searchResults;
  }

  ///获取小说详情
  static Future<NovelDetailBean?> novelDetail(
    String novelId, {
    RequestConfiguration? configuration,
  }) {
    return compute<_NovelDetailRequestConfig, NovelDetailBean?>(
      _novelDetail,
      _NovelDetailRequestConfig(
        novelId: novelId,
        configuration: webRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('Ou小说详情');
  }

  ///获取小说章节详情
  static Future<ChapterDetailBean?> chapterDetail({
    //小说 id
    required String novelId,
    //章节信息
    required ChapterBean bean,
    RequestConfiguration? configuration,
  }) {
    return compute<_ChapterDetailRequestConfig, ChapterDetailBean?>(
      _chapterDetail,
      _ChapterDetailRequestConfig(
        novelId: novelId,
        chapterBean: bean,
        configuration: phoneRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('Ou小说章节详情');
  }
}

Future<List<ClassifyBean>> _allClassifies(
    RequestConfiguration configuration) async {
  var document = await Network.getHtmlDocument(
    uri: Uri.parse('${OuOou.phoneHostUrl}list.html'),
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

class _NovelDetailRequestConfig {
  const _NovelDetailRequestConfig({
    required this.novelId,
    required this.configuration,
  });

  final String novelId;
  final RequestConfiguration configuration;
}

Future<NovelDetailBean?> _novelDetail(_NovelDetailRequestConfig config) async {
  final String requestUrl = '${OuOou.webHostUrl}${config.novelId}/';
  var document = await Network.getHtmlDocument(
    uri: Uri.parse(requestUrl),
    configuration: config.configuration,
  );
  if (document == null) {
    return null;
  }
  var mainInfoElement = document.querySelector('div[id="maininfo"]');
  if (mainInfoElement == null) {
    return null;
  }
  //小说名字
  final String name = mainInfoElement.nonnullElementText('div[id="info"] > h1');
  var textList = mainInfoElement.nonnullChildrenElement(
    'div[id="info"]',
    childrenSelector: 'p',
  );
  //小说作者
  String author;
  try {
    author = textList
        .firstWhere((element) => element.text.startsWith('作　　者：'))
        .text
        .trim()
        .replaceFirst('作　　者：', '');
  } catch (_) {
    author = '';
  }
  //小说分类
  String category;
  try {
    category = textList
        .firstWhere((element) => element.text.startsWith('类　　别：'))
        .text
        .trim()
        .replaceFirst('类　　别：', '');
  } catch (_) {
    category = '';
  }
  //小说简介
  List<String> introduction = <String>[];
  var introductionElement = mainInfoElement.querySelector('div[id="intro"]');
  if (introductionElement != null) {
    var pElements = introductionElement.querySelectorAll('p');
    if (pElements.length >= 2) {
      pElements.removeAt(0);
      pElements.removeAt(pElements.length - 1);
      String introductionString = pElements.map((e) => e.text).join();
      final int targetIndex = introductionString.lastIndexOf(' 起点 ');
      if (targetIndex >= 0) {
        introductionString = introductionString.substring(0, targetIndex);
      }
      introduction = introductionString.split('\n');
    }
  }
  //小说状态
  String status;
  try {
    status = textList
        .firstWhere((element) => element.text.startsWith('作品状态：'))
        .text
        .trim()
        .replaceFirst('作品状态：', '');
  } catch (_) {
    status = '';
  }
  //最后更新的章节
  ChapterBean chapterBean;
  //最后更新的时间字符串
  String updateTimeString = '';
  //最后更新的时间
  DateTime latestUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);
  try {
    var element = textList
        .firstWhere((element) => element.text.startsWith('最新章节：'))
        .querySelector('a');
    if (element == null) {
      throw Exception();
    }
    String? href = element.attributes['href'];
    if (href == null) {
      throw Exception();
    }
    updateTimeString = textList
        .firstWhere((element) => element.text.startsWith('更新时间：'))
        .text
        .trim()
        .replaceFirst('更新时间：', '');
    String updateTime = updateTimeString.replaceAll('年', '-');
    updateTime = updateTime.replaceAll('月', '-');
    updateTime = updateTime.replaceAll('日', '');
    latestUpdateTime = DateTime.parse(updateTime);
    chapterBean = ChapterBean(
      id: href
          .trim()
          .replaceFirst(requestUrl, '')
          .trim()
          .replaceAll('.html', ''),
      name: element.text.trim(),
    );
  } catch (_) {
    chapterBean = const ChapterBean.empty();
  }
  //所有的章节
  final List<ChapterBean> chapters = <ChapterBean>[];
  var chaptersElement =
      document.querySelector('div[class="box_con"] > div[id="list"] > dl');
  if (chaptersElement != null) {
    chapters.addAll(
      chaptersElement.querySelectorAll('dd > a').map<ChapterBean>((e) {
        return ChapterBean(
          id: e.attributes['href']
                  ?.trim()
                  .replaceFirst('/${config.novelId}/', '')
                  .trim()
                  .replaceAll('.html', '') ??
              '',
          name: e.attributes['title']?.trim() ?? '',
        );
      }),
    );
  }
  return NovelDetailBean(
    id: config.novelId,
    name: name,
    author: author,
    category: category,
    introduction: introduction,
    status: status,
    latestUpdateTime: latestUpdateTime,
    latestUpdateTimeString: updateTimeString,
    latestChapter: chapterBean,
    allChapters: chapters,
  );
}

class _ChapterDetailRequestConfig {
  const _ChapterDetailRequestConfig({
    required this.novelId,
    required this.chapterBean,
    required this.configuration,
  });

  final String novelId;
  final ChapterBean chapterBean;
  final RequestConfiguration configuration;
}

Future<ChapterDetailBean?> _chapterDetail(
  _ChapterDetailRequestConfig config,
) async {
  var document = await Network.getHtmlDocument(
    uri: Uri.parse(
      '${OuOou.phoneHostUrl}${config.novelId}/${config.chapterBean.id}.html',
    ),
    configuration: config.configuration,
  );
  if (document == null) {
    return null;
  }
  return ChapterDetailBean(
    id: config.chapterBean.id,
    name: config.chapterBean.name,
    paragraphs:
        (document.querySelector('div[id="nr1"]')?.text ?? '').split('\n')
          ..removeWhere((element) => element.isEmpty),
  );
}
