import 'package:books/generated/l10n.dart';
import 'package:books/repository/books_repository.dart';
import 'package:books/widget/net_work_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spider/novel/beans/novel_bean.dart';
import 'package:april/utils/extensions.dart';

import 'reading/reading.dart';

///书架
class BookShelfPage extends StatelessWidget {
  const BookShelfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<NovelBean>>(
      valueListenable: BooksRepository.instance.allFavorites,
      builder: (context, value, child) => ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          final bean = value[index];
          void readLast() {
            ///前往阅读最后一章
            Navigator.pushNamed(
              context,
              'reading',
              arguments: ReadingArguments(
                bean.novelId,
                chapterId: bean.lastChapter.chapterId,
              ),
            );
          }

          return TextButton(
            onPressed: () {
              ///前往阅读页
              Navigator.pushNamed(
                context,
                'reading',
                arguments: ReadingArguments(bean.novelId),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///封面
                NetworkImageWidget(bean.cover, width: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///书名
                      Text(
                        bean.novelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ///作者
                      Text(Strings.current.author(bean.authorName)),

                      ///类型
                      Text(Strings.current.category(bean.categoryName)),

                      ///最近章节
                      Text.rich(
                        TextSpan(
                          text: Strings.current.latestChapter,
                          children: [
                            TextSpan(
                              text: bean.lastChapter.chapterName,
                              recognizer: TapGestureRecognizer()
                                ..onTap = readLast,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ].wrapWithWidget(
                      removeFirst: true,
                      removeLast: true,
                      builder: (length, currentIndex) =>
                          const SizedBox(height: 6),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
