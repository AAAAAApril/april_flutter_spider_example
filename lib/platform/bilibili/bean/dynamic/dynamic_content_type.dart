///动态内容类型
enum DynamicContentType {
  //图片动态
  MAJOR_TYPE_DRAW,
  //投稿视频
  MAJOR_TYPE_ARCHIVE,
  //投稿文章
  MAJOR_TYPE_ARTICLE,
  //无内容
  MAJOR_TYPE_NONE,
  //未知类型
  UNKNOWN,
}

extension DynamicContentTypeListExt on List<DynamicContentType> {
  DynamicContentType byNameWithoutException(String name) {
    try {
      return byName(name);
    } catch (_) {
      return DynamicContentType.UNKNOWN;
    }
  }
}
