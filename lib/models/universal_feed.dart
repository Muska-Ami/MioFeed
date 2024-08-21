import 'package:dart_rss/dart_rss.dart';
import 'package:dart_rss/domain/rss1_item.dart';
import 'package:miofeed/models/universal_person.dart';
import 'package:miofeed/models/universal_item.dart';

class UniversalFeed {
  UniversalFeed({
    required this.title,
    required this.author,
    required this.description,
    required this.icon,
    required this.link,
    required this.copyright,
    this.categories,
    required this.date,
    required this.item,
  });

  final String title;
  final List<UniversalPerson> author;
  final String description;
  final String icon;
  final String link;
  final String copyright;
  final List<String>? categories;
  final DateTime? date;
  final List<UniversalItem> item;

  UniversalFeed.fromAtom(AtomFeed atom)
      : title = atom.title ?? '无标题',
        author = _atomToUniversalPersonList(atom.authors),
        description = '没有介绍',
        icon = atom.logo ?? '',
        link = atom.links.first.href ?? '',//atom.links,
        copyright = atom.rights ?? '',
        categories = _atomToStringCategories(atom.categories),
        date = atom.updated != null ? DateTime.parse(atom.updated!) : null,
        item = _buildItemsList(atom.items, 0);
  UniversalFeed.fromRss1(Rss1Feed rss1)
      : title = rss1.title ?? '无标题',
        author = [UniversalPerson(name: rss1.dc?.creator)],
        description = rss1.description ?? '没有介绍',
        icon = rss1.image ?? '',
        link = rss1.link ?? '',
        copyright = rss1.dc?.rights ?? '没有版权信息',
        categories = rss1.dc?.subjects,
        date = rss1.dc?.date != null ? DateTime.parse(rss1.dc!.date!) : null,
        item = _buildItemsList(rss1.items, 1);
  UniversalFeed.fromRss(RssFeed rss)
      : title = rss.title ?? '无标题',
        author = [UniversalPerson(name: rss.author)],
        description = rss.description ?? '没有介绍',
        icon = rss.image?.link ?? '',
        link = rss.link ?? '',
        copyright = rss.copyright ?? '没有版权信息',
        categories = _rssToStringCategories(rss.categories),
        date = rss.lastBuildDate != null
            ? DateTime.parse(rss.lastBuildDate!)
            : null,
        item = _buildItemsList(rss.items, 2);

  static List<UniversalPerson> _atomToUniversalPersonList(
      List<AtomPerson> people) {
    final List<UniversalPerson> uniPeople = [];
    for (var person in people) {
      uniPeople.add(UniversalPerson(
        name: person.name,
        email: person.email,
        link: person.uri,
      ));
    }
    return uniPeople;
  }

  static List<String> _atomToStringCategories(List<AtomCategory> ac) {
    final List<String> list = [];
    for (var single in ac) {
      list.add(single.label ?? '未知');
    }
    return list;
  }

  static List<String> _rssToStringCategories(List<RssCategory> ac) {
    final List<String> list = [];
    for (var single in ac) {
      list.add(single.value ?? '未知');
    }
    return list;
  }

  static List<UniversalItem> _buildItemsList(List items, int type) {
    final List<UniversalItem> universal = [];
    switch (type) {
      case 0:
        final List<AtomItem> itemsList = items as List<AtomItem>;
        for (var item in itemsList) {
          final List<String> authors = [];
          final List<String> contributors = [];

          for (var person in item.authors) {
            authors.add(person.name ?? '未知');
          }
          for (var contributor in item.contributors) {
            contributors.add(contributor.name ?? '未知');
          }

          universal.add(UniversalItem(
            link: item.links.first.href,
            title: item.title ?? '未知',
            authors: authors,
            contributors: contributors,
            publishTime:
                item.published != null ? DateTime.parse(item.published!) : null,
            updateTime:
                item.updated != null ? DateTime.parse(item.updated!) : null,
            content: item.content ?? '无内容',
          ));
        }
        break;
        // TODO: Finish translate
      case 1:
        final List<Rss1Item> itemsList = items as List<Rss1Item>;
        break;
      case 2:
        final List<RssItem> itemsList = items as List<RssItem>;
        break;
    }
    return universal;
  }
}
