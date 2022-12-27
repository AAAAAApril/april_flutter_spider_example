import 'package:books/pages/reading/chapters.dart';
import 'package:books/repository/global_configs.dart';
import 'package:flutter/material.dart';

import 'package:april_flutter_utils/april.dart';
import 'package:spider/log.dart';
import 'package:spider/novel/beans/chapter_bean.dart';

import 'package:spider/novel/beans/novel_bean.dart';
import 'package:spider/novel/beans/read_bean.dart';
import 'package:spider/novel/fetch_strategy.dart';

import 'package:books/repository/books_repository.dart';

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
  ///小说详情
  late ValueNotifier<NovelBean?> novel;

  ///当前阅读位置
  late ReadBean currentReadLocation;

  @override
  void initState() {
    super.initState();
    // enterFullScreen();
    novel = ValueNotifier<NovelBean?>(null);
    currentReadLocation = widget.arguments.readLocation;
    if (currentReadLocation.atStart) {
      checkCurrentReadingChapter();
    }
    fetchNovelDetail();
  }

  @override
  void dispose() {
    novel.dispose();
    // exitFullScreen();
    super.dispose();
  }

  /// 从缓存中获取当前已经阅读到的章节
  void checkCurrentReadingChapter() async {
    currentReadLocation =
        await BooksRepository.instance.repository.currentReadChapter(
      widget.arguments.bookId,
    );
    assert(
      Log.print(
        tag: '缓存中已经阅读到的位置（${widget.arguments.bookId}）',
        value: () => currentReadLocation.toString(),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  ///获取小说详情
  void fetchNovelDetail() async {
    var result = await BooksRepository.instance.repository.novelDetail(
      novelId: widget.arguments.bookId,
      strategy: FetchStrategy.cacheFirst,
    );
    if (!mounted) {
      return;
    }
    assert(
      Log.print(
        tag: '章节总数（${widget.arguments.bookId}）',
        value: () => result?.chapters.length,
      ),
    );
    novel.value = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<GlobalConfigs>(
        valueListenable:
            BooksRepository.instance.repository.cache.globalConfigs,
        builder: (context, value, child) => DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: value.readFontSize.toDouble(),
            fontFamily: value.readFontFamily.value,
          ),
          child:
              SelectorListenableBuilder<NovelBean?, List<ChapterPreviewBean>>(
            valueListenable: novel,
            selector: (value) {
              if (value == null) {
                return <ChapterPreviewBean>[];
              }
              return value.chapters;
            },
            builder: (context, value, child) {
              if (value.isEmpty) {
                return const Center(
                  child: SizedBox.square(
                    dimension: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return ReadingChapters(
                bookId: widget.arguments.bookId,
                chapters: value,
                currentReadLocation: currentReadLocation,
              );
            },
          ),
        ),
      ),
    );
  }
}
