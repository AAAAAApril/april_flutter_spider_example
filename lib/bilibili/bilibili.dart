import 'package:april/utils/json.dart';
import 'package:april_spider/bilibili/bean/dynamic/dynamic.dart';
import 'package:april_spider/bilibili/bean/dynamic/dynamic_content.dart';
import 'package:april_spider/bilibili/bean/dynamic/dynamic_type.dart';
import 'package:april_spider/bilibili/pagination/bili_data_wrapper.dart';
import 'package:april_spider/configs.dart';
import 'package:april_spider/extensions.dart';
import 'package:april_spider/network.dart';
import 'package:flutter/foundation.dart';

///BiliBili 弹幕网
///
///网址：https://www.bilibili.com
class BiliBili {
  BiliBili._();

  static const RequestConfiguration webRequestConfiguration =
      RequestConfiguration(
    cookie:
        "pgv_pvi=660690944; rpdid=|(ku|k~|k)RY0J'ullYYklkJl; LIVE_BUVID=AUTO3516093122196154; buvid3=F74ABF88-B7A5-46EB-9EAF-EBD3834FAC6C184981infoc; fingerprint_s=a34cb6f3f386bf0e6839cdf7b2d1cabc; _uuid=A5101810105-CC9F-95AF-10FA6-94E1333A1091822574infoc; video_page_version=v_old_home; blackside_state=0; i-wanna-go-back=-1; CURRENT_QUALITY=80; fingerprint3=5b5d0fa7e4580315ee3fb6f4dbe7c1ca; buvid_fp=ae7fadfd51437b48cf0596ea310e6111; buvid4=B1C085CD-2FB8-709F-43CF-D820981D130E55412-022012119-LKyJvix6SQhgkbpkSc0nSQ%3D%3D; CURRENT_BLACKGAP=0; b_ut=5; fingerprint=192d62d4d55e2bed30fce7ef32731d16; SESSDATA=df4940a9%2C1661491351%2C78fb5%2A21; bili_jct=017511a58c8158d50bda8f50a6d5b4d5; DedeUserID=1027062576; DedeUserID__ckMd5=322263da64db62b6; sid=726n0r3i; CURRENT_FNVAL=4048; nostalgia_conf=-1; bp_t_offset_1027062576=647899162462912568; innersign=0; bp_video_offset_1027062576=648556400009543700; hit-dyn-v2=1; b_lsid=74B15246_18023338E78; PVID=7",
    userAgent:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36',
  );

