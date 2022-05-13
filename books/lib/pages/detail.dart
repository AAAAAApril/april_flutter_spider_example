import 'package:april/widgets/value_listenable_builder.dart';
import 'package:books/generated/l10n.dart';
import 'package:books/viewmodel/detail/detail_viewmodel.dart';
import 'package:books/viewmodel/reading/reading_viewmodel.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:books/widget/net_work_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/bqg99/bean/chapter.dart';
import 'package:spider/novel/bqg99/bean/novel.dart';

///书籍详情页
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = ViewModel.of<BookDetailViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: SelectorListenableBuilder<NovelBean?, String>(
          valueListenable: viewModel.bookDetail,
          selector: (value) => value?.name ?? '',
          builder: (_, bookName, __) => Text(bookName),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO 添加到书架
            },
            icon: const Icon(Icons.favorite_rounded),
          ),
        ],
      ),
      body: ValueListenableBuilder<NovelBean?>(
        valueListenable: viewModel.bookDetail,
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
                    Text(value.introduction),
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
                  ValueListenableBuilder<bool>(
                    valueListenable: viewModel.reverseOrder,
                    builder: (_, value, __) => Checkbox(
                      value: value,
                      onChanged: (newValue) {
                        viewModel.switchReverseOrder(newValue == true);
                      },
                    ),
                  ),
                ]),
              ),
              SelectorListenableBuilder<bool, List<ChapterBean>>(
                valueListenable: viewModel.reverseOrder,
                selector: (reverse) {
                  if (reverse) {
                    return List.of(value.allChapters).reversed.toList();
                  }
                  return value.allChapters;
                },
                builder: (_, value, __) => _Chapters(chapters: value),
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
            Text(Strings.current.author(bean.author)),

            ///分类
            Text(Strings.current.category(bean.category)),

            ///状态
            Text(Strings.current.status(bean.status)),

            ///字数
            Text(Strings.current.wordsCount(bean.totalWordsCount)),

            ///最后更新章节
            Text.rich(
              TextSpan(
                text: Strings.current.latestChapter,
                children: [
                  TextSpan(
                    text: bean.latestUpdateChapter.name,
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
                            bean.id,
                            bean.latestUpdateChapter.id,
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
    required this.chapters,
  }) : super(key: key);

  final List<ChapterBean> chapters;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final ChapterBean chapter = chapters[index];
          return GestureDetector(
            child: Text(chapter.name),
            onTap: () {
              /// 前往阅读章节
              Navigator.pushNamed(
                context,
                'reading',
                arguments: ReadingArguments(
                  ViewModel.of<BookDetailViewModel>(context).bookId,
                  chapter.id,
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
