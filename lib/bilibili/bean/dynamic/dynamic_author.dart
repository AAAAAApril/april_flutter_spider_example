import 'package:april/utils/json.dart';

///动态作者
class DynamicAuthor {
  const DynamicAuthor({
    required this.authorId,
    required this.nickName,
    required this.avatar,
  });

  ///作者 id
  final int authorId;

  ///作者 昵称
  final String nickName;

  ///作者 头像
  final String avatar;

  factory DynamicAuthor.fromJson(Map map) {
    var json = Json(map);
    return DynamicAuthor(
      authorId: json.getInt('mid'),
      nickName: json.getString('name'),
      avatar: json.getString('face'),
    );
  }
}
