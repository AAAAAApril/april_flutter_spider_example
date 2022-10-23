import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:spider/configs.dart';
import 'package:spider/network.dart';
import 'package:spider/extensions.dart';
import 'package:spider/novel/beans/chapter_bean.dart';
import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/repository.dart';

/// 爱读书 小说网
/// https://www.ixpsge.com/
class LoveReadingNetworkRepository implements NetworkRepository {
  final RequestConfiguration requestConfiguration = const RequestConfiguration(
    cookie:
        'Hm_lvt_40219b1b2203b63f2332d2b74c51c67c=1665319795; clickbids=%2C1133%2C7340; Hm_lpvt_40219b1b2203b63f2332d2b74c51c67c=1666456864',
    userAgent:
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
  );

  /// 章节的所有段落
  /// 接口示例：
  /// https://www.ixpsge.com/novelsearch/reader/transcode/siteid/1133/1/
  /// 其中 [1133] 为小说 ID
  /// 其中 [1] 为章节 ID
  @override
  Future<List<String>> fetchParagraphs({
    required String novelId,
    required String chapterId,
  }) async {
    final Map<String, dynamic>? result = await Network.getJson(
      uri: Uri.parse(
        'https://www.ixpsge.com/novelsearch/reader/transcode/siteid/$novelId/$chapterId/',
      ),
      configuration: requestConfiguration.merge(RequestConfiguration(
        headers: {
          'Referer': 'https://www.ixpsge.com/shu_$novelId/$chapterId.html',
        },
      )),
    );
    final String? source = result?['info'] as String?;
    if (source == null || source.isEmpty || source.contains('www.ixpsge.com')) {
      return const <String>[];
    }
    return source.replaceAll('<br>', '').split('\n')
      ..removeWhere((element) => element.isEmpty);
  }

  /// 小说详情
  @override
  Future<NovelBean?> novelDetail(String novelId) =>
      compute<_NovelDetailRequestConfig, NovelBean?>(
        _novelDetail,
        _NovelDetailRequestConfig(
          novelId: novelId,
          configuration: requestConfiguration,
        ),
      );

  /// 搜索小说
  @override
  Future<List<NovelPreviewBean>> searchNovels(String keywords) async {
    if (keywords.isEmpty) {
      return const <NovelPreviewBean>[];
    }
    return compute<_SearchNovelRequestConfig, List<NovelPreviewBean>>(
      _searchNovels,
      _SearchNovelRequestConfig(
        keywords: keywords,
        configuration: requestConfiguration,
      ),
    );
  }
}

//==================================  小说详情  ================================

class _NovelDetailRequestConfig {
  const _NovelDetailRequestConfig({
    required this.novelId,
    required this.configuration,
  });

  final String novelId;
  final RequestConfiguration configuration;
}

