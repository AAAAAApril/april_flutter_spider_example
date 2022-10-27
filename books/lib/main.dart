import 'package:april/april.dart';
import 'package:april/utils/extensions.dart';
import 'package:april/utils/utils.dart';
import 'package:books/pages/detail.dart';
import 'package:books/pages/host.dart';
import 'package:books/pages/reading/reading.dart';
import 'package:books/repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'generated/l10n.dart';
import 'repository/enums/font_family_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///缓存数据源
  late BookCacheRepository cacheRepository;

  ///全局字体样式
  late FontFamilyName globalFontFamily;

  ///全局主题样式
  late ThemeMode globalThemeMode;

  ///应用标题
  String title = '';

  @override
  void initState() {
    super.initState();
    cacheRepository = BooksRepository.instance.repository.cache;
    cacheRepository.globalConfigs.value.let((it) {
      globalFontFamily = it.globalFontFamily;
      globalThemeMode = it.themeMode;
    });
    cacheRepository.globalConfigs.addListener(onGlobalSettingChanged);
    //获取应用标题
    PackageInfo.fromPlatform().then((value) {
      title = value.appName;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    cacheRepository.globalConfigs.removeListener(onGlobalSettingChanged);
    super.dispose();
  }

  ///全局设置有变化
  void onGlobalSettingChanged() {
    FontFamilyName newFamilyName =
        cacheRepository.globalConfigs.value.globalFontFamily;
    ThemeMode newThemeMode = cacheRepository.globalConfigs.value.themeMode;
    if (newFamilyName != globalFontFamily || newThemeMode != globalThemeMode) {
      globalFontFamily = newFamilyName;
      globalThemeMode = newThemeMode;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      themeMode: globalThemeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        fontFamily: globalFontFamily.value,
        appBarTheme: const AppBarTheme(centerTitle: true),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black26,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        fontFamily: globalFontFamily.value,
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
              builder: (context) => BookDetailPage(
                bookId: settings.arguments as String,
              ),
            );

          ///阅读页
          case 'reading':
            return MaterialPageRoute(
              builder: (context) => ReadingPage(
                arguments: settings.arguments as ReadingArguments,
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
