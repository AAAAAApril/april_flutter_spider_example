import 'package:april/data/pagination_controller.dart';
import 'package:april_spider/bilibili/pagination/bili_data_wrapper.dart';

///分页列控制器
abstract class BiliBiliPaginationController<T>
    extends AbsPaginationController<T, BiliPaginationDataWrapper<T>> {
  BiliBiliPaginationController() : super();
}
