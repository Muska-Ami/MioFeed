import 'package:dart_rss/domain/atom_feed.dart';
import 'package:dart_rss/domain/rss1_feed.dart';
import 'package:dart_rss/domain/rss_feed.dart';
import 'package:miofeed/models/task_basic.dart';
import 'package:miofeed/storages/rss/rss_storage.dart';

import '../models/rss.dart';
import '../models/universal_feed.dart';
import '../storages/rss/rss_cache.dart';
import '../utils/network/get_rss.dart';

class SubscribeUpdateTask extends TaskBasic {

  static final _storage = RssStorage();

  static Future<void> run() async {
    final list = await _storage.getRssList() ?? [];
    for (var sub in list) {
      RSS data = await _storage.getRss(sub);

      // 如果没开自动更新直接跳过
      if (!data.autoUpdate) break;

      print('Updating subscribe: $sub');

      final url = data.subscribeUrl;
      final String res;
      try {
        res = await NetworkGetRss().get(url);
      } catch (e, s) {
        print('Update RSS sub ${data.name} failed:');
        print(e);
        print(s);
        return;
      }
      //print(res);
      late final UniversalFeed parsed;
      try {
        final parsedData = _parse(res, data.type);
        if (parsedData is AtomFeed) {
          parsed = UniversalFeed.fromAtom(parsedData);
          // print(data.items.first.links.first.href);
        } else if (parsedData is RssFeed) {
          parsed = UniversalFeed.fromRss(parsedData);
        } else if (parsedData is Rss1Feed) {
          parsed = UniversalFeed.fromRss1(parsedData);
        }
      } catch (e, s) {
        print('Parse result for RSS sub ${data.name} failed:');
        print(e);
        print(s);
        return;
      }
      data.data = parsed;
      // print(parsed);
      await RssCache.save(data, res);
      await RssCache.removeMemCacheBySubName(sub);
      await RssCache.toMemCache(data, data.data);
      print('Update for subscribe finished: $sub');
    }
  }

  static _parse(String data, int type) {
    switch (type) {
      case 0:
        return AtomFeed.parse(data);
      case 1:
        return Rss1Feed.parse(data);
      case 2:
        return RssFeed.parse(data);
    }
  }

  @override
  startUp({Function? callback}) async {
    await run();
  }
}