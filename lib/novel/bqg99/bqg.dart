import 'package:april_spider/configs.dart';
import 'package:april_spider/novel/bqg99/bean/chapter.dart';
import 'package:april_spider/novel/bqg99/bean/novel.dart';
import 'package:april_spider/novel/bqg99/bean/search.dart';

/// 笔趣阁
/// 网站：https://www.bqg99.cc/
/// 手机站：https://m.bqg99.cc/
class Bqg99 {
  Bqg99._();

  static const RequestConfiguration webRequestConfiguration =
      RequestConfiguration(
    cookie:
        'm_lvt_291c633173ca6a044185f6ce92f33120=1647649026; bcolor=; font=; size=; fontcolor=; width=; Hm_lpvt_291c633173ca6a044185f6ce92f33120=1649937493',
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
  static Future<List<SearchResultBean>> searchNovel(
    String keywords, {
    RequestConfiguration? configuration,
  }) async {
    //todo
    return [];
  }

  ///根据小说 id 查询小说详情
  static Future<NovelBean?> novelDetail(
    String novelId, {
    RequestConfiguration? configuration,
  }) async {
    //todo
    return null;
  }

  ///根据小说 id 以及 章节 id 查询章节内容
  static Future<ChapterDetailBean?> chapterDetail({
    required String novelId,
    required String chapterId,
    RequestConfiguration? configuration,
  }) async {
    //todo
    return null;
  }
}
