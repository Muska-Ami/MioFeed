import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/models/universal_item.dart';

class SearchData {
  SearchData({
    required this.matchTitle,
    required this.matchContent,
    required this.paraData,
    required this.paraFeed,
    this.title,
    this.contentMatched,
  });

  final bool matchTitle;
  final bool matchContent;

  final UniversalItem paraData;
  final UniversalFeed paraFeed;

  final String? title;
  final List<String>? contentMatched;
}
