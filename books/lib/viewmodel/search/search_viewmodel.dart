import 'package:april/data/notifier_mixin.dart';
import 'package:april/utils/utils.dart';
import 'package:books/repository/repository.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/bqg99/bean/search.dart';

///搜索 ViewModel
class SearchViewModel extends ViewModel {
  ///搜索编辑框控制器
  final TextEditingController editingController = TextEditingController();

  ///搜索结果
  late final ValueNotifier<List<SearchResultBean>> _searchResult =
      ValueNotifier(<SearchResultBean>[])..withMixin(this);

  ValueListenable<List<SearchResultBean>> get searchResult => _searchResult;

  ///是否正在刷新
  late final ValueNotifier<bool> _isRefreshing = ValueNotifier(false)
    ..withMixin(this);

  ValueListenable<bool> get isRefreshing => _isRefreshing;

  @override
  void dispose() {
    editingController.dispose();
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
      _searchResult.value = <SearchResultBean>[];
      return;
    }
    //隐藏输入法，并清空焦点
    hideInputMethod();
    clearFocus();

    _isRefreshing.value = true;
    Repository.search(keywords).then<void>((value) {
      _searchResult.value = value;
    }).whenComplete(() {
      _isRefreshing.value = false;
    });
  }
}
