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
}

///章节详情
class ChapterDetailBean extends ChapterBean {
  const ChapterDetailBean({
    required String id,
    required String name,
    required this.paragraphs,
  }) : super(id: id, name: name);

  ///章节内的所有段落
  final List<String> paragraphs;
}
