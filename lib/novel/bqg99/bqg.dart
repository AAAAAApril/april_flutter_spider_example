import 'package:april/utils/extensions.dart';
import 'package:april_spider/configs.dart';
import 'package:april_spider/extensions.dart';
import 'package:april_spider/network.dart';
import 'package:april_spider/novel/bqg99/bean/chapter.dart';
import 'package:april_spider/novel/bqg99/bean/novel.dart';
import 'package:april_spider/novel/bqg99/bean/search.dart';
import 'package:flutter/foundation.dart';

/// 笔趣阁
/// 网站：https://www.bqg99.cc/
/// 手机站：https://m.bqg99.cc/
class Bqg99 {
  Bqg99._();

  static const RequestConfiguration webRequestConfiguration =
      RequestConfiguration(
    cookie:
        'Hm_lvt_291c633173ca6a044185f6ce92f33120=1647649026; bcolor=; font=; size=; fontcolor=; width=; Hm_lpvt_291c633173ca6a044185f6ce92f33120=1649937493',
    userAgent:
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
  );

  static const RequestConfiguration phoneRequestConfiguration =
      RequestConfiguration(
    cookie:
        'Hm_lvt_291c633173ca6a044185f6ce92f33120=1648927201; Hm_lpvt_291c633173ca6a044185f6ce92f33120=1649340745',
    userAgent:
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Mobile Safari/537.36',
  );

  ///根据关键词搜索小说
  ///https://m.bqg99.cc/s.php?q=黎明之剑
  static Future<List<SearchResultBean>> searchNovel(
    String keywords, {
    RequestConfiguration? configuration,
  }) {
    return compute<_SearchNovelRequestConfig, List<SearchResultBean>>(
      _searchNovel,
      _SearchNovelRequestConfig(
        keywords: keywords,
        configuration: phoneRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('笔趣阁搜索');
  }

  ///根据小说 id 查询小说详情
  ///https://www.bqg99.cc/book/1944105/
  static Future<NovelBean?> novelDetail(
    String novelId, {
    RequestConfiguration? configuration,
  }) {
    return compute<_NovelDetailRequestConfig, NovelBean?>(
      _novelDetail,
      _NovelDetailRequestConfig(
        novelId: novelId,
        configuration: webRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('笔趣阁查询小说详情');
  }

  ///根据小说 id 以及 章节 id 查询章节内容
  ///https://www.bqg99.cc/book/1944105/308697942.html
  static Future<ChapterDetailBean?> chapterDetail({
    required String novelId,
    required String chapterId,
    RequestConfiguration? configuration = const RequestConfiguration(
      cookie:
          'Hm_lvt_291c633173ca6a044185f6ce92f33120=1647649026; bcolor=; font=; size=; fontcolor=; width=; Hm_lpvt_291c633173ca6a044185f6ce92f33120=1650040810',
    ),
  }) {
    return compute<_ChapterDetailRequestConfig, ChapterDetailBean?>(
      _chapterDetail,
      _ChapterDetailRequestConfig(
        novelId: novelId,
        chapterId: chapterId,
        configuration: webRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('笔趣阁获取章节详情');
  }
}

class _SearchNovelRequestConfig {
  const _SearchNovelRequestConfig({
    required this.keywords,
    required this.configuration,
  });

  final String keywords;
  final RequestConfiguration configuration;
}

Future<List<SearchResultBean>> _searchNovel(
  _SearchNovelRequestConfig config,
) async {
  var document = await Network.getHtmlDocument(
    uri: Uri.https(
      'm.bqg99.cc',
      's.php',
      <String, String>{
        'q': config.keywords,
      },
    ),
    configuration: config.configuration,
  );
  if (document == null) {
    return <SearchResultBean>[];
  }
  return document
      .querySelectorAll('div[class="bookbox"]')
      .map<SearchResultBean>((e) {
    var imageElement = e.querySelector('div[class="bookimg"]')!;
    String bookId = imageElement.nonnullElementAttributeValue(
      'a',
      attributeKey: 'href',
    );
    bookId = bookId.substring(1, bookId.length - 1);
    var infoElement = e.querySelector('div[class="bookinfo"]')!;
    var update = infoElement.querySelector('div[class="update"] > a')!;
    return SearchResultBean(
      id: bookId.split('/').last,
      name: infoElement.nonnullElementText('h4 > a'),
      cover: imageElement.nonnullElementAttributeValue(
        'a > img',
        attributeKey: 'src',
      ),
      author: infoElement
          .nonnullElementText('div[class="author"]')
          .replaceFirst('作者：', ''),
      category: infoElement
          .nonnullElementText('div[class="cat"]')
          .replaceFirst('分类：', ''),
      latestUpdateChapter: ChapterBean(
        id: update.attributes['href']!
            .split('/')
            .last
            .replaceFirst('.html', ''),
        name: update.text,
      ),
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

Future<NovelBean?> _novelDetail(_NovelDetailRequestConfig config) async {
  var document = await Network.getHtmlDocument(
    uri: Uri.parse('https://www.bqg99.cc/book/${config.novelId}/'),
    configuration: config.configuration,
  );
  if (document == null) {
    return null;
  }
  var infoElement = document.querySelector('div[class="info"]');
  if (infoElement == null) {
    return null;
  }
  //TODO
  return null;
}

class _ChapterDetailRequestConfig {
  const _ChapterDetailRequestConfig({
    required this.novelId,
    required this.chapterId,
    required this.configuration,
  });

  final String novelId;
  final String chapterId;
  final RequestConfiguration configuration;
}

Future<ChapterDetailBean?> _chapterDetail(
  _ChapterDetailRequestConfig config,
) async {
  var document = await Network.getHtmlDocument(
    uri: Uri.parse(
      'https://www.bqg99.cc/book/${config.novelId}/${config.chapterId}.html',
    ),
    configuration: config.configuration,
  );
  if (document == null) {
    return null;
  }
  var contentElement = document.querySelector('div[class="content"]');
  if (contentElement == null) {
    return null;
  }
  var infoList = contentElement
      .nonnullChildrenElement(
        'div[class="textinfo"]',
        childrenSelector: 'span',
      )
      .map<String>((e) => e.text)
      .toList();
  var paragraphs = contentElement
      .nonnullElementText('div[id="content"][class="showtxt"]')
      .split('\n')
      .map((e) => e.trim())
      .toList();
  if (paragraphs.isNotEmpty) {
    var index = paragraphs.last.lastIndexOf('请记住本书首发域名');
    if (index >= 0) {
      paragraphs.add((paragraphs.removeLast()).substring(0, index));
    }
  }
  return ChapterDetailBean(
    id: config.chapterId,
    name: contentElement.nonnullElementText('h1'),
    wordsCount: int.tryParse(infoList
                .findFirst((element) => element.startsWith('字数：'))
                ?.replaceFirst('字数：', '') ??
            '') ??
        0,
    updateTime: DateTime.tryParse(infoList
                .findFirst((element) => element.startsWith('更新时间 : '))
                ?.replaceFirst('更新时间 : ', '') ??
            ' ') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    paragraphs: paragraphs,
  );
}
