import 'package:spider/movie/repository.dart';

///TODO 电影数据源
class Movie<N extends NetworkRepository, C extends CacheRepository> {
  const Movie({
    required this.network,
    required this.cache,
  });

  ///网络源
  final N network;
  ///缓存源
  final C cache;
}
