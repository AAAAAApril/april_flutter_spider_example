import 'beans/chapter_bean.dart';
import 'beans/novel_bean.dart';

///网络
abstract class NetworkRepository {
  ///搜索小说
  Future<List<NovelPreviewBean>> searchNovels(String keywords);

  ///从网络中获取小说详情
  Future<NovelBean?> novelDetail(String novelId);

  ///从网络中获取章节的所有段落
  Future<List<String>> fetchParagraphs({
    required String novelId,
    required String chapterId,
  });
}

///缓存
class CacheRepository {
  const CacheRepository({
    this.name = 'novels',
  });

  ///缓存名
  final String name;

  ///从缓存中获取小说详情
  Future<NovelBean?> novelDetail(String novelId) async {
    //TODO
    return null;
  }

  ///把小说详情缓存下来
  Future<void> cacheNovelDetail(NovelBean novel) async {
    //TODO
  }

  ///从缓存中获取章节的所有段落
  Future<List<String>> fetchParagraphs({
    required String novelId,
    required String chapterId,
  }) async {
    //TODO
    return [];
  }

  ///把章节缓存下来
  Future<void> cacheParagraphs({
    required String novelId,
    required ChapterBean chapter,
  }) async {
    //TODO
  }
}
