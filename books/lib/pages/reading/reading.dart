import 'package:books/repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/beans/read_bean.dart';

///阅读页传参
class ReadingArguments {
  const ReadingArguments(
    this.bookId, {
    this.readLocation = const ReadBean.start(),
  });

  ///书籍 id
  final String bookId;

  ///当前阅读位置
  final ReadBean readLocation;
}

///阅读页
class ReadingPage extends StatefulWidget {
  const ReadingPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final ReadingArguments arguments;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  ///当前阅读位置
  late ReadBean currentReadLocation;

  @override
  void initState() {
    super.initState();
    currentReadLocation = widget.arguments.readLocation;
    if (currentReadLocation.atStart) {
      checkCurrentReadingChapter();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 从缓存中获取当前已经阅读到的章节
  void checkCurrentReadingChapter() async {
    currentReadLocation =
        await BooksRepository.instance.repository.currentReadChapter(
      widget.arguments.bookId,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO
    return Container();
  }
}
