///动态内容类型
enum DynamicContentType {
  //图片动态
  MAJOR_TYPE_DRAW,
  //投稿
  MAJOR_TYPE_ARCHIVE,
  //未知类型
  UNKNOWN,
}

extension DynamicContentTypeListExt on List<DynamicContentType> {
  DynamicContentType byName(String name) {
    try {
      return DynamicContentType.values.firstWhere(
        (element) => element.name == name,
      );
    } catch (_) {
      return DynamicContentType.UNKNOWN;
    }
  }
}
