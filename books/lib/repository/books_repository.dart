import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:books/repository/search_refreshable.dart';
import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/fetch_strategy.dart';
import 'package:spider/novel/love_reading/repository/cache.dart';
import 'package:spider/novel/love_reading/repository/network.dart';
import 'package:spider/novel/novel.dart';

import 'enums/font_family_name.dart';
import 'global_configs.dart';

class BooksRepository {
  static final BooksRepository instance = BooksRepository._();

  BooksRepository._() {
    //查询所有收藏的书籍
    _refreshFavorites();
  }

  ///小说数据源
  final Novel<LoveReadingNetworkRepository, BookCacheRepository> repository =
      Novel<LoveReadingNetworkRepository, BookCacheRepository>(
    network: LoveReadingNetworkRepository(),
    cache: BookCacheRepository._(),
  );

  ///书架上收藏的所有书籍
  final ValueNotifier<List<NovelBean>> _allFavorites =
      ValueNotifier<List<NovelBean>>(<NovelBean>[]);

  ValueListenable<List<NovelBean>> get allFavorites => _allFavorites;

  ///搜索控制器
  late final SearchRefreshableController searchController =
      SearchRefreshableController(repository: repository);

  /// 添加书籍到书架
  Future<bool> add2Favorite(String bookId) async {
    if (await repository.addFavorite(
      novelId: bookId,
      strategy: FetchStrategy.cacheFirst,
    )) {
      _refreshFavorites();
      return true;
    }
    return false;
  }

  /// 从书架移除书籍
  Future<bool> removeFromFavorites(String bookId) async {
    if (await repository.removeFavorite(bookId)) {
      _refreshFavorites();
      return true;
    }
    return false;
  }

  ///刷新全部收藏
  Future<void> _refreshFavorites() async {
    var result = await repository.allFavorites();
    _allFavorites.value = result;
  }
}

/// 本地缓存
class BookCacheRepository extends LoveReadingCacheRepository {
  BookCacheRepository._() : super() {
    _getConfigsCache();
  }

  ///缓存文件
  late final Future<File> _bookAppConfigsCacheFile =
      cacheFileController.topLevelCacheDir.then<File>((value) async {
    File result = File(path.join(
      value.parent.absolute.path,
      'book_app_configs_cache.txt',
    ));
    if (!(await result.exists())) {
      result = await result.create(recursive: true);
    }
    return result;
  });

  ///全局配置
  final ValueNotifier<GlobalConfigs> _globalConfigs =
      ValueNotifier<GlobalConfigs>(GlobalConfigs.def);

  ValueListenable<GlobalConfigs> get globalConfigs => _globalConfigs;

  ///修改全局主题模式
  void changeGlobalThemeMode(ThemeMode mode) {
    _globalConfigs.value = _globalConfigs.value.copy(
      themeMode: mode,
    );
    _notifyCache();
  }

  ///修改全局字体样式
  void changeGlobalFontFamily(FontFamilyName name) {
    _globalConfigs.value = _globalConfigs.value.copy(
      globalFontFamily: name,
    );
    _notifyCache();
  }

  ///获取配置缓存
  void _getConfigsCache() async {
    //取出配置数据
    try {
      var file = await _bookAppConfigsCacheFile;
      var content = await file.readAsString();
      _globalConfigs.value = GlobalConfigs.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(content),
        ),
      );
    } catch (_) {
      //ignore
    }
  }

  ///更新缓存
  void _notifyCache() async {
    var file = await _bookAppConfigsCacheFile;
    await file.writeAsString(
      jsonEncode(
        _globalConfigs.value.toJson(),
      ),
    );
  }
}
