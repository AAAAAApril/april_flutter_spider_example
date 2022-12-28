import 'package:flutter/material.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:spider/novel/beans/chapter_bean.dart';
import 'package:spider/novel/beans/read_bean.dart';
import 'package:spider/fetch_strategy.dart';

import 'package:books/repository/books_repository.dart';

///阅读的段落列表
class ReadingParagraphs extends StatefulWidget {
  const ReadingParagraphs({
    Key? key,
    required this.bookId,
    required this.currentChapter,
    required this.readLocation,
  }) : super(key: key);

  ///当前所属书籍
  final String bookId;

  ///当前段落所属章节
  final ChapterPreviewBean currentChapter;

  ///正在阅读的位置
  final ReadBean readLocation;

  @override
  State<ReadingParagraphs> createState() => _ReadingParagraphsState();
}

class _ReadingParagraphsState extends State<ReadingParagraphs> {
  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener positionsListener =
      ItemPositionsListener.create();

  late ValueNotifier<List<String>> paragraphs;
  late ReadBean readLocation;

  @override
  void initState() {
    super.initState();
    paragraphs = ValueNotifier<List<String>>(<String>[]);
    readLocation = widget.readLocation;
    fetchParagraphs();
    positionsListener.itemPositions.addListener(postReadStatus);
  }

  @override
  void didUpdateWidget(covariant ReadingParagraphs oldWidget) {
    if (widget.currentChapter != oldWidget.currentChapter ||
        widget.readLocation != oldWidget.readLocation) {
      readLocation = widget.readLocation;
      jump2Paragraph();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    positionsListener.itemPositions.removeListener(postReadStatus);
    paragraphs.dispose();
    super.dispose();
  }

  ///拉取段落信息
  void fetchParagraphs() async {
    var result = await BooksRepository.instance.repository.fetchParagraphs(
      novelId: widget.bookId,
      chapter: widget.currentChapter,
      strategy: FetchStrategy.cacheFirst,
    );
    if (!mounted) {
      return;
    }
    paragraphs.value = result;
    jump2Paragraph();
  }

  ///上报阅读状态
  void postReadStatus() async {
    if (widget.currentChapter.chapterId != readLocation.chapterId) {
      //还没阅读到当前章节，不处理
      return;
    }
    Iterable<ItemPosition> positions = positionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      //查看缓存中的位置
      var readBean =
          await BooksRepository.instance.repository.currentReadChapter(
        widget.bookId,
      );
      if (readBean.chapterId != widget.currentChapter.chapterId) {
        //缓存的章节和当前的不一致
        return;
      }
      //更新缓存
      BooksRepository.instance.repository.notifyCurrentReadChapter(
        novelId: widget.bookId,
        read: readBean.copy(
          paragraphIndex: positions.first.index,
        ),
      );
    }
  }

  ///跳转到目标位置
  void jump2Paragraph() async {
    if (widget.currentChapter.chapterId != readLocation.chapterId) {
      //还没阅读到当前章节，不处理
      return;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) {
      return;
    }
    if (!scrollController.isAttached) {
      return;
    }
    scrollController.jumpTo(index: readLocation.paragraphIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            widget.currentChapter.chapterName,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
      Expanded(
        child: ValueListenableBuilder<List<String>>(
          valueListenable: paragraphs,
          builder: (context, value, child) {
            if (value.isEmpty) {
              return const Center(
                child: SizedBox.square(
                  dimension: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ScrollablePositionedList.builder(
              itemScrollController: scrollController,
              itemPositionsListener: positionsListener,
              itemCount: value.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              itemBuilder: (context, index) {
                if (index < 0 || index >= value.length) {
                  return const SizedBox.shrink();
                }
                return Text(value[index]);
              },
            );
          },
        ),
      ),
    ]);
  }
}
