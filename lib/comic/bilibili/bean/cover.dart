import 'dart:convert';

///漫画封面
class ComicCover {
  const ComicCover({
    required this.horizontal,
    required this.vertical,
    required this.square,
  });

  ///宽屏
  final String horizontal;

  ///窄屏
  final String vertical;

  ///正方形
  final String square;

  Map<String, dynamic> toMap() => {
        'horizontal': horizontal,
        'vertical': vertical,
        'square': square,
      };

  @override
  String toString() => jsonEncode(toMap());
}
