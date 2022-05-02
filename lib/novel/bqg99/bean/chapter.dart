import 'dart:convert';

import 'package:april/utils/json.dart';

///章节
class ChapterBean {
  const ChapterBean({
    required this.id,
    required this.name,
  });

  ///章节 id
  final String id;

  ///章节名
  final String name;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() => jsonEncode(toMap());
}

///最新章节
class LatestChapterBean extends ChapterBean {
  const LatestChapterBean({
    required String id,
    required String name,
    required this.updateTime,
  }) : super(id: id, name: name);

  ///更新时间
  final DateTime updateTime;

  factory LatestChapterBean.fromMap(Map map) {
    var json = Json(map);
    return LatestChapterBean(
      id: json.getString('id'),
      name: json.getString('name'),
      updateTime: DateTime.parse(json.getString('updateTime')),
    );
  }

  @override
  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      'updateTime': updateTime.toString(),
    });
}

///章节详情
class ChapterDetailBean extends LatestChapterBean {
  const ChapterDetailBean({
    required String id,
    required String name,
    required DateTime updateTime,
    required this.wordsCount,
    required this.paragraphs,
  }) : super(id: id, name: name, updateTime: updateTime);

  ///字数
  final int wordsCount;

  ///章节内的所有段落
  final List<String> paragraphs;

  @override
  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      'wordsCount': wordsCount,
      'paragraphsLength': paragraphs.length,
    });
}
