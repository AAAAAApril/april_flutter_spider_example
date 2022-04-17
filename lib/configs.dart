///请求配置
class RequestConfiguration {
  const RequestConfiguration({
    this.cookie,
    this.userAgent,
  });

  ///请求 Cookie
  final String? cookie;

  ///请求 User-Agent
  final String? userAgent;

  RequestConfiguration merge(RequestConfiguration? other) {
    return RequestConfiguration(
      cookie: other?.cookie ?? cookie,
      userAgent: other?.userAgent ?? userAgent,
    );
  }

  Map<String, String> toHeaderMap() {
    var result = <String, String>{};
    if (cookie != null) {
      result['cookie'] = cookie!;
    }
    if (userAgent != null) {
      result['user-agent'] = userAgent!;
    }
    return result;
  }
}
