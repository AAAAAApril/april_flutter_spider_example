import 'dart:convert';

///小说（列表）分类
class ClassifyBean {
  const ClassifyBean({
    required this.id,
    required this.name,
    required this.path,
  });

  ///分类 id
  final String id;

  ///分类名
  final String name;

  ///分类对应的网址路径
  final String path;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'path': path,
      };

  @override
  String toString() => jsonEncode(toJson());
}
