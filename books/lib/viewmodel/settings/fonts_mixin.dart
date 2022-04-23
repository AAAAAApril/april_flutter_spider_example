import 'package:april/data/notifier_mixin.dart';
import 'package:april/data/selector_listenable.dart';
import 'package:books/viewmodel/settings/global_configs.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'font_family_name.dart';

///字体样式相关
mixin FontFamiliesMixin on ViewModel {
  ///全局配置
  late final ValueNotifier<GlobalConfigs> _globalConfigs =
      ValueNotifier<GlobalConfigs>(GlobalConfigs.def)..withMixin(this);

  ///全局字体样式
  late final ValueListenable<FontFamilyName> globalFontFamilies =
      SelectValueNotifier<GlobalConfigs, FontFamilyName>(
    valueListenable: _globalConfigs,
    selector: (value) => value.globalFontFamily,
  )..withMixin(this);

  ///阅读界面字体样式
  late final ValueListenable<FontFamilyName> readFontFamilies =
      SelectValueNotifier<GlobalConfigs, FontFamilyName>(
    valueListenable: _globalConfigs,
    selector: (value) => value.readFontFamily,
  )..withMixin(this);

  ///初始化
  void onInitFontFamiliesMixin() async {
    //从缓存中取出配置数据
    var sharedPreferences = await SharedPreferences.getInstance();
    _globalConfigs.value = GlobalConfigs.fromJson(
      sharedPreferences.getString(GlobalConfigs.cacheKey),
    );
  }

  ///修改全局字体样式
  void changeGlobalFontFamily(FontFamilyName name) {
    _globalConfigs.value = _globalConfigs.value.copy(
      globalFontFamily: name,
    );
    //更新缓存
    SharedPreferences.getInstance().then<void>((value) {
      value.setString(
        GlobalConfigs.cacheKey,
        _globalConfigs.value.toString(),
      );
    });
  }
}
