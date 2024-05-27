import 'package:miofeed/models/rss.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/utils/rss/rss_cache.dart';

class RssUtils {
  static get allRssParagraph {
    final List<Map<String, dynamic>> paragraphList = [];
    final fullData = RssCache.rssMemCache;
    for (Map<String, dynamic> data in fullData) {
      UniversalFeed feed = data['feed'];
      for (var item in feed.item) {
        Map<String, dynamic> paragraph = {
          'item': item,
          'feed_origin': fullData['sub'],
          'feed_data': feed,
        };
        paragraphList.add(paragraph);
      }
    }
    return paragraphList;
  }
}