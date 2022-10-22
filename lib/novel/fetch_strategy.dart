///获取数据的策略
enum FetchStrategy {
  ///优先从网络中获取。当网络拿不到数据时，再查找缓存。
  networkFirst,

  ///优先从缓存中获取。当缓存中没有时，再从网络获取。
  cacheFirst,

  ///仅从缓存中获取。
  cacheOnly,

  ///在 wifi 环境下，等于 [networkFirst]
  ///其他时候，等于 [cacheFirst]
  networkFirstOnlyWifi,
}
