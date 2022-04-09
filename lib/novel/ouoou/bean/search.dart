import 'dart:convert';

///搜索结果
class SearchResultBean {
  const SearchResultBean({
    required this.novelId,
    required this.novelName,
    required this.novelAuthor,
  });

  ///小说 id
  final String novelId;

  ///小说名字
  final String novelName;

  ///小说作者
  final String novelAuthor;

  Map<String, dynamic> toMap() => {
        'novelId': novelId,
        'novelName': novelName,
        'novelAuthor': novelAuthor,
      };

  @override
  String toString() => jsonEncode(toMap());
}
