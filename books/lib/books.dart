import 'package:flutter/foundation.dart';
import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/love_reading/repository/cache.dart';
import 'package:spider/novel/love_reading/repository/network.dart';
import 'package:spider/novel/novel.dart';

class Books {
  Books._() {
    //查询所有收藏的书籍
    repository.allFavorites().then<void>((value) {
      _allFavorites.value = value;
    });
  }

  ///小说数据源
  static final Novel<LoveReadingNetworkRepository, BookCacheRepository>
      repository = Novel<LoveReadingNetworkRepository, BookCacheRepository>(
    network: LoveReadingNetworkRepository(),
    cache: BookCacheRepository._(),
  );

  ///书架上收藏的所有书籍
  final ValueNotifier<List<NovelBean>> _allFavorites =
      ValueNotifier<List<NovelBean>>(<NovelBean>[]);

  ValueListenable<List<NovelBean>> get allFavorites => _allFavorites;

  ///TODO 添加书籍到书架
  void add2Favorite(String bookId) async {}

  ///TODO 从书架移除书籍
  void removeFromFavorites(String bookId) async {}
}

///TODO 本地缓存
class BookCacheRepository extends LoveReadingCacheRepository {
  BookCacheRepository._() : super();
}