/// 小说详情
/// 接口示例：
/// https://www.ixpsge.com/shu_1133/
/// 其中 [1133] 为小说 ID
Future<NovelBean?> _novelDetail(_NovelDetailRequestConfig config) async {
  final Document? document = await Network.getHtmlDocument(
    uri: Uri.parse('https://www.ixpsge.com/shu_${config.novelId}'),
    configuration: config.configuration,
  );
  if (document == null) {
    return null;
  }
  return NovelBean(
    novelId: config.novelId,
    novelName: document.nonnullElementAttributeValue(
      'head > meta[property="og:title"]',
      attributeKey: 'content',
    ),
    authorName: document.nonnullElementAttributeValue(
      'head > meta[property="og:novel:author"]',
      attributeKey: 'content',
    ),
    cover: document.nonnullElementAttributeValue(
      'head > meta[property="og:image"]',
      attributeKey: 'content',
    ),
    categoryName: document.nonnullElementAttributeValue(
      'head > meta[property="og:novel:category"]',
      attributeKey: 'content',
    ),
    lastChapter: ChapterPreviewBean(
      chapterId: document
          .nonnullElementAttributeValue(
            'head > meta[property="og:novel:latest_chapter_url"]',
            attributeKey: 'content',
          )
          .numberBetween('shu_${config.novelId}/', '.html')!
          .toString(),
      chapterName: document.nonnullElementAttributeValue(
        'head > meta[property="og:novel:latest_chapter_name"]',
        attributeKey: 'content',
      ),
    ),
    introduction: document
        .nonnullElementAttributeValue(
          'head > meta[property="og:description"]',
          attributeKey: 'content',
        )
        .replaceFirst('简介：', '')
        .split('<br />\n')
      ..removeWhere((element) {
        element.trim();
        return element.isEmpty;
      }),
    updateTime: DateTime.tryParse(
          document.nonnullElementAttributeValue(
            'head > meta[property="og:novel:update_time"]',
            attributeKey: 'content',
          ),
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    chapters: document
        .nonnullChildrenElement(
          'div[class="card mt20 fulldir"] > '
          'div[class="body "] > '
          'ul[class="dirlist three clearfix"]',
          childrenSelector: 'li > a',
        )
        .map<ChapterPreviewBean>(
          (e) => ChapterPreviewBean(
            chapterId: e
                .nonnullAttributeValue('href')
                .numberBetween('shu_${config.novelId}/', '.html')!
                .toString(),
            chapterName: e.text,
          ),
        )
        .toList(),
  );
}

//==================================  搜索小说  ================================

class _SearchNovelRequestConfig {
  const _SearchNovelRequestConfig({
    required this.keywords,
    required this.configuration,
  });

  final String keywords;
  final RequestConfiguration configuration;
}

/// 接口示例
/// https://www.ixpsge.com/search.html?searchtype=novelname&searchkey=诡秘
/// 其中 [诡秘] 为关键词
Future<List<NovelPreviewBean>> _searchNovels(
  _SearchNovelRequestConfig config,
) async {
  final Document? document = await Network.getHtmlDocument(
    uri: Uri.parse(
      'https://www.ixpsge.com/search.html?searchtype=novelname&searchkey=${config.keywords}',
    ),
    configuration: config.configuration,
  );
  if (document == null) {
    return const <NovelPreviewBean>[];
  }
  return document
      .nonnullChildrenElement(
    'ul[class="librarylist"]',
    childrenSelector: 'li',
  )
      .map<NovelPreviewBean>((e) {
    //小说 ID
    final String novelId = e
        .nonnullElementAttributeValue(
          'div[class="pt-ll-l"] > a',
          attributeKey: 'href',
        )
        .numberBetween('/shu_', '/')!
        .toString();
    String authorName = '';
    String categoryName = '';
    //信息节点
    e.querySelectorAll('p[class="info"] > span').forEach((element) {
      if (element.text.startsWith('作者')) {
        authorName = element.nonnullElementText('a');
      } else if (element.text.startsWith('分类')) {
        categoryName = element.nonnullElementText('a');
      }
    });
    return NovelPreviewBean(
      novelId: novelId,
      novelName: e.nonnullElementAttributeValue(
        'div[class="pt-ll-l"] > a',
        attributeKey: 'title',
      ),
      authorName: authorName,
      cover: 'https://www.ixpsge.com${e.nonnullElementAttributeValue(
        'div[class="pt-ll-l"] > a > img',
        attributeKey: 'src',
      )}',
      categoryName: categoryName,
      lastChapter: ChapterPreviewBean(
        chapterId: e
            .nonnullElementAttributeValue(
              'div[class="pt-ll-r"] > p[class="last"] > a',
              attributeKey: 'href',
            )
            .numberBetween('/shu_$novelId/', '.html')!
            .toString(),
        chapterName: e.nonnullElementText(
          'div[class="pt-ll-r"] > p[class="last"] > a',
        ),
      ),
    );
  }).toList();
}
