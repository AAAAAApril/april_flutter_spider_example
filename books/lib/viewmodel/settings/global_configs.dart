import 'dart:convert';

import 'package:april/utils/json.dart';
import 'package:flutter/material.dart';

import 'enums/font_family_name.dart';
import 'enums/network_type.dart';

///全局配置
class GlobalConfigs {
  ///缓存 key
  static const String cacheKey = 'app_global_configs';

  ///阅读界面文字大小范围
  static const List<int> readFontSizeRange = <int>[16, 30];

  ///全局配置默认值
  static const GlobalConfigs def = GlobalConfigs._(
    readFontSize: 20,
    globalFontFamily: FontFamilyName.none,
    readFontFamily: FontFamilyName.none,
    themeMode: ThemeMode.system,
    allowedNetworkType: NetworkType.wifi,
  );

  const GlobalConfigs._({
    required this.readFontSize,
    required this.globalFontFamily,
    required this.readFontFamily,
    required this.themeMode,
    required this.allowedNetworkType,
  });

  ///阅读页文字大小
  final int readFontSize;

  ///全局字体样式
  final FontFamilyName globalFontFamily;

  ///阅读页字体样式
  final FontFamilyName readFontFamily;

  ///界面主题样式
  final ThemeMode themeMode;

  ///允许使用的网络类型
  final NetworkType allowedNetworkType;

  factory GlobalConfigs.fromJson(String? jsonString) {
    if (jsonString == null) {
      return def;
    }
    dynamic map;
    try {
      map = jsonDecode(jsonString);
    } catch (_) {
      map = null;
    }
    var json = Json(map);
    return GlobalConfigs._(
      readFontSize: json.getInt('readFontSize', def.readFontSize),
      globalFontFamily: FontFamilyName.values.byName(
        json.getString(
          'globalFontFamily',
          def.globalFontFamily.name,
        ),
      ),
      readFontFamily: FontFamilyName.values.byName(
        json.getString(
          'readFontFamily',
          def.readFontFamily.name,
        ),
      ),
      themeMode: ThemeMode.values.byName(
        json.getString(
          'themeMode',
          def.themeMode.name,
        ),
      ),
      allowedNetworkType: NetworkType.values.byName(
        json.getString(
          'allowedNetworkType',
          def.allowedNetworkType.name,
        ),
      ),
    );
  }

  GlobalConfigs copy({
    int? readFontSize,
    FontFamilyName? globalFontFamily,
    FontFamilyName? readFontFamily,
    ThemeMode? themeMode,
    NetworkType? allowedNetworkType,
  }) {
    return GlobalConfigs._(
      readFontSize: readFontSize ?? this.readFontSize,
      globalFontFamily: globalFontFamily ?? this.globalFontFamily,
      readFontFamily: readFontFamily ?? this.readFontFamily,
      themeMode: themeMode ?? this.themeMode,
      allowedNetworkType: allowedNetworkType ?? this.allowedNetworkType,
    );
  }

  Map<String, dynamic> toJson() => {
        'readFontSize': readFontSize,
        'globalFontFamily': globalFontFamily.name,
        'readFontFamily': readFontFamily.name,
        'themeMode': themeMode.name,
        'allowedNetworkType': allowedNetworkType.name,
      };

  @override
  String toString() => jsonEncode(toJson());
}
