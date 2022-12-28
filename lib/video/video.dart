import 'package:spider/video/repository.dart';

///TODO 视频数据源
class Video<N extends NetworkRepository, C extends CacheRepository> {
  const Video({
    required this.network,
    required this.cache,
  });

  ///网络源
  final N network;
  ///缓存源
  final C cache;
}
