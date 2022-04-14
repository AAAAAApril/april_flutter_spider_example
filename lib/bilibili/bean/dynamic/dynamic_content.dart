import 'package:april/utils/json.dart';

import 'dynamic_content_type.dart';

///动态内容
class DynamicContent {
  const DynamicContent({
    required this.type,
    required this.pictures,
    required this.video,
  });

  ///动态内容类型
  final DynamicContentType type;

  ///图片动态的图片列表
  final List<DynamicPicture> pictures;

  ///投稿的视频
  final DynamicVideo? video;

  factory DynamicContent.fromJson(Map map) {
    var json = Json(map);
    DynamicContentType type = DynamicContentType.values.byName(
      json.getString('type'),
    );
    var pictures = <DynamicPicture>[];
    DynamicVideo? video;
    switch (type) {
      case DynamicContentType.MAJOR_TYPE_DRAW:
        pictures.addAll(
          ((json.get('draw') as Map)['items'] as List).map<DynamicPicture>(
            (e) => DynamicPicture.fromJson(e as Map),
          ),
        );
        break;
      case DynamicContentType.MAJOR_TYPE_ARCHIVE:
        //todo
        break;
      case DynamicContentType.UNKNOWN:
        break;
    }
    return DynamicContent(
      type: type,
      pictures: pictures,
      video: video,
    );
  }
}

///动态图片
class DynamicPicture {
  const DynamicPicture({
    required this.url,
    required this.width,
    required this.height,
    required this.size,
  });

  ///图片地址
  final String url;

  ///图片宽度（像素）
  final int width;

  ///图片高度（像素）
  final int height;

  ///图片大小（kb）
  final double size;

  factory DynamicPicture.fromJson(Map map) {
    var json = Json(map);
    return DynamicPicture(
      url: json.getString('src'),
      width: json.getInt('width'),
      height: json.getInt('height'),
      size: json.getDouble('size'),
    );
  }
}

///动态视频
class DynamicVideo {}
