import 'dart:convert';

import 'package:april/utils/json.dart';
import 'package:spider/novel/bqg99/bean/chapter.dart';

///书架书籍
class FavoriteBookBean {
  const FavoriteBookBean({
    required this.id,
    required this.name,
    required this.author,
    required this.cover,
    required this.latestChapter,
  });

  ///书籍 id
  final String id;

  ///书籍名
  final String name;

  ///书籍作者
  final String author;

  ///书籍封面
  final String cover;

  ///最新章节
  final LatestChapterBean latestChapter;

  factory FavoriteBookBean.fromJson(String jsonString) {
    var json = Json(jsonDecode(jsonString));
    return FavoriteBookBean(
      id: json.getString('id'),
      name: json.getString('name'),
      author: json.getString('author'),
      cover: json.getString('cover'),
      latestChapter: LatestChapterBean.fromMap(
        json.get('latestChapter') as Map,
      ),
    );
  }

  FavoriteBookBean copy({
    LatestChapterBean? latestChapter,
  }) {
    return FavoriteBookBean(
      id: id,
      name: name,
      author: author,
      cover: cover,
      latestChapter: latestChapter ?? this.latestChapter,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'author': author,
        'cover': cover,
        'latestChapter': latestChapter.toMap(),
      };

  @override
  String toString() => jsonEncode(toMap());
}
