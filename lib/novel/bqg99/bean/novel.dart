import 'dart:convert';

import 'package:spider/novel/bqg99/bean/chapter.dart';

///小说详情
class NovelBean {
  const NovelBean({
    required this.id,
    required this.name,
    required this.cover,
    required this.author,
    required this.totalWordsCount,
    required this.category,
    required this.status,
    required this.introduction,
    required this.latestUpdateChapter,
    required this.allChapters,
  });

  ///小说 id
  final String id;

  ///小说名字
  final String name;

  ///小说封面
  final String cover;

  ///小说作者
  final String author;

  ///小说目前总字数
  final int totalWordsCount;

  ///小说分类（比如：玄幻、都市）
  final String category;

  ///小说状态（比如：连载、完结）
  final String status;

  ///小说简介
  final String introduction;

  ///最后更新的章节
  final LatestChapterBean latestUpdateChapter;

  ///目前所有的章节
  final List<ChapterBean> allChapters;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'cover': cover,
        'author': author,
        'totalWordsCount': totalWordsCount,
        'category': category,
        'status': status,
        'introduction': introduction,
        'latestUpdateChapter': latestUpdateChapter.toMap(),
        'allChaptersLength': allChapters.length,
      };

  @override
  String toString() => jsonEncode(toMap());
}
