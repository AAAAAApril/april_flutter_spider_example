import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:april/widgets/value_listenable_builder.dart';

import 'package:books/generated/l10n.dart';
import 'package:books/repository/books_repository.dart';
import 'package:books/repository/global_configs.dart';
import 'package:books/repository/enums/font_family_name.dart';
import 'package:books/repository/enums/theme_mode.dart';

///设置页
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookCacheRepository cacheRepository =
        BooksRepository.instance.repository.cache;
    return ListView(children: [
      ///全局主题颜色
      _SwitchableConfigs<GlobalConfigs, ThemeMode>(
        title: Strings.current.globalThemeMode,
        listenable: cacheRepository.globalConfigs,
        configs: ThemeMode.values,
        selector: (configs, mode) => configs.themeMode == mode,
        itemBuilder: (_, mode) => Text(mode.modeName),
        onSelect: (mode) {
          cacheRepository.changeGlobalThemeMode(mode);
        },
      ),

      ///全局字体样式
      _SwitchableConfigs<GlobalConfigs, FontFamilyName>(
        title: Strings.current.globalFontFamily,
        listenable: cacheRepository.globalConfigs,
        configs: FontFamilyName.values,
        selector: (configs, name) => configs.globalFontFamily == name,
        itemBuilder: (_, familyName) => Text(
          familyName.text,
          style: TextStyle(fontFamily: familyName.value),
        ),
        onSelect: (familyName) {
          cacheRepository.changeGlobalFontFamily(familyName);
        },
      ),
    ]);
  }
}

///切换型设置块
class _SwitchableConfigs<T, D> extends StatelessWidget {
  const _SwitchableConfigs({
    Key? key,
    required this.title,
    required this.listenable,
    required this.configs,
    required this.selector,
    required this.itemBuilder,
    required this.onSelect,
  }) : super(key: key);

  final String title;
  final ValueListenable<T> listenable;
  final List<D> configs;
  final bool Function(T listenableValue, D current) selector;
  final Widget Function(BuildContext context, D config) itemBuilder;
  final ValueChanged<D> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///标题
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ),

        ///选项区
        ...configs.map<Widget>(
          (e) => SelectorListenableBuilder<T, bool>(
            valueListenable: listenable,
            selector: (value) => selector.call(value, e),
            builder: (_, selected, __) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  value: selected,
                  onChanged: (value) {
                    if (value == true) {
                      onSelect.call(e);
                    }
                  },
                  title: itemBuilder.call(context, e),
                ),
                const Divider(
                  thickness: 0.5,
                  height: 0.5,
                  indent: 16,
                  endIndent: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
