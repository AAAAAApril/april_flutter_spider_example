import 'dart:convert';

import 'package:spider/novel/beans/read_bean.dart';

import 'beans/chapter_bean.dart';
import 'beans/novel_bean.dart';
import 'cache_controller.dart';

///网络仓库
abstract class NetworkRepository {
  const NetworkRepository();

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

///缓存仓库
class CacheRepository extends NetworkRepository {
  CacheRepository({
    required String name,
  }) : cacheFileController = CacheFileController(name);

  ///缓存文件控制器
  final CacheFileController cacheFileController;

  ///将小说添加到收藏
  Future<bool> addFavorite(NovelBean novel) async {
    try {
      var all = List<String>.of(await allFavorites());
      all.add(novel.novelId);
      var file = await cacheFileController.favoritesCacheFile;
      await file.writeAsString(
        jsonEncode(<String, dynamic>{
          'favorites': all,
        }),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  ///将小说从收藏移除
  Future<bool> removeFavorite(String novelId) async {
    try {
      var all = List<String>.of(await allFavorites());
      all.remove(novelId);
      var file = await cacheFileController.favoritesCacheFile;
      await file.writeAsString(
        jsonEncode(<String, dynamic>{
          'favorites': all,
        }),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  ///所有收藏的小说
  Future<List<String>> allFavorites() async {
    try {
      var file = await cacheFileController.favoritesCacheFile;
      var content = jsonDecode(await file.readAsString()) as Map;
      return (content['favorites'] as List)
          .map<String>((e) => e as String)
          .toList();
    } catch (_) {
      return const <String>[];
    }
  }

  ///当前阅读到的章节
  Future<ReadBean> currentReadChapter(String novelId) async {
    try {
      var file = await cacheFileController.getBookReadLocationFile(novelId);
      var content = await file.readAsString();
      return ReadBean.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(content) as Map,
        ),
      );
    } catch (_) {
      return const ReadBean.start();
    }
  }

  ///更新当前的阅读位置
  Future<void> notifyCurrentReadChapter({
    required String novelId,
    required ReadBean read,
  }) async {
    var file = await cacheFileController.getBookReadLocationFile(novelId);
    file.writeAsString(
      jsonEncode(read.toJson()),
    );
  }

  ///从缓存中获取搜索小说结果
  @override
  Future<List<NovelPreviewBean>> searchNovels(String keywords) async {
    //暂时不缓存搜索结果
    return const <NovelPreviewBean>[];
  }

  ///从缓存中获取小说详情
  @override
  Future<NovelBean?> novelDetail(String novelId) async {
    try {
      //取信息
      var infoFile = await cacheFileController.getBookDetailInfoCacheFile(
        novelId,
      );
      dynamic info = jsonDecode(await infoFile.readAsString());
      //取章节
      var chaptersFile = await cacheFileController.getBookChaptersCacheFile(
        novelId,
      );
      dynamic chapters = jsonDecode(await chaptersFile.readAsString());
      //最终详情
      return NovelBean.fromJsonSplit(
        infoMap: Map<String, dynamic>.from(info as Map),
        chapterMap: Map<String, dynamic>.from(chapters as Map),
      );
    } catch (_) {
      return null;
    }
  }

  ///把小说详情缓存下来
  Future<void> cacheNovelDetail(NovelBean novel) async {
    //存信息
    var infoFile = await cacheFileController.getBookDetailInfoCacheFile(
      novel.novelId,
    );
    await infoFile.writeAsString(
      jsonEncode(novel.toJsonWithoutChapters()),
    );
    //存章节
    var chaptersFile = await cacheFileController.getBookChaptersCacheFile(
      novel.novelId,
    );
    await chaptersFile.writeAsString(
      jsonEncode(novel.toJsonOnlyChapters()),
    );
  }

  ///从缓存中获取章节的所有段落
  @override
  Future<List<String>> fetchParagraphs({
    required String novelId,
    required String chapterId,
  }) async {
    try {
      var file = await cacheFileController.getBookChapterParagraphsCacheFile(
        bookId: novelId,
        chapterId: chapterId,
      );
      Map map = jsonDecode(await file.readAsString()) as Map;
      return (map['paragraphs'] as List)
          .map<String>((e) => e as String)
          .toList();
    } catch (_) {
      return const <String>[];
    }
  }

  ///把章节缓存下来
  Future<void> cacheParagraphs({
    required String novelId,
    required ChapterBean chapter,
  }) async {
    var file = await cacheFileController.getBookChapterParagraphsCacheFile(
      bookId: novelId,
      chapterId: chapter.chapterId,
    );
    await file.writeAsString(jsonEncode(<String, dynamic>{
      "paragraphs": chapter.paragraphs,
    }));
  }
}
