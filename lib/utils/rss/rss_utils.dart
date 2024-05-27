import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/utils/rss/rss_cache.dart';

class RssUtils {
  static List<Map<String, dynamic>> get allRssParagraph {
    final List<Map<String, dynamic>> paragraphList = [
      // 一点点测试数据
      // {
      //   'item': UniversalItem(
      //     title: 'Test Paragraph',
      //     authors: ['Muska Ami'],
      //     contributors: [],
      //     publish_time: DateTime.now(),
      //     update_time: DateTime.now(),
      //     content: 'Hello world! This is a veeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrryyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy loooooooogggggggggggg content that laaaaarrrrrrrrrrrrrggggggggggeeeeeeeeerrrrrrrrrrrrrr than 320 chars.',
      //     categories: ['test1', 'test2']
      //   ),
      //   'feed_origin': RSS(
      //       name: 'test',
      //       showName: "Test",
      //       subscribeUrl: 'https://blog.1l1.icu/atom.xml',
      //       type: 0,
      //       autoUpdate: true),
      //   'feed_data': UniversalFeed(
      //       title: 'Test Feed',
      //       author: ['Muska Ami'],
      //       icon: 'https://blog.1l1.icu/images/avatar@round.png',
      //       link: 'https://blog.1l1.icu',
      //       copyright: 'Muska Ami',
      //       categories: ['test1', 'test2'],
      //       date: DateTime.now(),
      //       description: 'Test Feed',
      //       item: []),
      // }
    ];
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
