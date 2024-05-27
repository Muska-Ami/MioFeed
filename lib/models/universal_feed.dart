import 'package:miofeed/models/universal_item.dart';

class UniversalFeed {
  UniversalFeed({
    required this.title,
    required this.author,
    required this.description,
    required this.icon,
    required this.link,
    required this.copyright,
    this.categories = null,
    required this.date,
    required this.item,
  });

  final String title;
  final List<String> author;
  final String description;
  final String icon;
  final String link;
  final String copyright;
  final List<String>? categories;
  final DateTime date;
  final UniversalItem item;
}
