import 'package:books/viewmodel/settings/fonts_mixin.dart';
import 'package:books/viewmodel/viewmodel.dart';

///设置 ViewModel
class SettingsViewModel extends ViewModel with FontFamiliesMixin {
  SettingsViewModel() {
    onInitFontFamiliesMixin();
  }
}
