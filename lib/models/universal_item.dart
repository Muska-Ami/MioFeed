import 'generator.dart';

class UniversalItem {
  UniversalItem({
    required this.title,
    required this.authors,
    this.categories,
    required this.contributors,
    this.generator,
    this.link,
    this.publish_time,
    this.update_time,
    required this.content,
  });

  final String title;
  final List<String> authors;
  final List<String>? categories;
  final List<String> contributors;
  final Generator? generator;
  final String? link;
  final DateTime? publish_time;
  final DateTime? update_time;
  final String content;
}
