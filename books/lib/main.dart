import 'package:april/april.dart';
import 'package:april/utils/utils.dart';
import 'package:books/pages/host.dart';
import 'package:books/viewmodel/settings/fonts_mixin.dart';
import 'package:books/viewmodel/settings/settings_viewmodel.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var info = await PackageInfo.fromPlatform();

  runApp(MultiProvider(
    providers: [
      ///设置
      ChangeNotifierProvider(
        create: (context) => SettingsViewModel(),
      ),
    ],
    builder: (context, child) => MyApp(
      title: info.appName,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///设置
  late SettingsViewModel settingsViewModel;

  @override
  void initState() {
    super.initState();
    settingsViewModel = ViewModel.of<SettingsViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FontFamilyName>(
      valueListenable: settingsViewModel.globalFontFamilies,
      builder: (_, globalFontFamily, __) => MaterialApp(
        title: widget.title,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.grey,
          fontFamily: globalFontFamily.value,
        ),
        supportedLocales: Strings.delegate.supportedLocales,
        localizationsDelegates: const [
          Strings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        builder: (context, child) => GestureDetector(
          //全局点击空白处隐藏输入法
          onTap: () {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              //取消焦点
              clearFocus();
              //隐藏输入法
              hideInputMethod();
            }
          },
          child: child,
        ),
        home: WillPopScope(
          onWillPop: () async {
            ///回退到桌面
            April.backToDesktop();
            return false;
          },
          child: const HostPage(),
        ),
      ),
    );
  }
}
