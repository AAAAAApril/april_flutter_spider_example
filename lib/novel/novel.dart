import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:spider/novel/love_reading/repository/cache.dart';
import 'package:spider/novel/love_reading/repository/network.dart';

import 'beans/chapter_bean.dart';
import 'beans/novel_bean.dart';
import 'fetch_strategy.dart';
import 'repository.dart';

///小说接口抽象类
class Novel<N extends NetworkRepository, C extends CacheRepository> {
  static Novel loveReading() {
    return Novel<LoveReadingNetworkRepository, LoveReadingCacheRepository>(
      network: LoveReadingNetworkRepository(),
      cache: LoveReadingCacheRepository(),
    );
  }

  const Novel({
    required this.network,
    required this.cache,
  });

  ///缓存
  final C cache;

  ///网络
  final N network;

  //============================================================

  ///收藏小说
  ///[bool] 是否收藏成功
  Future<bool> addFavorite({
    required String novelId,
    FetchStrategy strategy = FetchStrategy.networkFirst,
  }) async {
    //获取小说详情
    final NovelBean? novel = await novelDetail(
      strategy: strategy,
      novelId: novelId,
    );
    if (novel == null) {
      return false;
    }
    //添加到收藏
    return cache.addFavorite(novel);
  }

  ///取消收藏小说
  Future<bool> removeFavorite(String novelId) => cache.removeFavorite(novelId);

  ///所有收藏的小说
  Future<List<NovelBean>> allFavorites() async {
    final List<NovelBean> novels = <NovelBean>[];
    for (var novelId in await cache.allFavorites()) {
      var detail = await novelDetail(novelId: novelId);
      if (detail != null) {
        novels.add(detail);
      }
    }
    return novels;
  }

  ///搜索小说
  Future<List<NovelPreviewBean>> searchNovels(String keywords) =>
      network.searchNovels(keywords);

  ///小说详情
  Future<NovelBean?> novelDetail({
    required String novelId,
    FetchStrategy strategy = FetchStrategy.networkFirst,
  }) async {
    final ConnectivityResult connectivity =
        await (Connectivity().checkConnectivity());
    switch (strategy) {

      ///网络优先
      case FetchStrategy.networkFirst:
        //有网络
        if (connectivity != ConnectivityResult.none) {
          NovelBean? novel = await network.novelDetail(novelId);
          if (novel != null) {
            //缓存下来
            await cache.cacheNovelDetail(novel);
            return novel;
          }
        }
        //没有网络，或者没有从网络中获取到
        return cache.novelDetail(novelId);

      ///缓存优先
      case FetchStrategy.cacheFirst:
        NovelBean? novel = await cache.novelDetail(novelId);
        if (novel != null) {
          return novel;
        }
        //缓存中没有，并且有网络
        if (connectivity != ConnectivityResult.none) {
          novel = await network.novelDetail(novelId);
          if (novel != null) {
            //缓存下来
            await cache.cacheNovelDetail(novel);
          }
        }
        return novel;

      ///仅缓存
      case FetchStrategy.cacheOnly:
        return cache.novelDetail(novelId);

      ///仅 wifi 环境下，网络优先，否则缓存优先
      case FetchStrategy.networkFirstOnlyWifi:
        //wifi 环境下
        if (connectivity == ConnectivityResult.wifi) {
          NovelBean? novel = await network.novelDetail(novelId);
          if (novel != null) {
            //缓存下来
            await cache.cacheNovelDetail(novel);
            return novel;
          }
          //没有从网络中获取到，取缓存
          return cache.novelDetail(novelId);
        }
        //其他情况
        else {
          NovelBean? novel = await cache.novelDetail(novelId);
          if (novel != null) {
            return novel;
          }
          novel = await network.novelDetail(novelId);
          if (novel != null) {
            //缓存下来
            await cache.cacheNovelDetail(novel);
          }
          return novel;
        }
    }
  }

  ///获取章节的所有段落
  Future<List<String>> fetchParagraphs({
    required String novelId,
    required ChapterPreviewBean chapter,
    FetchStrategy strategy = FetchStrategy.networkFirst,
  }) async {
    final ConnectivityResult connectivity =
        await (Connectivity().checkConnectivity());
    switch (strategy) {

      ///网络优先
      case FetchStrategy.networkFirst:
        //有网络
        if (connectivity != ConnectivityResult.none) {
          final List<String> paragraphs = await network.fetchParagraphs(
            novelId: novelId,
            chapterId: chapter.chapterId,
          );
          if (paragraphs.isNotEmpty) {
            //缓存下来
            await cache.cacheParagraphs(
              novelId: novelId,
              chapter: ChapterBean(
                chapterId: chapter.chapterId,
                chapterName: chapter.chapterName,
                paragraphs: paragraphs,
              ),
            );
            return paragraphs;
          }
        }
        //没有网络，或者没有网络数据
        return cache.fetchParagraphs(
          novelId: novelId,
          chapterId: chapter.chapterId,
        );

      ///缓存优先
      case FetchStrategy.cacheFirst:
        List<String> paragraphs = await cache.fetchParagraphs(
          novelId: novelId,
          chapterId: chapter.chapterId,
        );
        if (paragraphs.isNotEmpty) {
          return paragraphs;
        }
        //缓存没有，并且有网络
        if (connectivity != ConnectivityResult.none) {
          paragraphs = await network.fetchParagraphs(
            novelId: novelId,
            chapterId: chapter.chapterId,
          );
          if (paragraphs.isNotEmpty) {
            //缓存下来
            await cache.cacheParagraphs(
              novelId: novelId,
              chapter: ChapterBean(
                chapterId: chapter.chapterId,
                chapterName: chapter.chapterName,
                paragraphs: paragraphs,
              ),
            );
          }
        }
        return paragraphs;

      ///仅缓存
      case FetchStrategy.cacheOnly:
        return cache.fetchParagraphs(
          novelId: novelId,
          chapterId: chapter.chapterId,
        );

      ///仅 wifi 环境下，网络优先，否则缓存优先
      case FetchStrategy.networkFirstOnlyWifi:
        //wifi 环境
        if (connectivity == ConnectivityResult.wifi) {
          final List<String> paragraphs = await network.fetchParagraphs(
            novelId: novelId,
            chapterId: chapter.chapterId,
          );
          if (paragraphs.isNotEmpty) {
            //缓存下来
            await cache.cacheParagraphs(
              novelId: novelId,
              chapter: ChapterBean(
                chapterId: chapter.chapterId,
                chapterName: chapter.chapterName,
                paragraphs: paragraphs,
              ),
            );
            return paragraphs;
          }
          return cache.fetchParagraphs(
            novelId: novelId,
            chapterId: chapter.chapterId,
          );
        }
        //其他情况
        else {
          List<String> paragraphs = await cache.fetchParagraphs(
            novelId: novelId,
            chapterId: chapter.chapterId,
          );
          if (paragraphs.isNotEmpty) {
            return paragraphs;
          }
          paragraphs = await network.fetchParagraphs(
            novelId: novelId,
            chapterId: chapter.chapterId,
          );
          if (paragraphs.isNotEmpty) {
            //缓存下来
            await cache.cacheParagraphs(
              novelId: novelId,
              chapter: ChapterBean(
                chapterId: chapter.chapterId,
                chapterName: chapter.chapterName,
                paragraphs: paragraphs,
              ),
            );
          }
          return paragraphs;
        }
    }
  }
}
