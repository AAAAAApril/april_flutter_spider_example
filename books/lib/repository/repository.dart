import 'package:books/viewmodel/settings/global_configs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spider/novel/bqg99/bean/novel.dart';
import 'package:spider/novel/bqg99/bean/search.dart';
import 'package:spider/novel/bqg99/bqg.dart';

///数据源
class Repository {
  Repository._();

  ///获取全局配置
  static Future<GlobalConfigs> getGlobalSettings() {
    return SharedPreferences.getInstance()
        .then<GlobalConfigs>((sharedPreferences) {
      return GlobalConfigs.fromJson(
        sharedPreferences.getString(GlobalConfigs.cacheKey),
      );
    });
  }

  ///设置全局配置
  static Future<bool> setGlobalSettings(GlobalConfigs configs) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.setString(
        GlobalConfigs.cacheKey,
        configs.toString(),
      );
    });
  }

  ///获取书架书籍
  static Future<List<SearchResultBean>> getFavorites() async {
    //TODO
    return [];
  }

  ///添加到书架
  // static Future<void> addFavorite(String bookId){
  //
  //   return ;
  // }

  ///搜索
  static Future<List<SearchResultBean>> search(String keywords){
    return Bqg99.searchNovel(keywords);
  }

  ///书籍详情
  static Future<NovelBean?> bookDetail(String bookId) {
    return Bqg99.novelDetail(bookId);
  }
}
