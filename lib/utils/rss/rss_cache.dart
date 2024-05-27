import 'dart:io';

import 'package:miofeed/models/rss.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/utils/shared_data.dart';

class RssCache {
  static final List<Map<String, dynamic>> rssList = [];

  /// 缓存一个RSS订阅
  static Future<void> save(RSS rss, String data) async =>
      await File('${SharedData.documentPath}/${rss.name}/cache.xml')
          .writeAsString(data);

  /// 清除一个RSS订阅缓存
  static Future<void> delete(RSS rss) async {
    final fi = File('${SharedData.documentPath}/${rss.name}/cache.xml');
    if (!await fi.exists()) {
      await fi.delete();
    }
  }

  static Future<void> toMemCache(RSS rss, UniversalFeed feed) async =>
      rssList.add({
        'sub': rss,
        'data': feed,
      });
  static Future<void> removeMemCache(rss) async => rssList.remove(rss);
  static get rssMemCache => rssList;
}
