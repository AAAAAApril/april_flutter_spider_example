import 'package:april/data/notifier_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// ViewModel 基类
abstract class ViewModel extends ChangeNotifier with ChangeNotifierMixin {
  static T of<T extends ViewModel>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }
}
