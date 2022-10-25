import 'package:april/utils/json.dart';

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

  @override
  String toString() {
    return 'NovelPreviewBean{novelId: $novelId, novelName: $novelName, authorName: $authorName, cover: $cover, categoryName: $categoryName, lastChapter: $lastChapter}';
  }
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
    required this.updateTime,
    required this.chapters,
  });

  factory NovelBean.fromJson(Map<String, dynamic> map) {
    final json = Json(map);
    return NovelBean(
      novelId: json.getString('novelId'),
      novelName: json.getString('novelName'),
      authorName: json.getString('authorName'),
      cover: json.getString('cover'),
      categoryName: json.getString('categoryName'),
      lastChapter: ChapterPreviewBean.fromJson(
        Map<String, dynamic>.from(
          (json.get('lastChapter') as Map?) ?? <String, dynamic>{},
        ),
      ),
      introduction: json.getStringList('introduction'),
      updateTime: DateTime.fromMillisecondsSinceEpoch(
        json.getInt('updateTime'),
      ),
      chapters: json.getList<ChapterPreviewBean>(
        'chapters',
        decoder: (map) => ChapterPreviewBean.fromJson(
          Map<String, dynamic>.from(map),
        ),
      ),
    );
  }

  ///小说简介
  final List<String> introduction;

  ///最后更新时间
  final DateTime updateTime;

  ///当前小说所有的章节
  final List<ChapterPreviewBean> chapters;

  Map<String, dynamic> toJson() => {
        'novelId': novelId,
        'novelName': novelName,
        'authorName': authorName,
        'cover': cover,
        'categoryName': categoryName,
        'lastChapter': lastChapter.toJson(),
        'introduction': introduction,
        'updateTime': updateTime.millisecondsSinceEpoch,
        'chapters': chapters
            .map<Map<String, dynamic>>(
              (e) => e.toJson(),
            )
            .toList(),
      };
}
