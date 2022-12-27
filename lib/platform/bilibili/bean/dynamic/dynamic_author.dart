import 'dart:convert';

import 'package:april_flutter_utils/april.dart';

///动态作者
class DynamicAuthor {
  const DynamicAuthor({
    required this.id,
    required this.nickName,
    required this.avatar,
  });

  ///作者 id
  final int id;

  ///作者 昵称
  final String nickName;

  ///作者 头像
  final String avatar;

  factory DynamicAuthor.fromJson(Map map) {
    var json = Json(map);
    return DynamicAuthor(
      id: json.getInt('mid'),
      nickName: json.getString('name'),
      avatar: json.getString('face'),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nickName': nickName,
        'avatar': avatar,
      };

  @override
  String toString() => jsonEncode(toMap());
}
