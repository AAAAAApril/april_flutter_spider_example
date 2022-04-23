///字体样式名
enum FontFamilyName {
  ///无字体（使用默认字体）
  none,

  ///华文楷体
  hwKaiTi,

  ///华文行楷
  hwXingKai,

  ///华文新魏
  hwXinWei,

  ///楷体
  kaiTi,

  ///隶书
  liShu,
}

extension FontFamilyNameExt on FontFamilyName {
  String get fontName {
    switch (this) {
      case FontFamilyName.none:
        return '无';
      case FontFamilyName.hwKaiTi:
        return '华文楷体';
      case FontFamilyName.hwXingKai:
        return '华文行楷';
      case FontFamilyName.hwXinWei:
        return '华文新魏';
      case FontFamilyName.kaiTi:
        return '楷体';
      case FontFamilyName.liShu:
        return '隶书';
    }
  }
}
