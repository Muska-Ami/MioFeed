import 'generator.dart';

class UniversalItem {
  UniversalItem({
    required this.authors,
    this.categories,
    required this.contributors,
    this.generator,
    this.link,
    required this.publish_time,
    required this.update_time,
    required this.content,
  });

  final List<String> authors;
  final List<String>? categories;
  final List<String> contributors;
  final Generator? generator;
  final String? link;
  final DateTime publish_time;
  final DateTime update_time;
  final String content;
}