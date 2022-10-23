///章节实体（简略）
class ChapterPreviewBean {
  const ChapterPreviewBean({
    required this.chapterId,
    required this.chapterName,
  });

  ///章节 ID
  final String chapterId;

  ///章节名
  final String chapterName;

  @override
  String toString() {
    return 'ChapterPreviewBean{chapterId: $chapterId, chapterName: $chapterName}';
  }
}

///章节实体（详细）
class ChapterBean extends ChapterPreviewBean {
  const ChapterBean({
    required super.chapterId,
    required super.chapterName,
    required this.paragraphs,
  });

  ///当前章节的所有段落
  final List<String> paragraphs;
}
