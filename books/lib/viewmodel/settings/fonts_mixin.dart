import 'package:april/data/notifier_mixin.dart';
import 'package:books/viewmodel/settings/global_configs.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'font_family_name.dart';

///字体样式相关
mixin FontFamiliesMixin on ViewModel {
  ///全局配置
  late final ValueNotifier<GlobalConfigs> _globalConfigs =
      ValueNotifier<GlobalConfigs>(GlobalConfigs.def)..withMixin(this);

  ValueListenable<GlobalConfigs> get globalConfigs => _globalConfigs;

  ///初始化
  void onInitFontFamiliesMixin() async {
    //从缓存中取出配置数据
    var sharedPreferences = await SharedPreferences.getInstance();
    _globalConfigs.value = GlobalConfigs.fromJson(
      sharedPreferences.getString(GlobalConfigs.cacheKey),
    );
  }

  ///修改全局主题模式
  void changeGlobalThemeMode(ThemeMode mode) {
    _globalConfigs.value = _globalConfigs.value.copy(
      themeMode: mode,
    );
    _notifyCache();
  }

  ///修改全局字体样式
  void changeGlobalFontFamily(FontFamilyName name) {
    _globalConfigs.value = _globalConfigs.value.copy(
      globalFontFamily: name,
    );
    _notifyCache();
  }

  ///更新缓存
  void _notifyCache() {
    SharedPreferences.getInstance().then<void>((value) {
      value.setString(
        GlobalConfigs.cacheKey,
        _globalConfigs.value.toString(),
      );
    });
  }
}
