import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/repository.dart';

/// 爱读书 小说网
/// https://www.ixpsge.com/
class LoveReadingNetworkRepository implements NetworkRepository {
  /// 章节的所有段落
  /// 接口示例：
  /// https://www.ixpsge.com/novelsearch/reader/transcode/siteid/1133/1/
  /// 其中 [1133] 为小说 ID
  /// 其中 [1] 为章节 ID
  @override
  Future<List<String>> fetchParagraphs({
    required String novelId,
    required String chapterId,
  }) {
    // TODO: implement fetchParagraphs
    throw UnimplementedError();
  }

  /// 小说详情
  /// 接口示例：
  /// https://www.ixpsge.com/shu_1133/
  /// 其中 [1133] 为小说 ID
  @override
  Future<NovelBean?> novelDetail(String novelId) {
    // TODO: implement novelDetail
    throw UnimplementedError();
  }

  /// 搜索小说
  /// 接口示例
  /// https://www.ixpsge.com/search.html?searchtype=novelname&searchkey=诡秘
  /// 其中 [诡秘] 为关键词
  @override
  Future<List<NovelPreviewBean>> searchNovels(String keywords) {
    // TODO: implement searchNovels
    throw UnimplementedError();
  }
}
