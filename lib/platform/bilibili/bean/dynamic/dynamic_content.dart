import 'dart:convert';

import 'package:april_flutter_utils/april.dart';

import 'dynamic_content_type.dart';

///动态内容
class DynamicContent {
  const DynamicContent({
    required this.type,
    required this.pictures,
    required this.article,
    required this.video,
  });

  ///动态内容类型
  final DynamicContentType type;

  ///图片动态的图片列表
  final List<DynamicPicture> pictures;

  ///投稿的文章
  final DynamicArticle? article;

  ///投稿的视频
  final DynamicVideo? video;

  factory DynamicContent.fromJson(Map map) {
    var json = Json(map);
    DynamicContentType type = DynamicContentType.values.byNameWithoutException(
      json.getString('type'),
    );
    var pictures = <DynamicPicture>[];
    DynamicVideo? video;
    DynamicArticle? article;
    switch (type) {
      case DynamicContentType.MAJOR_TYPE_DRAW:
        pictures.addAll(
          ((json.get('draw') as Map)['items'] as List).map<DynamicPicture>(
            (e) => DynamicPicture.fromJson(e as Map),
          ),
        );
        break;
      case DynamicContentType.MAJOR_TYPE_ARCHIVE:
        video = DynamicVideo.fromJson(json.get('archive') as Map);
        break;
      case DynamicContentType.MAJOR_TYPE_ARTICLE:
        article = DynamicArticle.fromJson(json.get('article') as Map);
        break;
      case DynamicContentType.MAJOR_TYPE_NONE:
      case DynamicContentType.UNKNOWN:
        break;
    }
    return DynamicContent(
      type: type,
      pictures: pictures,
      article: article,
      video: video,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'pictures': pictures.map((e) => e.toMap()).toList(),
        'article': article?.toMap(),
        'video': video?.toMap(),
      };

  @override
  String toString() => jsonEncode(toMap());
}

///图片
class DynamicPicture {
  const DynamicPicture({
    required this.url,
    required this.width,
    required this.height,
    required this.size,
  });

  ///不知道图片信息的情况
  const DynamicPicture.unknown(this.url)
      : width = 0,
        height = 0,
        size = 0;

  ///图片地址
  final String url;

  ///图片宽度（像素）
  final int width;

  ///图片高度（像素）
  final int height;

  ///图片大小（kb）
  final double size;

  ///图片大小（mb）
  double get sizeMB => size / 1024;

  factory DynamicPicture.fromJson(Map map) {
    var json = Json(map);
    return DynamicPicture(
      url: json.getString('src'),
      width: json.getInt('width'),
      height: json.getInt('height'),
      size: json.getDouble('size'),
    );
  }

  Map<String, dynamic> toMap() => {
        'url': url,
        'width': width,
        'height': height,
        'size': size,
        'sizeText': '$sizeMB MB',
      };

  @override
  String toString() => jsonEncode(toMap());
}

///文章
class DynamicArticle {
  DynamicArticle({
    required this.id,
    required this.covers,
    required this.title,
    required this.description,
  }) : pictures = <DynamicPicture>[];

  ///文章 id
  final int id;

  ///文章的封面
  final List<String> covers;

  ///文章出现的所有图片
  final List<DynamicPicture> pictures;

  ///文章标题
  final String title;

  ///文章描述
  final String description;

  ///文章 CV号
  String get cvId => 'cv$id';

  factory DynamicArticle.fromJson(Map map) {
    var json = Json(map);
    return DynamicArticle(
      id: json.getInt('id'),
      covers: json.getStringList('covers'),
      title: json.getString('title'),
      description: json.getString('desc'),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'cvId': cvId,
        'covers': covers,
        'pictures': pictures.map((e) => e.toMap()).toList(),
        'title': title,
        'description': description,
      };

  @override
  String toString() => jsonEncode(toMap());
}

///视频
class DynamicVideo {
  const DynamicVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.duration,
  });

  ///视频 id （BV号）
  final String id;

  ///视频标题
  final String title;

  ///视频描述
  final String description;

  ///视频封面
  final String cover;

  ///视频时长
  final Duration duration;

  factory DynamicVideo.fromJson(Map map) {
    var json = Json(map);
    //时长文字
    Duration duration = Duration.zero;
    try {
      List<String> durationTextList =
          json.getString('duration_text', defaultValue: '0').split(':');
      //只有秒钟
      if (durationTextList.length == 1) {
        duration = Duration(
          seconds: int.tryParse(durationTextList.first) ?? 0,
        );
      }
      //有分钟
      else if (durationTextList.length == 2) {
        duration = Duration(
          minutes: int.tryParse(durationTextList.first) ?? 0,
          seconds: int.tryParse(durationTextList.last) ?? 0,
        );
      }
      //有小时
      else if (durationTextList.length == 3) {
        duration = Duration(
          hours: int.tryParse(durationTextList.first) ?? 0,
          minutes: int.tryParse(durationTextList[1]) ?? 0,
          seconds: int.tryParse(durationTextList.last) ?? 0,
        );
      }
    } catch (_) {
      //ignore
    }
    return DynamicVideo(
      id: json.getString('bvid'),
      title: json.getString('title'),
      description: json.getString('desc'),
      cover: json.getString('cover'),
      duration: duration,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'cover': cover,
        'duration': duration.toString(),
      };

  @override
  String toString() => jsonEncode(toMap());
}
