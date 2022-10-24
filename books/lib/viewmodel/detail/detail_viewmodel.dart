import 'package:books/main.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:spider/novel/beans/novel_bean.dart';

///书籍详情 ViewModel
class BookDetailViewModel extends ViewModel {
  BookDetailViewModel(this.bookId) {
    _refresh();
  }

  @override
  void dispose() {
    _reverseOrder.dispose();
    _bookDetail.dispose();
    super.dispose();
  }

  ///书籍 id
  final String bookId;

  ///书籍详情
  final ValueNotifier<NovelBean?> _bookDetail = ValueNotifier<NovelBean?>(null);

  ValueListenable<NovelBean?> get bookDetail => _bookDetail;

  ///所有章节是否倒序显示
  final ValueNotifier<bool> _reverseOrder = ValueNotifier<bool>(true);

  ValueListenable<bool> get reverseOrder => _reverseOrder;

  ///切换是否倒序
  void switchReverseOrder(bool reverseOrder) {
    _reverseOrder.value = reverseOrder;
  }

  ///刷新详情数据
  void _refresh() async {
    _bookDetail.value = await novel.novelDetail(novelId: bookId);
  }
}
