import 'dart:convert';

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

///章节详情
class ChapterDetailBean extends ChapterBean {
  const ChapterDetailBean({
    required String id,
    required String name,
    required this.wordsCount,
    required this.updateTime,
    required this.paragraphs,
  }) : super(id: id, name: name);

  ///字数
  final int wordsCount;

  ///更新时间
  final DateTime updateTime;

  ///章节内的所有段落
  final List<String> paragraphs;

  @override
  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      'wordsCount': wordsCount,
      'updateTime': updateTime.toString(),
      'paragraphsLength': paragraphs.length,
    });

  @override
  String toString() => jsonEncode(toMap());
}
