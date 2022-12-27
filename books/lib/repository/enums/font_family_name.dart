///字体样式名
enum FontFamilyName {
  ///无字体（使用默认字体）
  none(
    text: '默认',
  ),

  ///华文行楷
  hwXingKai(
    value: 'hw_XingKai',
    text: '华文行楷',
  ),

  ///华文新魏
  hwXinWei(
    value: 'hw_XinWei',
    text: '华文新魏',
  ),

  ///隶书
  liShu(
    value: 'liShu',
    text: '隶书',
  );

  const FontFamilyName({
    this.value = '',
    required this.text,
  });

  final String value;
  final String text;
}

extension FontFamilyNameListExt on List<FontFamilyName> {
  FontFamilyName byValue(String value) {
    try {
      return firstWhere((element) => element.value == value);
    } catch (_) {
      return FontFamilyName.none;
    }
  }
}
