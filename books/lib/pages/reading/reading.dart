import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO
    return Container();
  }
}
