import 'package:april_flutter_utils/april.dart';

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

  ReadBean copy({
    String? chapterId,
    int? paragraphIndex,
  }) {
    return ReadBean(
      chapterId: chapterId ?? this.chapterId,
      paragraphIndex: paragraphIndex ?? this.paragraphIndex,
    );
  }

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'paragraphIndex': paragraphIndex,
      };

  @override
  String toString() {
    return 'ReadBean{chapterId: $chapterId, paragraphIndex: $paragraphIndex}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadBean &&
          runtimeType == other.runtimeType &&
          chapterId == other.chapterId &&
          paragraphIndex == other.paragraphIndex;

  @override
  int get hashCode => chapterId.hashCode ^ paragraphIndex.hashCode;
}
