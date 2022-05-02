import 'package:books/viewmodel/viewmodel.dart';

///阅读页传参
class ReadingArguments {
  const ReadingArguments(
    this.bookId, [
    this.chapterId,
  ]);

  ///书籍 id
  final String bookId;

  ///想要直接阅读的章节 id
  ///如果这个值为 null，表示不直接阅读某个章节
  final String? chapterId;
}

///阅读页
class ReadingViewModel extends ViewModel {
  ReadingViewModel(this.arguments);

  ///必须参数
  final ReadingArguments arguments;
}
