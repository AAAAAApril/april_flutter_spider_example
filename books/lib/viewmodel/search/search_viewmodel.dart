import 'package:april/utils/utils.dart';
import 'package:books/books.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/beans/novel_bean.dart';

///搜索 ViewModel
class SearchViewModel extends ViewModel {
  ///搜索编辑框控制器
  final TextEditingController editingController = TextEditingController();

  ///搜索结果
  final ValueNotifier<List<NovelPreviewBean>> _searchResult =
      ValueNotifier(<NovelPreviewBean>[]);

  ValueListenable<List<NovelPreviewBean>> get searchResult => _searchResult;

  ///是否正在刷新
  final ValueNotifier<bool> _isRefreshing = ValueNotifier(false);

  ValueListenable<bool> get isRefreshing => _isRefreshing;

  @override
  void dispose() {
    _isRefreshing.dispose();
    _searchResult.dispose();
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
      _searchResult.value = <NovelPreviewBean>[];
      return;
    }
    //隐藏输入法，并清空焦点
    hideInputMethod();
    clearFocus();

    _isRefreshing.value = true;
    Books.repository.searchNovels(keywords).then<void>((value) {
      _searchResult.value = value;
    }).whenComplete(() {
      _isRefreshing.value = false;
    });
  }
}
