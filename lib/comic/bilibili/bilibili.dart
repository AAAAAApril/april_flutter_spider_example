import 'package:april/utils/json.dart';
import 'package:flutter/foundation.dart';
import 'package:spider/comic/bilibili/bean/comic.dart';
import 'package:spider/configs.dart';
import 'package:spider/extensions.dart';
import 'package:spider/network.dart';

///BiliBiLi 漫画
///https://manga.bilibili.com/
class BiliManGa {
  BiliManGa._();

  static const RequestConfiguration webRequestConfiguration =
      RequestConfiguration(
    cookie:
        '_uuid=77359291-52310-AB9D-FBB8-76245CAA894F72838infoc; buvid3=331CEDC4-5C2A-41B0-BBCF-FB0207FAA7DD167636infoc; blackside_state=1; rpdid=0zbfAHYOcb|gzaIPyyP|4y0|3w1MMgN8; video_page_version=v_old_home; i-wanna-go-back=-1; LIVE_BUVID=AUTO5016404384827684; buvid4=8256C1B3-1544-F6C6-994B-A8C09C4EBFAD65031-022020723-LKyJvix6SQg+BFQ+/RRzXA%3D%3D; fingerprint=3b9724a607f2d626914ca54914bb1e17; buvid_fp_plain=undefined; sid=6kfs4ri6; b_ut=5; CURRENT_BLACKGAP=0; buvid_fp=ccb3507074a4592afd93f4931d39c1ea; nostalgia_conf=-1; Hm_lvt_6ab26a3edfb92b96f655b43a89b9ca70=1647700285; Hm_lvt_a69e400ba5d439df060bf330cd092c0d=1647700285; CURRENT_QUALITY=0; bp_t_offset_12783377=647900592693313570; hit-dyn-v2=1; bp_video_offset_12783377=649755597811482600; PVID=2; b_lsid=198C5FCB_180372BFDC8; innersign=1; CURRENT_FNVAL=4048; bsource=search_baidu; Hm_lpvt_6ab26a3edfb92b96f655b43a89b9ca70=1650197582; Hm_lpvt_a69e400ba5d439df060bf330cd092c0d=1650197582',
    userAgent:
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36',
  );

  ///搜索漫画
  ///POST
  /// https://manga.bilibili.com/twirp/comic.v1.Comic/Search?device=pc&platform=web
  /// {"key_word":"修炼成仙","page_num":1,"page_size":9}
  static Future<List<ComicBean>> searchComic(
    String keywords, {
    RequestConfiguration? configuration,
  }) async {
    var result = await Network.postJson(
      uri: Uri.https(
        'manga.bilibili.com',
        'twirp/comic.v1.Comic/Search',
        const <String, String>{
          'device': 'pc',
          'platform': 'web',
        },
      ),
      configuration: webRequestConfiguration.merge(configuration),
      body: <String, String>{
        "key_word": keywords,
        "page_num": '1',
        "page_size": '9',
      },
    );
    if (result == null || result['code'] != 0) {
      return <ComicBean>[];
    }
    var json = Json(result['data']);
    return json.getList<ComicBean>('list', decoder: ComicBean.fromJson);
  }

  ///漫画详情
  ///POST
  /// https://manga.bilibili.com/twirp/comic.v1.Comic/ComicDetail?device=pc&platform=web
  /// {"comic_id":28427}
  static Future<ComicDetailBean?> comicDetail(
    int comicId, {
    RequestConfiguration? configuration,
  }) {
    return compute<_ComicDetailRequestConfig, ComicDetailBean?>(
      _comicDetail,
      _ComicDetailRequestConfig(
        comicId: comicId,
        configuration: webRequestConfiguration.merge(configuration),
      ),
    ).printRequestTime('BiliBili漫画搜索漫画详情');
  }
}

class _ComicDetailRequestConfig {
  const _ComicDetailRequestConfig({
    required this.comicId,
    required this.configuration,
  });

  final int comicId;
  final RequestConfiguration configuration;
}

Future<ComicDetailBean?> _comicDetail(_ComicDetailRequestConfig config) async {
  var result = await Network.postJson(
    uri: Uri.https(
      'manga.bilibili.com',
      'twirp/comic.v1.Comic/ComicDetail',
      const <String, String>{
        'device': 'pc',
        'platform': 'web',
      },
    ),
    configuration: config.configuration,
    body: <String, String>{
      "comic_id": config.comicId.toString(),
    },
  );
  if (result == null || result['code'] != 0) {
    return null;
  }
  return ComicDetailBean.fromJson(result['data'] as Map);
}
