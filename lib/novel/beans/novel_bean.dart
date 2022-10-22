import 'chapter_bean.dart';

///小说实体（简略）
class NovelPreviewBean {
  const NovelPreviewBean({
    required this.novelId,
    required this.novelName,
    required this.authorName,
    required this.cover,
    required this.categoryName,
    required this.lastChapter,
  });

  ///小说 id
  final String novelId;

  ///小说名
  final String novelName;

  ///作者名
  final String authorName;

  ///小说封面
  final String cover;

  ///分类名
  final String categoryName;

  ///最新章节
  final ChapterPreviewBean lastChapter;
}

///小说实体（详细）
class NovelBean extends NovelPreviewBean {
  const NovelBean({
    required super.novelId,
    required super.novelName,
    required super.authorName,
    required super.cover,
    required super.categoryName,
    required super.lastChapter,
    required this.introduction,
    required this.chapters,
  });

  ///小说简介
  final String introduction;

  ///当前小说所有的章节
  final List<ChapterPreviewBean> chapters;
}
