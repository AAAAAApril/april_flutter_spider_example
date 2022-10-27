import 'package:april/utils/json.dart';

///阅读 缓存 实体
class ReadBean {
  const ReadBean({
    required this.chapterId,
    required this.paragraphIndex,
  });

  factory ReadBean.fromJson(Map<String, dynamic> map) {
    final json = Json(map);
    return ReadBean(
      chapterId: json.getString('chapterId'),
      paragraphIndex: json.getInt('paragraphIndex'),
    );
  }

  ///当前阅读到的章节
  final String chapterId;

  ///当前阅读到的段落下标
  final int paragraphIndex;

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'paragraphIndex': paragraphIndex,
      };
}
