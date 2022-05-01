import 'package:flutter/material.dart';

///主题模式扩展
extension ThemeModeExt on ThemeMode {
  String get modeName {
    switch (this) {
      case ThemeMode.system:
        return '系统';
      case ThemeMode.light:
        return '明亮';
      case ThemeMode.dark:
        return '暗黑';
    }
  }
}
