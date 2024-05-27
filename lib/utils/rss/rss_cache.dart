import 'dart:io';

import 'package:miofeed/models/rss.dart';
import 'package:miofeed/utils/shared_data.dart';

class RssCache {

  static final List<RSS> rss_list = [];

  /// 缓存一个RSS订阅
  static Future<void> save(RSS rss, String data) async => await File('${SharedData.documentPath}/${rss.name}/cache.xml').writeAsString(data);
  /// 清除一个RSS订阅缓存
  static Future<void> delete(RSS rss) async {
    final fi = File('${SharedData.documentPath}/${rss.name}/cache.xml');
    if (!await fi.exists()) {
      await fi.delete();
    }
  }

  static Future<void> toMemCache(RSS rss) async => rss_list.add(rss);
  static Future<void> removeMemCache(RSS rss) async => rss_list.remove(rss);
  static get rssMemCache => rss_list;
}