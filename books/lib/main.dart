import 'package:april/april.dart';
import 'package:april/utils/extensions.dart';
import 'package:april/utils/utils.dart';
import 'package:books/pages/detail.dart';
import 'package:books/pages/host.dart';
import 'package:books/pages/reading.dart';
import 'package:books/viewmodel/detail/detail_viewmodel.dart';
import 'package:books/viewmodel/reading/reading_viewmodel.dart';
import 'package:books/viewmodel/search/search_viewmodel.dart';
import 'package:books/viewmodel/settings/settings_viewmodel.dart';
import 'package:books/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'viewmodel/settings/font_family_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var info = await PackageInfo.fromPlatform();

  runApp(MultiProvider(
    providers: [
      ///搜索
      ChangeNotifierProvider(
        create: (context) => SearchViewModel(),
      ),

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

  ///全局字体样式
  late FontFamilyName globalFontFamily;

  ///全局主题样式
  late ThemeMode globalThemeMode;

  @override
  void initState() {
    super.initState();
    settingsViewModel = ViewModel.of<SettingsViewModel>(context);
    settingsViewModel.globalConfigs.value.let((it) {
      globalFontFamily = it.globalFontFamily;
      globalThemeMode = it.themeMode;
    });
    settingsViewModel.globalConfigs.addListener(onGlobalSettingChanged);
  }

  @override
  void dispose() {
    settingsViewModel.globalConfigs.removeListener(onGlobalSettingChanged);
    super.dispose();
  }

  ///全局设置有变化
  void onGlobalSettingChanged() {
    FontFamilyName newFamilyName =
        settingsViewModel.globalConfigs.value.globalFontFamily;
    ThemeMode newThemeMode = settingsViewModel.globalConfigs.value.themeMode;
    if (newFamilyName != globalFontFamily || newThemeMode != globalThemeMode) {
      globalFontFamily = newFamilyName;
      globalThemeMode = newThemeMode;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      themeMode: globalThemeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        fontFamily: globalFontFamily.name,
        appBarTheme: const AppBarTheme(centerTitle: true),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.black26,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        fontFamily: globalFontFamily.name,
        appBarTheme: const AppBarTheme(centerTitle: true),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type: BottomNavigationBarType.fixed,
        ),
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
      initialRoute: 'host',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {

          ///主界面
          case 'host':
            return MaterialPageRoute(
              builder: (context) => WillPopScope(
                onWillPop: () async {
                  ///回退到桌面
                  April.backToDesktop();
                  return false;
                },
                child: const HostPage(),
              ),
            );

          ///详情页
          case 'detail':
            return MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => BookDetailViewModel(
                  settings.arguments as String,
                ),
                child: const BookDetailPage(),
              ),
            );

          ///阅读页
          case 'reading':
            return MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => ReadingViewModel(
                  settings.arguments as String,
                ),
                child: const ReadingPage(),
              ),
            );
        }
      },
    );
  }
}
