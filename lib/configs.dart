import 'dart:io';

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

  void withRequest(HttpClientRequest request) {
    if (cookie != null) {
      request.headers.set('cookie', cookie!);
    }
    if (userAgent != null) {
      request.headers.set('user-agent', userAgent!);
    }
  }
}
