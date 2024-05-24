import 'dart:io';

import 'package:miofeed/models/rss.dart';

class RssCache {
  /// 缓存一个RSS订阅
  static Future<void> save(RSS rss, String data) async => await File('${rss.name}/cache.xml').writeAsString(data);
  /// 清除一个RSS订阅缓存
  static Future<void> delete(RSS rss) async {
    final fi = File('${rss.name}/cache.xml');
    if (!await fi.exists()) {
      await fi.delete();
    }
  }
}