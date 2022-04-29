///动态类型
enum DynamicType {
  //图片
  DYNAMIC_TYPE_DRAW,
  //文章
  DYNAMIC_TYPE_ARTICLE,
  //视频
  DYNAMIC_TYPE_AV,
  //转发
  DYNAMIC_TYPE_FORWARD,
  //纯文本
  DYNAMIC_TYPE_WORD,
  //动态无数据
  DYNAMIC_TYPE_NONE,
  //未知类型
  UNKNOWN,
}

extension DynamicTypeListExt on List<DynamicType> {
  DynamicType byNameWithoutException(String name) {
    try {
      return byName(name);
    } catch (_) {
      return DynamicType.UNKNOWN;
    }
  }
}
