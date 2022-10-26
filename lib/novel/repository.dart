import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'beans/chapter_bean.dart';
import 'beans/novel_bean.dart';

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

///缓存文件/文件夹控制器
///
///
/// 文件结构如下：
///
/// -｜ app_[cache_name]_cache_dir（缓存顶级文件夹）
///   -｜ favorite_books.txt（缓存收藏的书籍的ID）
///   -｜ book_details_dir（缓存的书籍详情文件夹）
///     -｜ book_[novelId_1]_dir（具体的书籍详情文件夹，以书籍 id 为文件夹名）
///     -｜ book_[novelId_2]_dir（具体的书籍详情文件夹，以书籍 id 为文件夹名）
///       -｜ info.txt（缓存的书籍详情，不包含章节数据）
///       -｜ chapters.txt（书籍的章节数据，不包含具体的段落）
///       -｜ chapters_dir（所有缓存的章节段落文件夹）
///         -｜ [chapterId_1].txt（缓存的章节段落，以 章节 id 为文件名）
///         -｜ [chapterId_2].txt（缓存的章节段落，以 章节 id 为文件名）
///
///
class CacheFileController {
  CacheFileController(this.cacheName);

  ///缓存名
  final String cacheName;

  ///缓存根文件夹
  late final Future<Directory> topLevelCacheDir =
      getExternalStorageDirectory().then<Directory>((value) async {
    assert(value != null);
    Directory result = Directory(path.join(
      value!.absolute.path,
      'app_${cacheName}_cache_dir',
    ));
    if (!(await result.exists())) {
      result = await result.create(recursive: true);
    }
    return result;
  });

  ///收藏书籍列表
  late final Future<File> favoritesCacheFile =
      topLevelCacheDir.then<File>((value) async {
    File result = File(path.join(
      value.absolute.path,
      'favorite_books.txt',
    ));
    if (!(await result.exists())) {
      result = await result.create(recursive: true);
    }
    return result;
  });

  ///所有的书籍缓存文件夹
  late final Future<Directory> allBooksCacheDir =
      topLevelCacheDir.then<Directory>((value) async {
    Directory result = Directory(path.join(
      value.absolute.path,
      'book_details_dir',
    ));
    if (!(await result.exists())) {
      result = await result.create(recursive: true);
    }
    return result;
  });

  ///书籍详情缓存文件夹运行时缓存
  final Map<String, Directory> _booksDetailCacheDirs = <String, Directory>{};

  ///书籍详情缓存文件夹
  Future<Directory> getBookDetailsCacheDir(String bookId) async {
    Directory? result = _booksDetailCacheDirs[bookId];
    if (result == null) {
      result = Directory(path.join(
        (await allBooksCacheDir).absolute.path,
        'book_${bookId}_dir',
      ));
      if (!(await result.exists())) {
        result = await result.create(recursive: true);
      }
      _booksDetailCacheDirs[bookId] = result;
    }
    return result;
  }

  ///书籍详情信息文件运行时缓存
  final Map<String, File> _bookDetailInfoCacheFile = <String, File>{};

  ///书籍详情信息缓存文件（不包含章节信息）
  Future<File> getBookDetailInfoCacheFile(String bookId) async {
    File? result = _bookDetailInfoCacheFile[bookId];
    if (result == null) {
      result = File(path.join(
        (await getBookDetailsCacheDir(bookId)).absolute.path,
        'info.txt',
      ));
      if (!(await result.exists())) {
        result = await result.create(recursive: true);
      }
      _bookDetailInfoCacheFile[bookId] = result;
    }
    return result;
  }

  ///书籍章节文件运行时缓存
  final Map<String, File> _bookChaptersCacheFile = <String, File>{};

  ///书籍章节缓存文件（不包含段落信息）
  Future<File> getBookChaptersCacheFile(String bookId) async {
    File? result = _bookChaptersCacheFile[bookId];
    if (result == null) {
      result = File(path.join(
        (await getBookDetailsCacheDir(bookId)).absolute.path,
        'chapters.txt',
      ));
      if (!(await result.exists())) {
        result = await result.create(recursive: true);
      }
      _bookChaptersCacheFile[bookId] = result;
    }
    return result;
  }

  ///书籍章节的段落详情文件夹运行时缓存
  final Map<String, Directory> _bookChaptersCacheDir = <String, Directory>{};

  ///书籍章节的段落详情缓存文件夹
  Future<Directory> getBookChaptersCacheDir(String bookId) async {
    Directory? result = _bookChaptersCacheDir[bookId];
    if (result == null) {
      result = Directory(path.join(
        (await getBookDetailsCacheDir(bookId)).absolute.path,
        'chapters_dir',
      ));
      if (!(await result.exists())) {
        result = await result.create(recursive: true);
      }
      _bookChaptersCacheDir[bookId] = result;
    }
    return result;
  }

  ///书籍章节的段落详情缓存文件运行时缓存
  final Map<Directory, File> _bookChapterParagraphsCacheFile =
      <Directory, File>{};

  ///书籍章节段落缓存文件
  Future<File> getBookChapterParagraphsCacheFile({
    required String bookId,
    required String chapterId,
  }) async {
    Directory chaptersDir = await getBookChaptersCacheDir(bookId);
    File? chapter = _bookChapterParagraphsCacheFile[chaptersDir];
    if (chapter == null) {
      chapter = File(path.join(
        chaptersDir.absolute.path,
        '$chapterId.txt',
      ));
      if (!(await chapter.exists())) {
        chapter = await chapter.create(recursive: true);
      }
      _bookChapterParagraphsCacheFile[chaptersDir] = chapter;
    }
    return chapter;
  }
}
