import 'dart:io';

import 'package:april/utils/extensions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

///文件缓存
///
///
/// 文件结构如下：
///
/// - app_books_cache_dir（缓存顶级文件夹）
///   - favorite_books_dir（喜欢的书籍文件夹）
///     - book_[bookId_1].txt（具体的书籍信息，以书籍 id 为文件名）
///     - book_[bookId_2].txt（具体的书籍信息，以书籍 id 为文件名）
///   - book_details_dir（缓存的书籍详情文件夹）
///     - book_[bookId_1]_dir（具体的书籍详情文件夹，以书籍 id 为文件夹名）
///     - book_[bookId_2]_dir（具体的书籍详情文件夹，以书籍 id 为文件夹名）
///       - info.txt（缓存的书籍详情，不包含章节数据）
///       - chapters.txt（书籍的章节数据，不包含具体的段落）
///       - chapters_dir（所有缓存的章节段落文件夹）
///         - [chapterId_1].txt（缓存的章节段落，以 章节 id 为文件名）
///         - [chapterId_2].txt（缓存的章节段落，以 章节 id 为文件名）
///
///
class Cache {
  Cache._();

  ///缓存顶级文件夹（如果不存在，则会创建）
  static late final Future<Directory?> _topLevelCacheDir = () async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      return null;
    }
    directory = Directory(join(
      directory.absolute.path,
      'app_books_cache_dir',
    ));
    if (!(await directory.exists())) {
      try {
        directory = await directory.create(recursive: true);
      } catch (_) {
        return null;
      }
    }
    return directory;
  }();

  ///喜欢的书籍文件夹（如果不存在，则会创建）
  static late final Future<Directory?> _favoriteBooksCacheDir = () async {
    final Directory? topLevel = await _topLevelCacheDir;
    if (topLevel == null) {
      return null;
    }
    Directory result = Directory(join(
      topLevel.absolute.path,
      'favorite_books_dir',
    ));
    if (!(await result.exists())) {
      try {
        result = await result.create(recursive: true);
      } catch (_) {
        return null;
      }
    }
    return result;
  }();

  ///缓存书籍详情的文件夹（如果不存在，则会创建）
  static late final Future<Directory?> _bookDetailsCacheDir = () async {
    final Directory? topLevel = await _topLevelCacheDir;
    if (topLevel == null) {
      return null;
    }
    Directory result = Directory(join(
      topLevel.absolute.path,
      'book_details_dir',
    ));
    if (!(await result.exists())) {
      try {
        result = await result.create(recursive: true);
      } catch (_) {
        return null;
      }
    }
    return result;
  }();

  //============================================================================

  ///喜欢的书籍缓存文件（如果不存在，不会创建）
  static Future<File?> _favoriteBookFile(String bookId) async {
    Directory? dir = await _favoriteBooksCacheDir;
    if (dir == null) {
      return null;
    }
    return File(join(
      dir.absolute.path,
      'book_$bookId.txt',
    ));
  }

  ///所有喜欢的书籍文件列
  static Future<List<File>> _allFavoriteBooks() async {
    Directory? dir = await _favoriteBooksCacheDir;
    if (dir == null) {
      return <File>[];
    }
    final List<File> result = <File>[];
    for (var element in (await dir.list().toList())) {
      //是文件
      if (element is File) {
        var fileName = element.absolute.path.fileNameFromPath();
        //文件名符合规则
        if (fileName.startsWith('book_') && fileName.endsWith('.txt')) {
          result.add(element);
        }
      }
    }
    return result;
  }

  ///获取喜欢的书籍数据列
  static Future<List<FavoriteBookBean>> getAllFavoriteBooks() async {
    final List<FavoriteBookBean> result = <FavoriteBookBean>[];
    for (var element in (await _allFavoriteBooks())) {
      try {
        result.add(
          FavoriteBookBean.fromJson(
            await element.readAsString(),
          ),
        );
      } catch (_) {
        //ignore
      }
    }
    return result;
  }

  ///缓存喜欢的书籍数据（如果不存在，则会创建）
  static Future<bool> cacheFavoriteBook(FavoriteBookBean bean) async {
    File? file = await _favoriteBookFile(bean.id);
    if (file == null) {
      return false;
    }
    //文件不存在
    if (!(await file.exists())) {
      try {
        //创建文件
        file = await file.create(recursive: true);
      } catch (_) {
        return false;
      }
    }
    //写入数据
    await file.writeAsString(bean.toString());
    return true;
  }

  //============================================================================

  ///书籍详情缓存文件夹（如果不存在，不会创建）
  static Future<Directory?> _bookDetailDir(String bookId) async {
    Directory? parent = await _bookDetailsCacheDir;
    if (parent == null) {
      return null;
    }
    return Directory(join(
      parent.absolute.path,
      'book_${bookId}_dir',
    ));
  }

  ///获取缓存的书籍详情（包含章节）

  ///缓存书籍详情（包含章节）
  ///获取章节的所有段落
  ///缓存章节的所有段落

}
