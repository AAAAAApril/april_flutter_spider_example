import 'dart:convert';

import 'package:april/utils/json.dart';
import 'package:spider/platform/bilibili/bean/dynamic/dynamic_author.dart';
import 'package:spider/platform/bilibili/bean/dynamic/dynamic_content.dart';

import 'dynamic_type.dart';

///动态基本数据
class DynamicBean {
  const DynamicBean({
    required this.id,
    required this.author,
    required this.type,
    required this.text,
    required this.content,
    required this.original,
  });

  ///动态 id
  final String id;

  ///动态作者
  final DynamicAuthor author;

  ///动态类型
  final DynamicType type;

  ///动态文字
  final String text;

  ///真正的动态内容（转发的动态，或者纯文字动态时，没有这个值）
  final DynamicContent? content;

  ///被转发的动态原数据（仅在转发的动态时存在）
  final DynamicBean? original;

  factory DynamicBean.fromJson(Map map) {
    var json = Json(map);
    var type =
        DynamicType.values.byNameWithoutException(json.getString('type'));
    var modulesJson = Json(json.get('modules') as Map);
    var moduleDynamicJson = Json((modulesJson.get('module_dynamic') as Map));
    DynamicContent? content;
    DynamicBean? original;
    switch (type) {
      case DynamicType.DYNAMIC_TYPE_DRAW:
      case DynamicType.DYNAMIC_TYPE_ARTICLE:
      case DynamicType.DYNAMIC_TYPE_AV:
        Map? contentMap = moduleDynamicJson.get('major') as Map?;
        if (contentMap != null) {
          try {
            content = DynamicContent.fromJson(contentMap);
          } catch (_) {
            //ignore
          }
        }
        break;
      case DynamicType.DYNAMIC_TYPE_FORWARD:
        try {
          original = DynamicBean.fromJson(json.get('orig') as Map);
        } catch (_) {
          //ignore
        }
        break;
      case DynamicType.DYNAMIC_TYPE_WORD:
        break;
      case DynamicType.DYNAMIC_TYPE_NONE:
      case DynamicType.UNKNOWN:
        break;
    }
    return DynamicBean(
      id: json.getString('id_str'),
      author: DynamicAuthor.fromJson(modulesJson.get('module_author') as Map),
      type: type,
      text: ((moduleDynamicJson.get('desc') as Map?)?['text'] as String?) ?? '',
      content: content,
      original: original,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'author': author.toMap(),
        'type': type.name,
        'text': text,
        'content': content?.toMap(),
        'original': original?.toMap(),
      };

  @override
  String toString() => jsonEncode(toMap());
}
