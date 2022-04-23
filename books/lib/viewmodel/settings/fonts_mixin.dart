import 'package:april/data/notifier_mixin.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/foundation.dart';

///字体样式相关
mixin FontFamiliesMixin on ViewModel {
  ///全局字体样式
  late final ValueNotifier<FontFamilyName> _globalFontFamilies =
      ValueNotifier<FontFamilyName>(FontFamilyName.none)..withMixin(this);

  ValueListenable<FontFamilyName> get globalFontFamilies => _globalFontFamilies;

  ///初始化
  void onInitFontFamiliesMixin() {
    //TODO
  }

  ///修改全局字体样式
  void changeGlobalFontFamily(FontFamilyName name) {
    _globalFontFamilies.value = name;
  }
}

///字体样式名
class FontFamilyName {
  ///无字体（使用默认字体）
  static const FontFamilyName none = FontFamilyName._(null);

  const FontFamilyName._(this.value);

  final String? value;

  @override
  String toString() {
    return 'FontFamilyName{value: $value}';
  }
}
