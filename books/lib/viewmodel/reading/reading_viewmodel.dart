import 'package:books/viewmodel/viewmodel.dart';

///阅读页
class ReadingViewModel extends ViewModel {
  ReadingViewModel(this.bookId);

  ///书籍 id
  final String bookId;
}
