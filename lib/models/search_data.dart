class SearchData {
  SearchData({
    required this.matchTitle,
    required this.matchContent,
    this.title,
    this.contentMatched,
  });

  final bool matchTitle;
  final bool matchContent;

  final String? title;
  final List<String>? contentMatched;
}
