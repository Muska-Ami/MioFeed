import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:miofeed/models/rss.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/utils/fs_utils.dart';
import 'package:miofeed/storages/rss/rss_storage.dart';
import 'package:miofeed/utils/shared_data.dart';

class RssCache {
  static final List<Map<String, dynamic>> rssList = [];

  /// 缓存一个RSS订阅
  static Future<void> save(RSS rss, String data) async {
    final dir = Directory('${SharedData.documentPath}/${rss.name}');
    if (!(await dir.exists())) await dir.create();
    await File('${SharedData.documentPath}/${rss.name}/cache.xml')
        .writeAsString(data);
  }

  /// 清除一个RSS订阅缓存
  static Future<void> delete(RSS rss) async {
    final fi = File('${SharedData.documentPath}/${rss.name}/cache.xml');
    if (await fi.exists()) {
      await fi.delete();
    }
  }

  /// 读取一个RSS订阅缓存
  static Future<String> read(String subName) async {
    final fi = File('${SharedData.documentPath}/$subName/cache.xml');
    if (await fi.exists()) {
      return await fi.readAsString();
    }
    return '';
  }

  /// 清除一个RSS订阅全部缓存
  static Future<void> deleteAll(RSS rss) async {
    final dir = Directory('${SharedData.documentPath}/${rss.name}');
    FsUtils.deleteDirectory(dir);
  }

  static Future<void> toMemCache(RSS rss, UniversalFeed feed) async =>
      rssList.add({
        'sub': rss,
        'data': feed,
      });
  static Future<void> removeMemCache(rss) async => rssList.remove(rss);
  static get rssMemCache => rssList;

  static Future<void> readAllToRemCache() async {
    final rst = RssStorage();
    final list = <Map<String, dynamic>>[];
    for (var rsd in (await rst.getRssList()) ?? []) {
      final subInfo = await RssStorage().getRss(rsd);

      final data = await read(subInfo.name);
      if (data.isNotEmpty) {
        switch (subInfo.type) {
          case 0:
            list.add({
              'sub': subInfo,
              'data': UniversalFeed.fromAtom(AtomFeed.parse(data)),
            });
            break;
          case 1:
            list.add({
              'sub': subInfo,
              'data': UniversalFeed.fromRss1(Rss1Feed.parse(data)),
            });
            break;
          case 2:
            list.add({
              'sub': subInfo,
              'data': UniversalFeed.fromRss(RssFeed.parse(data)),
            });
            break;
        }
      }
    }
    rssList.addAll(list);
  }
}
