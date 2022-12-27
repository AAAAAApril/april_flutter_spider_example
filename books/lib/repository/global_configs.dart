import 'package:april_flutter_utils/april.dart';
import 'package:flutter/material.dart';

import 'enums/font_family_name.dart';

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
  );

  const GlobalConfigs._({
    required this.readFontSize,
    required this.globalFontFamily,
    required this.readFontFamily,
    required this.themeMode,
  });

  ///阅读页文字大小
  final int readFontSize;

  ///全局字体样式
  final FontFamilyName globalFontFamily;

  ///阅读页字体样式
  final FontFamilyName readFontFamily;

  ///界面主题样式
  final ThemeMode themeMode;

  factory GlobalConfigs.fromJson(Map<String, dynamic> map) {
    var json = Json(map);
    return GlobalConfigs._(
      readFontSize: json.getInt(
        'readFontSize',
        defaultValue: def.readFontSize,
      ),
      globalFontFamily: FontFamilyName.values.byValue(
        json.getString(
          'globalFontFamily',
          defaultValue: def.globalFontFamily.value,
        ),
      ),
      readFontFamily: FontFamilyName.values.byValue(
        json.getString(
          'readFontFamily',
          defaultValue: def.readFontFamily.value,
        ),
      ),
      themeMode: ThemeMode.values.byName(
        json.getString(
          'themeMode',
          defaultValue: def.themeMode.name,
        ),
      ),
    );
  }

  GlobalConfigs copy({
    int? readFontSize,
    FontFamilyName? globalFontFamily,
    FontFamilyName? readFontFamily,
    ThemeMode? themeMode,
  }) {
    return GlobalConfigs._(
      readFontSize: readFontSize ?? this.readFontSize,
      globalFontFamily: globalFontFamily ?? this.globalFontFamily,
      readFontFamily: readFontFamily ?? this.readFontFamily,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() => {
        'readFontSize': readFontSize,
        'globalFontFamily': globalFontFamily.value,
        'readFontFamily': readFontFamily.value,
        'themeMode': themeMode.name,
      };

  @override
  String toString() {
    return 'GlobalConfigs{readFontSize: $readFontSize, globalFontFamily: $globalFontFamily, readFontFamily: $readFontFamily, themeMode: $themeMode}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalConfigs &&
          runtimeType == other.runtimeType &&
          readFontSize == other.readFontSize &&
          globalFontFamily == other.globalFontFamily &&
          readFontFamily == other.readFontFamily &&
          themeMode == other.themeMode;

  @override
  int get hashCode =>
      readFontSize.hashCode ^
      globalFontFamily.hashCode ^
      readFontFamily.hashCode ^
      themeMode.hashCode;
}
