import 'package:april/data/notifier_mixin.dart';
import 'package:books/viewmodel/settings/enums/network_type.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enums/font_family_name.dart';
import 'global_configs.dart';

///设置 ViewModel
class SettingsViewModel extends ViewModel {
  SettingsViewModel() {
    //从缓存中取出配置数据
    SharedPreferences.getInstance().then<void>((sharedPreferences) {
      _globalConfigs.value = GlobalConfigs.fromJson(
        sharedPreferences.getString(GlobalConfigs.cacheKey),
      );
    });
  }

  ///全局配置
  late final ValueNotifier<GlobalConfigs> _globalConfigs =
      ValueNotifier<GlobalConfigs>(GlobalConfigs.def)..withMixin(this);

  ValueListenable<GlobalConfigs> get globalConfigs => _globalConfigs;

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

  ///修改允许使用的网络类型
  void changeAllowedNetworkType(NetworkType newType) {
    _globalConfigs.value = _globalConfigs.value.copy(
      allowedNetworkType: newType,
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
