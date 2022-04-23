import 'dart:convert';

import 'package:april/utils/json.dart';
import 'package:books/viewmodel/settings/font_family_name.dart';

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
  );

  const GlobalConfigs._({
    required this.readFontSize,
    required this.globalFontFamily,
    required this.readFontFamily,
  });

  ///阅读页文字大小
  final int readFontSize;

  ///全局字体样式
  final FontFamilyName globalFontFamily;

  ///阅读页字体样式
  final FontFamilyName readFontFamily;

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
    );
  }

  GlobalConfigs copy({
    int? readFontSize,
    FontFamilyName? globalFontFamily,
    FontFamilyName? readFontFamily,
  }) {
    return GlobalConfigs._(
      readFontSize: readFontSize ?? this.readFontSize,
      globalFontFamily: globalFontFamily ?? this.globalFontFamily,
      readFontFamily: readFontFamily ?? this.readFontFamily,
    );
  }

  Map<String, dynamic> toJson() => {
        'readFontSize': readFontSize,
        'globalFontFamily': globalFontFamily.name,
        'readFontFamily': readFontFamily.name,
      };

  @override
  String toString() => jsonEncode(toJson());
}
