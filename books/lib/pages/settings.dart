import 'package:april/widgets/value_listenable_builder.dart';
import 'package:books/generated/l10n.dart';
import 'package:books/viewmodel/settings/font_family_name.dart';
import 'package:books/viewmodel/settings/settings_viewmodel.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';

///设置页
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingViewModel = ViewModel.of<SettingsViewModel>(context);
    return ListView(children: [
      ///全局字体样式
      Text(
        Strings.current.globalFontFamily,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      ...FontFamilyName.values.map<Widget>(
        (e) => SelectorListenableBuilder<FontFamilyName, bool>(
          valueListenable: settingViewModel.globalFontFamilies,
          selector: (value) => value == e,
          builder: (_, selected, __) => CheckboxListTile(
            value: selected,
            onChanged: (value) {
              if (value == true) {
                settingViewModel.changeGlobalFontFamily(e);
              }
            },
            title: Text(
              e.fontName,
              style: TextStyle(
                fontFamily: e.name,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
