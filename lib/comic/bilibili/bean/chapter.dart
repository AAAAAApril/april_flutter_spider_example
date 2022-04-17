import 'dart:convert';

import 'package:april/utils/json.dart';

///漫画章节
class ComicChapter {
  const ComicChapter({
    required this.id,
    required this.shortTitle,
    required this.title,
    required this.cover,
    required this.publishTime,
    required this.needPay,
  });

  ///章节 id
  final int id;

  ///短标题
  final String shortTitle;

  ///长标题
  final String title;

  ///封面
  final String cover;

  ///发布时间
  final DateTime publishTime;

  ///是否是付费章节
  final bool needPay;

  factory ComicChapter.fromJson(Map map) {
    var json = Json(map);
    return ComicChapter(
      id: json.getInt('id'),
      shortTitle: json.getString('short_title'),
      title: json.getString('title'),
      cover: json.getString('cover'),
      publishTime: DateTime.tryParse(json.getString('pub_time')) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      needPay:
          json.getBool('pay_mode', trueInt: 1) || json.getInt('pay_gold') > 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shortTitle': shortTitle,
        'title': title,
        'cover': cover,
        'publishTime': publishTime.toString(),
        'needPay': needPay,
      };

  @override
  String toString() => jsonEncode(toMap());
}
