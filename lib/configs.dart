///请求配置
class RequestConfiguration {
  const RequestConfiguration.empty() : this();

  const RequestConfiguration({
    this.cookie,
    this.userAgent,
    this.headers = const <String, String>{},
  });

  ///请求 Cookie
  final String? cookie;

  ///请求 User-Agent
  final String? userAgent;

  ///更多请求头
  final Map<String, String> headers;

  RequestConfiguration merge(RequestConfiguration? other) {
    return RequestConfiguration(
      cookie: other?.cookie ?? cookie,
      userAgent: other?.userAgent ?? userAgent,
      headers: Map<String, String>.of(headers)
        ..addAll(other?.headers ?? const <String, String>{}),
    );
  }

  Map<String, String> toHeaderMap() {
    var result = Map<String, String>.of(headers);
    if (cookie != null) {
      result['cookie'] = cookie!;
    }
    if (userAgent != null) {
      result['user-agent'] = userAgent!;
    }
    return result;
  }
}
