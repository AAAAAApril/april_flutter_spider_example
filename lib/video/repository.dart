///TODO 网络数据源
abstract class NetworkRepository {
  const NetworkRepository();
}

///TODO 缓存数据源
class CacheRepository extends NetworkRepository {
  const CacheRepository({
    required this.name,
  }) : super();

  ///缓存名
  final String name;
}
