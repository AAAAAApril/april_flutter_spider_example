import 'package:april_spider/novel/bqg99/bean/chapter.dart';

///搜索结果
class SearchResultBean {
  const SearchResultBean({
    required this.id,
    required this.name,
    required this.cover,
    required this.author,
    required this.category,
    required this.latestUpdateChapter,
  });

  ///小说 id
  final String id;

  ///小说名字
  final String name;

  ///小说封面
  final String cover;

  ///小说作者
  final String author;

  ///小说分类（比如：玄幻、都市）
  final String category;

  ///最后更新的章节
  final ChapterBean latestUpdateChapter;
}
