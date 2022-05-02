import 'package:april/data/refreshable.dart';
import 'package:april/data/refreshable_controller.dart';
import 'package:april/data/refreshable_data_wrapper.dart';
import 'package:april/utils/utils.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:spider/log.dart';
import 'package:spider/novel/bqg99/bean/search.dart';
import 'package:spider/novel/bqg99/bqg.dart';

///搜索 ViewModel
class SearchViewModel extends ViewModel {
  ///搜索编辑框控制器
  final TextEditingController editingController = TextEditingController();

  ///搜索结果
  final _SearchDataController _searchController = _SearchDataController();

  Refreshable<SearchResultBean> get searchController => _searchController;

  @override
  void dispose() {
    editingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  ///清空输入
  void clearInput() {
    editingController.text = '';
  }

  ///开始搜索
  void doSearch() async {
    var keywords = editingController.text.trim();
    if (keywords.isEmpty) {
      _searchController.clearData();
      return;
    }
    Log.print(tag: '搜索关键词：$keywords');
    _searchController._doSearch(keywords);
    //隐藏输入法，并清空焦点
    hideInputMethod();
    clearFocus();
  }
}

class _SearchDataController
    extends AbsRefreshableController<SearchResultBean, _SearchDataWrapper> {
  String keywords = '';

  void _doSearch(String keywords) {
    this.keywords = keywords;
    refresh();
  }

  @override
  Future<void> refresh() async {
    if (keywords.isEmpty) {
      return;
    }
    return super.refresh();
  }

  @override
  Future<_SearchDataWrapper> refreshInternal() {
    return Bqg99.searchNovel(keywords).then(
      (value) => _SearchDataWrapper(value),
    );
  }
}

class _SearchDataWrapper extends AbsRefreshableDataWrapper<SearchResultBean> {
  _SearchDataWrapper(this.data);

  @override
  final List<SearchResultBean> data;

  @override
  bool get succeed => true;
}
