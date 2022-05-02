// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(value) => "作者：${value}";

  static String m1(value) => "分类：${value}";

  static String m2(value) => "状态：${value}";

  static String m3(value) => "字数：${value}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "_locale": MessageLookupByLibrary.simpleMessage("zh"),
        "allChapters": MessageLookupByLibrary.simpleMessage("所有章节"),
        "allowedNetworkType": MessageLookupByLibrary.simpleMessage("允许使用的网络类型"),
        "author": m0,
        "bookShelf": MessageLookupByLibrary.simpleMessage("书架"),
        "category": m1,
        "globalFontFamily": MessageLookupByLibrary.simpleMessage("全局字体"),
        "globalThemeMode": MessageLookupByLibrary.simpleMessage("全局主题"),
        "introduction": MessageLookupByLibrary.simpleMessage("简介"),
        "isReverseOrder": MessageLookupByLibrary.simpleMessage("是否倒序显示"),
        "latestChapter": MessageLookupByLibrary.simpleMessage("最新章节："),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "searchHint": MessageLookupByLibrary.simpleMessage("搜索小说、作者（最好输入完整名称）"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "status": m2,
        "wordsCount": m3
      };
}
