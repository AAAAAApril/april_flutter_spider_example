import 'package:april/widgets/value_listenable_builder.dart';
import 'package:books/generated/l10n.dart';
import 'package:books/pages/reading/reading.dart';
import 'package:books/repository/books_repository.dart';
import 'package:books/widget/net_work_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/beans/chapter_bean.dart';
import 'package:spider/novel/beans/novel_bean.dart';

///书籍详情页
class BookDetailPage extends StatefulWidget {
  const BookDetailPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  final String bookId;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  ///书籍详情
  late ValueNotifier<NovelBean?> bookDetail;

  ///所有章节是否倒序显示
  late ValueNotifier<bool> reverseOrder;

  @override
  void initState() {
    super.initState();
    bookDetail = ValueNotifier<NovelBean?>(null);
    reverseOrder = ValueNotifier<bool>(true);
    refreshBookDetail();
  }

  @override
  void dispose() {
    reverseOrder.dispose();
    bookDetail.dispose();
    super.dispose();
  }

  ///刷新书籍详情
  void refreshBookDetail() async {
    bookDetail.value = await BooksRepository.instance.repository.novelDetail(
      novelId: widget.bookId,
    );
  }

  ///切换是否倒序
  void switchReverseOrder(bool reverseOrder) {
    this.reverseOrder.value = reverseOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectorListenableBuilder<NovelBean?, String>(
          valueListenable: bookDetail,
          selector: (value) => value?.novelName ?? '',
          builder: (_, bookName, __) => Text(bookName),
        ),
        actions: [
          ///添加到书架按钮
          SelectorListenableBuilder<List<NovelBean>, bool>(
            valueListenable: BooksRepository.instance.allFavorites,
            selector: (value) {
              try {
                value.firstWhere((element) => element.novelId == widget.bookId);
                return true;
              } catch (_) {
                return false;
              }
            },
            builder: (context, favorite, child) => IconButton(
              onPressed: () {
                //已经是收藏了
                if (favorite) {
                  BooksRepository.instance.removeFromFavorites(widget.bookId);
                }
                //还不是收藏
                else {
                  BooksRepository.instance.add2Favorite(widget.bookId);
                }
              },
              color: favorite ? Colors.pinkAccent : Colors.grey,
              icon: const Icon(Icons.favorite_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<NovelBean?>(
        valueListenable: bookDetail,
        builder: (_, value, __) {
          if (value == null) {
            return const Center(
              child: SizedBox.square(
                dimension: 60,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: _Info(bean: value)),
              const SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.current.introduction,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    ...value.introduction.map<Widget>((e) => Text(e)),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(
                child: Row(children: [
                  Text(
                    Strings.current.allChapters,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Strings.current.isReverseOrder,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),

                  ///切换正序、倒序
                  ValueListenableBuilder<bool>(
                    valueListenable: reverseOrder,
                    builder: (_, value, __) => Checkbox(
                      value: value,
                      onChanged: (newValue) {
                        switchReverseOrder(newValue == true);
                      },
                    ),
                  ),
                ]),
              ),
              SelectorListenableBuilder<bool, List<ChapterPreviewBean>>(
                valueListenable: reverseOrder,
                selector: (reverse) {
                  if (reverse) {
                    return List.of(value.chapters).reversed.toList();
                  }
                  return value.chapters;
                },
                builder: (_, value, __) => _Chapters(
                  bookId: widget.bookId,
                  chapters: value,
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    Key? key,
    required this.bean,
  }) : super(key: key);

  final NovelBean bean;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ///封面
      NetworkImageWidget(bean.cover, width: 100),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///作者
            Text(Strings.current.author(bean.authorName)),

            ///分类
            Text(Strings.current.category(bean.categoryName)),

            ///最后更新章节
            Text.rich(
              TextSpan(
                text: Strings.current.latestChapter,
                children: [
                  TextSpan(
                    text: bean.lastChapter.chapterName,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        /// 前往阅读章节
                        Navigator.pushNamed(
                          context,
                          'reading',
                          arguments: ReadingArguments(
                            bean.novelId,
                            chapterId: bean.lastChapter.chapterId,
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class _Chapters extends StatelessWidget {
  const _Chapters({
    Key? key,
    required this.bookId,
    required this.chapters,
  }) : super(key: key);

  final String bookId;
  final List<ChapterPreviewBean> chapters;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final ChapterPreviewBean chapter = chapters[index];
          return GestureDetector(
            child: Text(chapter.chapterName),
            onTap: () {
              /// 前往阅读章节
              Navigator.pushNamed(
                context,
                'reading',
                arguments: ReadingArguments(
                  bookId,
                  chapterId: chapter.chapterId,
                ),
              );
            },
          );
        },
        childCount: chapters.length,
      ),
    );
  }
}
