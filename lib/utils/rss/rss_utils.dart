import 'package:miofeed/models/rss.dart';
import 'package:miofeed/utils/rss/rss_cache.dart';

class RssUtils {
  static get allRssParagraph {
    final datas = RssCache.rssMemCache;
    for (RSS data in datas) {
      switch(data.type) {
        case 0:
          final feed = data.data;

          break;
        case 1:
          break;
        case 2:
          break;
      }
    }
  }
}