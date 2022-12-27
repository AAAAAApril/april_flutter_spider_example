import 'package:april_flutter_utils/april.dart';
import 'package:spider/platform/bilibili/pagination/bili_data_wrapper.dart';

///分页列控制器
abstract class BiliBiliPaginationController<T>
    extends AbsPaginationController<T, BiliPaginationDataWrapper<T>> {
  BiliBiliPaginationController() : super();
}
