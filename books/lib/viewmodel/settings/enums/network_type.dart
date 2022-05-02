///允许的网络类型
enum NetworkType {
  //不允许使用网络
  none,
  //只允许使用 wifi
  wifi,
  //允许使用 wifi 以及 移动网络
  mobile,
}

extension NetworkTypeExt on NetworkType {
  String get allowedNetworkName {
    switch (this) {
      case NetworkType.none:
        return '不允许';
      case NetworkType.wifi:
        return '仅限 wifi';
      case NetworkType.mobile:
        return 'wifi 以及 流量';
    }
  }
}
