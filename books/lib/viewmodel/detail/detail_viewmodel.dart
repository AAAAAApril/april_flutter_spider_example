import 'package:april/data/notifier_mixin.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:spider/novel/bqg99/bean/novel.dart';
import 'package:spider/novel/bqg99/bqg.dart';

///书籍详情 ViewModel
class BookDetailViewModel extends ViewModel {
  BookDetailViewModel(this.bookId) {
    _refresh();
  }

  ///书籍 id
  final String bookId;

  ///书籍详情
  late final ValueNotifier<NovelBean?> _bookDetail =
      ValueNotifier<NovelBean?>(null)..withMixin(this);

  ValueListenable<NovelBean?> get bookDetail => _bookDetail;

  ///所有章节是否倒序显示
  late final ValueNotifier<bool> _reverseOrder = ValueNotifier<bool>(true)
    ..withMixin(this);

  ValueListenable<bool> get reverseOrder => _reverseOrder;

  ///切换是否倒序
  void switchReverseOrder(bool reverseOrder) {
    _reverseOrder.value = reverseOrder;
  }

  ///刷新详情数据
  void _refresh() async {
    _bookDetail.value = await Bqg99.novelDetail(bookId);
  }
}
