import 'package:flutter/widgets.dart';

import 'package:april/data/refreshable_controller.dart';
import 'package:april/data/refreshable_data_wrapper.dart';
import 'package:april/utils/utils.dart';

import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/love_reading/repository/network.dart';
import 'package:spider/novel/novel.dart';

import 'books_repository.dart';

///书籍搜索控制器
class SearchRefreshableController extends AbsRefreshableController<
    NovelPreviewBean, NovelRefreshableDataWrapper> {
  SearchRefreshableController({
    required this.repository,
  }) : super();

  ///搜索编辑框控制器
  final TextEditingController editingController = TextEditingController();

  ///数据源
  final Novel<LoveReadingNetworkRepository, BookCacheRepository> repository;

  ///搜索结果运行时缓存
  final Map<String, List<NovelPreviewBean>> _searchResultCache =
      <String, List<NovelPreviewBean>>{};

  ///搜索关键词
  String _keywords = '';

  ///开始搜索
  Future<void> search() async {
    if (isRefreshing.value) {
      return;
    }
    _keywords = editingController.text.trim();
    if (_keywords.isNotEmpty) {
      //隐藏输入法，并清空焦点
      hideInputMethod();
      clearFocus();
    }
    return refresh();
  }

  ///清空关键词
  Future<void> clearKeywords() {
    editingController.clear();
    return search();
  }

  @override
  Future<NovelRefreshableDataWrapper> refreshInternal() async {
    if (_keywords.isEmpty) {
      return const NovelRefreshableDataWrapper.empty();
    }
    List<NovelPreviewBean>? cache = _searchResultCache[_keywords];
    if (cache == null || cache.isEmpty) {
      cache = await repository.searchNovels(keywords: _keywords);
      if (cache.isNotEmpty) {
        _searchResultCache[_keywords] = cache;
      }
    }
    return NovelRefreshableDataWrapper(data: cache);
  }
}

class NovelRefreshableDataWrapper
    implements AbsRefreshableDataWrapper<NovelPreviewBean> {
  const NovelRefreshableDataWrapper.empty()
      : this(data: const <NovelPreviewBean>[]);

  const NovelRefreshableDataWrapper({
    required this.data,
    this.succeed = true,
  });

  @override
  final List<NovelPreviewBean> data;

  @override
  final bool succeed;
}
