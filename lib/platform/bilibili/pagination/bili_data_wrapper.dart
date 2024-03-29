import 'dart:convert';

import 'package:april_flutter_utils/april.dart';

///分页数据包装器
class BiliPaginationDataWrapper<T> extends AbsPaginationDataWrapper<T> {
  BiliPaginationDataWrapper.succeed({
    required this.data,
    required this.paginationBean,
  });

  BiliPaginationDataWrapper.failed()
      : data = <T>[],
        paginationBean = null;

  @override
  final List<T> data;

  ///分页信息
  ///null 表示请求失败
  final BiliPaginationBean? paginationBean;

  @override
  bool get hasMore => paginationBean?.hasMore ?? false;

  @override
  bool get succeed => paginationBean != null;

  Map<String, dynamic> toMap() => {
        'paginationBean': paginationBean?.toMap(),
        'dataLength': data.length,
      };

  @override
  String toString() => jsonEncode(toMap());
}

///分页数据
class BiliPaginationBean {
  const BiliPaginationBean({
    required this.hasMore,
    required this.nextPageOffset,
  });

  ///是否还有更多数据
  final bool hasMore;

  ///下一页偏移（加载更多时需要传入）
  final String nextPageOffset;

  Map<String, dynamic> toMap() => {
        'hasMore': hasMore,
        'nextPageOffset': nextPageOffset,
      };

  @override
  String toString() => jsonEncode(toMap());
}
