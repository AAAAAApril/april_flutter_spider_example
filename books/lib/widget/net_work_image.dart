import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

///网络图片组件
class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget(
    this.url, {
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  ///图片地址
  final String url;

  ///宽高
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: _cacheManager,
      width: width,
      height: height,
    );
  }
}

final BaseCacheManager _cacheManager = CacheManager(Config(
  'books_app_custom_cache_manager_config_key',
  maxNrOfCacheObjects: 100,
  stalePeriod: const Duration(days: 30),
));
