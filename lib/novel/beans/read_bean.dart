import 'package:april/utils/json.dart';

///阅读 缓存 实体
class ReadBean {
  const ReadBean({
    required this.chapterId,
    this.paragraphIndex = 0,
  });

  const ReadBean.start() : this(chapterId: '');

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

  ///是否是在最开始（即：还未阅读过）
  bool get atStart => chapterId.isEmpty && paragraphIndex <= 0;

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'paragraphIndex': paragraphIndex,
      };
}
