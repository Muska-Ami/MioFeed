import 'generator.dart';

class UniversalItem {
  UniversalItem({
    required this.title,
    required this.authors,
    this.categories,
    required this.contributors,
    this.generator,
    this.link,
    this.publishTime,
    this.updateTime,
    required this.content,
  });

  final String title;
  final List<String> authors;
  final List<String>? categories;
  final List<String> contributors;
  final Generator? generator;
  final String? link;
  final DateTime? publishTime;
  final DateTime? updateTime;
  final String content;
}
