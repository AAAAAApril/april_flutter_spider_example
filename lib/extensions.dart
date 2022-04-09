import 'package:html/dom.dart';

import 'log.dart';

extension ElementExt on Element {
  ///获取非空的属性值
  String nonnullAttributeValue(
    String attributeKey, {
    bool needTrim = true,
  }) {
    String result = attributes[attributeKey] ?? '';
    if (needTrim) {
      result = result.trim();
    }
    return result;
  }

  ///获取非空的目标节点下的子节点
  List<Element> nonnullChildrenElement(
    String selector, {
    required String childrenSelector,
  }) {
    Element? element = querySelector(selector);
    if (element == null) {
      return <Element>[];
    }
    return element.querySelectorAll(childrenSelector);
  }

  ///获取非空的目标节点的内容文字
  String nonnullElementText(
    String selector, {
    bool needTrim = true,
  }) {
    String result = querySelector(selector)?.text ?? '';
    if (needTrim) {
      result = result.trim();
    }
    return result;
  }

  ///获取非空的目标节点中的某个属性
  String nonnullElementAttributeValue(
    String selector, {
    required String attributeKey,
    bool needTrim = true,
  }) {
    Element? element = querySelector(selector);
    if (element == null) {
      return '';
    }
    return element.nonnullAttributeValue(attributeKey);
  }
}

extension DocumentExt on Document {
  ///获取非空的属性值
  String nonnullAttributeValue(
    String attributeKey, {
    bool needTrim = true,
  }) {
    String result = attributes[attributeKey] ?? '';
    if (needTrim) {
      result = result.trim();
    }
    return result;
  }

  ///获取非空的目标节点下的子节点
  List<Element> nonnullChildrenElement(
    String selector, {
    required String childrenSelector,
  }) {
    Element? element = querySelector(selector);
    if (element == null) {
      return <Element>[];
    }
    return element.querySelectorAll(childrenSelector);
  }

  ///获取非空的目标节点的内容文字
  String nonnullElementText(
    String selector, {
    bool needTrim = true,
  }) {
    String result = querySelector(selector)?.text ?? '';
    if (needTrim) {
      result = result.trim();
    }
    return result;
  }

  ///获取非空的目标节点中的某个属性
  String nonnullElementAttributeValue(
    String selector, {
    required String attributeKey,
    bool needTrim = true,
  }) {
    Element? element = querySelector(selector);
    if (element == null) {
      return '';
    }
    return element.nonnullAttributeValue(attributeKey);
  }
}

extension FutureExt<T> on Future<T> {
  ///打印请求时间
  Future<T> printRequestTime(String requestTag) {
    if (!Log.isDebug) {
      return this;
    }
    Log.print(tag: '$requestTag，start：${DateTime.now().toString()}');
    return whenComplete(() {
      Log.print(tag: '$requestTag，end：${DateTime.now().toString()}');
    });
  }
}

extension StringExt on String {
  ///取出满足条件的两个字符中间的数字
  int? numberBetween(String before, String after) {
    String? matched = RegExp('(?<=$before)\\d*(?=$after)').stringMatch(this);
    if (matched != null) {
      int? result = int.tryParse(matched);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
