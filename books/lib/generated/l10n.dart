// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Strings {
  Strings();

  static Strings? _current;

  static Strings get current {
    assert(_current != null,
        'No instance of Strings was loaded. Try to initialize the Strings delegate before accessing Strings.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Strings> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Strings();
      Strings._current = instance;

      return instance;
    });
  }

  static Strings of(BuildContext context) {
    final instance = Strings.maybeOf(context);
    assert(instance != null,
        'No instance of Strings present in the widget tree. Did you add Strings.delegate in localizationsDelegates?');
    return instance!;
  }

  static Strings? maybeOf(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  /// `zh`
  String get _locale {
    return Intl.message(
      'zh',
      name: '_locale',
      desc: '',
      args: [],
    );
  }

  /// `书架`
  String get bookShelf {
    return Intl.message(
      '书架',
      name: 'bookShelf',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get search {
    return Intl.message(
      '搜索',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settings {
    return Intl.message(
      '设置',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `全局主题`
  String get globalThemeMode {
    return Intl.message(
      '全局主题',
      name: 'globalThemeMode',
      desc: '',
      args: [],
    );
  }

  /// `全局字体`
  String get globalFontFamily {
    return Intl.message(
      '全局字体',
      name: 'globalFontFamily',
      desc: '',
      args: [],
    );
  }

  /// `搜索小说、作者（最好输入完整名称）`
  String get searchHint {
    return Intl.message(
      '搜索小说、作者（最好输入完整名称）',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `作者：{value}`
  String author(Object value) {
    return Intl.message(
      '作者：$value',
      name: 'author',
      desc: '',
      args: [value],
    );
  }

  /// `分类：{value}`
  String category(Object value) {
    return Intl.message(
      '分类：$value',
      name: 'category',
      desc: '',
      args: [value],
    );
  }

  /// `状态：`
  String get status {
    return Intl.message(
      '状态：',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `最新章节：`
  String get latestChapter {
    return Intl.message(
      '最新章节：',
      name: 'latestChapter',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Strings> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
