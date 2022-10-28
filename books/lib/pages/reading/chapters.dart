import 'package:books/pages/reading/paragraphs.dart';
import 'package:books/repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/beans/chapter_bean.dart';
import 'package:spider/novel/beans/read_bean.dart';

///阅读的章节列表
class ReadingChapters extends StatefulWidget {
  const ReadingChapters({
    Key? key,
    required this.bookId,
    required this.chapters,
    required this.currentReadLocation,
  }) : super(key: key);

  ///当前书籍
  final String bookId;

  ///所有已知的章节
  final List<ChapterPreviewBean> chapters;

  ///当前阅读到的位置
  final ReadBean currentReadLocation;

  @override
  State<ReadingChapters> createState() => _ReadingChaptersState();
}

class _ReadingChaptersState extends State<ReadingChapters> {
  late PageController pageController;

  ///阅读到的位置
  late ReadBean readLocation;

  @override
  void initState() {
    super.initState();
    int currentIndex = widget.chapters.indexWhere(
      (element) => element.chapterId == widget.currentReadLocation.chapterId,
    );
    if (currentIndex < 0) {
      currentIndex = 0;
    }
    pageController = PageController(
      initialPage: currentIndex,
    );
    readLocation = widget.currentReadLocation;
  }

  @override
  void didUpdateWidget(covariant ReadingChapters oldWidget) {
    if (widget.chapters != oldWidget.chapters ||
        widget.currentReadLocation != oldWidget.currentReadLocation) {
      readLocation = widget.currentReadLocation;
      jump2Current();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  ///上报阅读状态
  void postReadStatus(int newIndex) async {
    //切换到了新章节
    var chapter = widget.chapters[newIndex];
    //查看缓存中的位置
    var readBean = await BooksRepository.instance.repository.currentReadChapter(
      widget.bookId,
    );
    //不一致
    if (chapter.chapterId != readBean.chapterId) {
      //更新缓存
      BooksRepository.instance.repository.notifyCurrentReadChapter(
        novelId: widget.bookId,
        read: ReadBean(chapterId: chapter.chapterId),
      );
    }
  }

  ///跳转到当前章节
  void jump2Current() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) {
      return;
    }
    if (!pageController.hasClients) {
      return;
    }
    int currentIndex = widget.chapters.indexWhere(
      (element) => element.chapterId == readLocation.chapterId,
    );
    if (currentIndex < 0) {
      currentIndex = 0;
    }
    pageController.jumpTo(currentIndex.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: widget.chapters.length,
      onPageChanged: postReadStatus,
      itemBuilder: (context, index) => ReadingParagraphs(
        bookId: widget.bookId,
        currentChapter: widget.chapters[index],
        readLocation: readLocation,
      ),
    );
  }
}