  ///我关注的人的动态
  ///https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all?timezone_offset=-480&type=all&offset=648556400009543680&page=2
  static Future<BiliPaginationDataWrapper<DynamicBean>> followersDynamics({
    //页码
    int pageNum = 1,
    //刷新操作时不传此参数
    String? nextPageOffset,
    RequestConfiguration? configuration,
  }) {
    assert(pageNum > 0, '页码从 1 开始');
    return compute<_FollowersDynamicsConfig,
        BiliPaginationDataWrapper<DynamicBean>>(
      _followersDynamics,
      _FollowersDynamicsConfig(
        pageNum: pageNum,
        nextPageOffset: nextPageOffset,
        configuration: webRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('BiliBili我关注的人们的动态');
  }

  /// 获取文章中的所有图片
  static Future<List<DynamicPicture>> articlePictures(
    ///文章 CV 号
    String articleId, {
    RequestConfiguration? configuration,
  }) {
    return compute<_ArticlePicturesConfig, List<DynamicPicture>>(
      _articlePictures,
      _ArticlePicturesConfig(
        articleId: articleId,
        configuration: webRequestConfiguration.merge(configuration),
      ),
    );
  }
}

class _FollowersDynamicsConfig {
  const _FollowersDynamicsConfig({
    required this.pageNum,
    required this.nextPageOffset,
    required this.configuration,
  });

  final int pageNum;
  final String? nextPageOffset;
  final RequestConfiguration configuration;
}

Future<BiliPaginationDataWrapper<DynamicBean>> _followersDynamics(
  _FollowersDynamicsConfig config,
) async {
  var queryParameters = <String, String>{
    'page': config.pageNum.toString(),
    'timezone_offset': '-480',
    'type': 'all',
  };
  if (config.nextPageOffset != null && config.nextPageOffset!.isNotEmpty) {
    queryParameters['offset'] = config.nextPageOffset!;
  }
  Map<String, dynamic>? result = await Network.getJson(
    uri: Uri.https(
      'api.bilibili.com',
      'x/polymer/web-dynamic/v1/feed/all',
      queryParameters,
    ),
    configuration: config.configuration,
  );
  //失败
  if (result == null) {
    return BiliPaginationDataWrapper<DynamicBean>.failed();
  }
  //成功
  try {
    if (result['code'] != 0) {
      return BiliPaginationDataWrapper<DynamicBean>.failed();
    }
    var json = Json(result['data'] as Map);
    final List<DynamicBean> dynamics = json.getList<DynamicBean>(
      'items',
      decoder: DynamicBean.fromJson,
    );
    var articles = dynamics.map<DynamicArticle?>((element) {
      ///发布了文章
      if (element.type == DynamicType.DYNAMIC_TYPE_ARTICLE) {
        return element.content?.article;
      }

      ///转发了文章
      else if (element.type == DynamicType.DYNAMIC_TYPE_FORWARD &&
          element.original?.type == DynamicType.DYNAMIC_TYPE_ARTICLE) {
        return element.original?.content?.article;
      }
      return null;
    }).toList();
    articles.removeWhere((element) => element == null);

    ///添加获取文章图片的任务
    if (articles.isNotEmpty) {
      await Future.wait<void>(
        List<DynamicArticle>.from(articles).map<Future<void>>(
          (e) => compute<_ArticlePicturesConfig, List<DynamicPicture>>(
            _articlePictures,
            _ArticlePicturesConfig(
              articleId: e.cvId,
              configuration: config.configuration,
            ),
          ).then<void>((value) {
            e.pictures.addAll(value);
          }),
        ),
      );
    }
    return BiliPaginationDataWrapper<DynamicBean>.succeed(
      data: dynamics,
      paginationBean: BiliPaginationBean(
        hasMore: json.getBool('has_more'),
        nextPageOffset: json.getString('offset'),
      ),
    );
  } catch (_) {
    return BiliPaginationDataWrapper<DynamicBean>.failed();
  }
}

class _ArticlePicturesConfig {
  const _ArticlePicturesConfig({
    required this.articleId,
    required this.configuration,
  });

  ///文章 CV 号
  final String articleId;
  final RequestConfiguration configuration;
}

///https://www.bilibili.com/read/cv16134294?spm_id_from=444.41.list.card_article.click
Future<List<DynamicPicture>> _articlePictures(
  _ArticlePicturesConfig config,
) async {
  var document = await Network.getHtmlDocument(
    uri: Uri.https(
      'www.bilibili.com',
      'read/${config.articleId}',
      const <String, String>{
        'spm_id_from': '444.41.list.card_article.click',
      },
    ),
    configuration: config.configuration,
  );
  if (document == null) {
    return const <DynamicPicture>[];
  }
  var result = <DynamicPicture>[];

  ///顶部封面图
  var coverElement = document.querySelector(
    'meta[data-hid="og:image"][property="og:image"]',
  );
  if (coverElement != null) {
    String? cover = coverElement.attributes['content'];
    if (cover != null && cover.isNotEmpty) {
      result.add(DynamicPicture.unknown(cover));
    }
  }

  ///文章内容区域
  var contentElement = document.querySelector('div[id="article-content"]');
  if (contentElement != null) {
    result.addAll(
      contentElement
          .querySelectorAll('figure[class="img-box"] > img')
          .map<DynamicPicture>((e) {
        String? url = e.attributes['data-src'];
        //图片字节数
        double size = 0;
        int? bytes = int.tryParse(e.attributes['data-size'] ?? '');
        if (bytes != null) {
          size = bytes / 1024;
        }
        return DynamicPicture(
          url: url != null ? 'https:$url' : '',
          width: int.tryParse(e.attributes['width'] ?? '0') ?? 0,
          height: int.tryParse(e.attributes['height'] ?? '0') ?? 0,
          size: size,
        );
      }),
    );
  }
  return result;
}
