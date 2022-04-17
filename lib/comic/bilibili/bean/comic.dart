import 'dart:convert';

import 'package:april/utils/json.dart';
import 'package:spider/comic/bilibili/bean/chapter.dart';
import 'package:spider/comic/bilibili/bean/cover.dart';

///漫画信息
class ComicBean {
  const ComicBean({
    required this.id,
    required this.name,
    required this.cover,
    required this.authors,
    required this.styles,
    required this.finished,
  });

  ///漫画 id
  final int id;

  ///漫画名
  final String name;

  ///漫画封面
  final ComicCover cover;

  ///漫画作者
  final List<String> authors;

  ///漫画风格
  final List<String> styles;

  ///是否完结
  final bool finished;

  factory ComicBean.fromJson(Map map) {
    var json = Json(map);
    return ComicBean(
      id: json.getInt('id'),
      name: json.getString('org_title'),
      cover: ComicCover(
        horizontal: json.getString('horizontal_cover'),
        vertical: json.getString('vertical_cover'),
        square: json.getString('square_cover'),
      ),
      authors: json.getStringList('author_name'),
      styles: json.getStringList('styles'),
      finished: json.getBool('is_finish', trueInt: 1),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'cover': cover.toMap(),
        'authors': authors,
        'styles': styles,
        'finished': finished,
      };

  @override
  String toString() => jsonEncode(toMap());
}

///漫画详情信息
class ComicDetailBean extends ComicBean {
  ComicDetailBean({
    required int id,
    required String name,
    required ComicCover cover,
    required List<String> authors,
    required List<String> styles,
    required bool finished,
    required this.description,
    required this.updateDesc,
    required this.chapterCount,
    required this.chapters,
  }) : super(
          id: id,
          name: name,
          cover: cover,
          authors: authors,
          styles: styles,
          finished: finished,
        );

  ///漫画简介
  final String description;

  ///更新描述（例如：每周三更新，每周四更新）
  final String updateDesc;

  ///总章节数
  final int chapterCount;

  ///所有的章节
  final List<ComicChapter> chapters;

  factory ComicDetailBean.fromJson(Map map) {
    var json = Json(map);
    return ComicDetailBean(
      id: json.getInt('id'),
      name: json.getString('title'),
      cover: ComicCover(
        horizontal: json.getString('horizontal_cover'),
        vertical: json.getString('vertical_cover'),
        square: json.getString('square_cover'),
      ),
      authors: json.getStringList('author_name').map<String>((e) {
        if (e.startsWith('原著: ')) {
          return e.replaceFirst('原著: ', '');
        }
        return e;
      }).toList(),
      styles: json.getStringList('styles'),
      finished: json.getBool('is_finish', trueInt: 1),
      description: json.getString('evaluate'),
      updateDesc: json.getString('renewal_time'),
      chapterCount: json.getInt('total'),
      chapters: json.getList<ComicChapter>(
        'ep_list',
        decoder: ComicChapter.fromJson,
      ),
    );
  }

  @override
  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      'description': description,
      'updateDesc': updateDesc,
      'chapterCount': chapterCount,
      'chapterLength': chapters.length,
    });

  @override
  String toString() => jsonEncode(toMap());
}
