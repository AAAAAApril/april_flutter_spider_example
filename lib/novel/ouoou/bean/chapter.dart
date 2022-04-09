import 'dart:convert';

///章节信息
class ChapterBean {
  const ChapterBean({
    required this.id,
    required this.name,
  });

  const ChapterBean.empty()
      : id = '',
        name = '';

  ///章节 id
  final String id;

  ///章节名（包含章节序号的字符串）
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
    required this.paragraphs,
  }) : super(id: id, name: name);

  ///所有的段落
  final List<String> paragraphs;

  @override
  String toString() => jsonEncode(toMap()
    ..addAll({
      'paragraphs': paragraphs,
    }));
}
