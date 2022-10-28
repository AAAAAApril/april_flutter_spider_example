import 'dart:convert';

import 'package:flutter/foundation.dart';

///打印日志
class Log {
  Log._();

  ///打印普通日志
  static bool print({
    ValueGetter<Object?>? value,
    String? tag,
  }) {
    _longPrint(value?.call(), tag: tag);
    return true;
  }
}

///长数据量时分段打印
void _longPrint(
  Object? source, {
  String? tag,
  int limitLength = 500,
}) {
  if (tag != null) {
    _flutterPrint(tag);
  }
  if (source == null) {
    return;
  }
  String target;
  if (source is Map<String, dynamic>) {
    target = jsonEncode(source);
  } else {
    target = source.toString();
  }
  if (target.isEmpty) {
    return;
  }
  if (target.length < limitLength) {
    _flutterPrint(target);
  } else {
    var outStr = StringBuffer();
    for (var index = 0; index < target.length; index++) {
      outStr.write(target[index]);
      if (index % limitLength == 0 && index != 0) {
        _flutterPrint(outStr.toString());
        outStr.clear();
        var lastIndex = index + 1;
        if (target.length - lastIndex < limitLength) {
          _flutterPrint(target.substring(lastIndex, target.length));
          break;
        }
      }
    }
  }
}

void _flutterPrint(String value) {
  debugPrint(value);
}
