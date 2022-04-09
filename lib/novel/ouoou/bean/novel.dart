import 'dart:convert';

import 'package:april_spider/novel/ouoou/bean/chapter.dart';

///小说信息（简略）
class NovelBean {
  //TODO
}

///小说信息（详细）
class NovelDetailBean {
  const NovelDetailBean({
    required this.id,
    required this.name,
    required this.author,
    required this.category,
    required this.introduction,
    required this.status,
    required this.latestChapter,
    required this.allChapters,
    required this.latestUpdateTime,
    required this.latestUpdateTimeString,
  });

  ///小说id
  final String id;

  ///小说名字
  final String name;

  ///小说作者
  final String author;

  ///小说类别
  final String category;

  ///小说简介
  final List<String> introduction;

  ///作品状态
  final String status;

  ///最新章节
  final ChapterBean latestChapter;

  ///所有章节
  final List<ChapterBean> allChapters;

  ///最后更新时间
  final DateTime latestUpdateTime;

  ///最后更新时间（原始字符串）
  final String latestUpdateTimeString;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'author': author,
        'category': category,
        'introduction': introduction,
        'status': status,
        'latestUpdateTime': latestUpdateTimeString,
        'latestChapter': latestChapter.toMap(),
      };

  @override
  String toString() => jsonEncode(toMap()
    ..addAll({
      'allChapterCount': allChapters.length,
    }));
}
