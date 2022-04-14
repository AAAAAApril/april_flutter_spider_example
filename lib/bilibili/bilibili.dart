import 'package:april/utils/json.dart';
import 'package:april_spider/bilibili/bean/dynamic/dynamic.dart';
import 'package:april_spider/bilibili/pagination/bili_data_wrapper.dart';
import 'package:april_spider/configs.dart';
import 'package:april_spider/extensions.dart';
import 'package:april_spider/log.dart';
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
    required int pageNum,
    //刷新操作时不传此参数
    String? nextPageOffset,
    RequestConfiguration? configuration,
  }) {
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
  Log.print(tag: '关注的人的所有动态接口结果', value: () => result);
  //失败
  if (result == null) {
    return BiliPaginationDataWrapper<DynamicBean>.failed();
  }
  //成功
  try {
    var json = Json(result);
    if (!json.getBool('code', trueInt: 0)) {
      return BiliPaginationDataWrapper<DynamicBean>.failed();
    }
    return BiliPaginationDataWrapper.succeed(
      data: json.getList<DynamicBean>('items', decoder: DynamicBean.fromJson),
      paginationBean: BiliPaginationBean(
        hasMore: json.getBool('has_more'),
        nextPageOffset: json.getString('offset'),
      ),
    );
  } catch (_) {
    return BiliPaginationDataWrapper<DynamicBean>.failed();
  }
}
