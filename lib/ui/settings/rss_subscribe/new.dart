import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/models/rss.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/utils/network/get_rss.dart';
import 'package:miofeed/storages/rss/rss_cache.dart';
import 'package:miofeed/storages/rss/rss_storage.dart';
import 'package:flutter/services.dart';

class RssSubNewUI extends StatefulWidget {
  const RssSubNewUI({
    super.key,
    this.name,
    this.showName,
    this.link,
    this.type = -1,
  });

  final String? name;
  final String? showName;
  final String? link;
  final int type;

  @override
  State<StatefulWidget> createState() => _RssSubNewState(
        name: name,
        showName: showName,
        link: link,
        type: type,
      );
}

class _RssSubNewState extends State<RssSubNewUI> {
  _RssSubNewState({
    this.name,
    this.showName,
    this.link,
    required this.type,
  });
  final String? name;
  final String? showName;
  final String? link;
  int type;

  final ProgressbarController progressbar = Get.find();

  TextEditingController rssSubLinkTextController = TextEditingController();
  TextEditingController rssSubNameController = TextEditingController();
  TextEditingController rssSubShowNameController = TextEditingController();

  @override
  void dispose() {
    rssSubLinkTextController.dispose();
    rssSubNameController.dispose();
    rssSubShowNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (name != null) rssSubNameController.text = name!;
    if (showName != null) rssSubShowNameController.text = showName!;
    if (link != null) rssSubLinkTextController.text = link!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加订阅"),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 3),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 3,
            child: Obx(() => progressbar.widget.value),
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("订阅链接"),
                subtitle: TextField(
                  controller: rssSubLinkTextController,
                ),
              ),
              name == null
                  ? ListTile(
                      title: const Text("订阅名"),
                      subtitle: TextField(
                        controller: rssSubNameController,
                        inputFormatters: [_LowercaseAndDashFormatter()],
                      ),
                    )
                  : Container(),
              ListTile(
                title: const Text("显示名称"),
                subtitle: TextField(
                  controller: rssSubShowNameController,
                ),
              ),
              ListTile(
                title: const Text("订阅类型"),
                subtitle: DropdownMenu(
                  width: MediaQuery.of(context).size.width - 40,
                  controller: TextEditingController(text: _typeSelected(type)),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 0, label: 'Atom'),
                    DropdownMenuEntry(value: 1, label: 'RSS 1.0'),
                    DropdownMenuEntry(value: 2, label: 'RSS 2.0'),
                  ],
                  onSelected: (value) async {
                    if (value == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("无效的订阅类型"),
                        ),
                      );
                      return;
                    }
                    type = value;
                  },
                ),
                // ],
                // ),
              ),
            ],
          ),
          SizedBox(
            child: MediaQuery.of(context).size.width <= 500
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: _actionsList(),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _actionsList(),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _actionsList() => [
        Container(
          // 宽度小于 500
          // 是 -> 容器宽度 = 宽度 - 20
          // 否 -> 宽度 / 2 小于 500
          //       是 -> 容器宽度 = (宽度 - 100) / 2
          //       否 -> 容器宽度 = 500
          width: MediaQuery.of(context).size.width <= 500
              ? MediaQuery.of(context).size.width - 20
              : ((MediaQuery.of(context).size.width - 100) / 2) <= 500
                  ? (MediaQuery.of(context).size.width - 100) / 2
                  : 500,
          margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: ElevatedButton(
            onPressed: () async => Get.back(result: false),
            child: const Text('取消'),
          ),
        ),
        Container(
          // 参见上方
          width: MediaQuery.of(context).size.width <= 500
              ? MediaQuery.of(context).size.width - 20
              : ((MediaQuery.of(context).size.width - 100) / 2) <= 500
                  ? (MediaQuery.of(context).size.width - 100) / 2
                  : 500,
          margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: ElevatedButton(
            // 确定订阅逻辑
            onPressed: () async {
              if (rssSubLinkTextController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("请输入订阅链接"),
                  ),
                );
                return;
              }
              if (name == null && rssSubNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("请输入订阅名"),
                  ),
                );
                return;
              }
              if (type == -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("当前没有选择订阅类型，请选择"),
                  ),
                );
                return;
              }
              progressbar.start();
              // 最终数据
              final rss = RSS(
                name: name ?? rssSubNameController.text,
                showName: rssSubShowNameController.text.isNotEmpty
                    ? rssSubShowNameController.text
                    : rssSubNameController.text,
                subscribeUrl: rssSubLinkTextController.text,
                type: type,
                autoUpdate: true,
              );
              // 保存订阅
              RssStorage().setRss(rssSubNameController.text, rss);
              // .then((v) => rsctr.load());
              final String res;
              try {
                res = await NetworkGetRss().get(rssSubLinkTextController.text);
              } catch (e, s) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "无法请求订阅，请检查订阅链接是否正确或重试！"),
                    ),
                  );
                }
                print(e);
                print(s);
                progressbar.finish();
                return;
              }
              //print(res);
              late final UniversalFeed parsed;
              try {
                final data = _parse(res, type);
                if (data is AtomFeed) {
                  parsed = UniversalFeed.fromAtom(data);
                  // print(data.items.first.links.first.href);
                } else if (data is RssFeed) {
                  parsed = UniversalFeed.fromRss(data);
                } else if (data is Rss1Feed) {
                  parsed = UniversalFeed.fromRss1(data);
                }
              } catch (e, s) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("解析订阅失败，可能订阅类型有误，请重试！"),
                  ),
                );
                print(e);
                print(s);
                progressbar.finish();
                return;
              }
              // print(parsed);
              RssCache.save(rss, res);
              RssCache.toMemCache(rss, UniversalFeed(
                title: parsed.title,
                author: parsed.author,
                description: parsed.description,
                icon: parsed.icon,
                link: parsed.link,
                copyright: parsed.copyright,
                date: parsed.date,
                item: parsed.item,
              ));
              progressbar.finish();
              Get.back(result: true);
              // Get.close(0);
              // if (twiceClose) Get.close(0);
            },
            child: const Text('确定'),
          ),
        ),
      ];

  String _typeSelected(typeCode) {
    switch (typeCode) {
      case -1:
        return '';
      case 0:
        return 'Atom';
      case 1:
        return 'RSS 1.0';
      case 2:
        return 'RSS 2.0';
    }
    return '';
  }

  _parse(String data, int type) {
    switch (type) {
      case 0:
        return AtomFeed.parse(data);
      case 1:
        return Rss1Feed.parse(data);
      case 2:
        return RssFeed.parse(data);
    }
  }
}

class _LowercaseAndDashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 使用正则表达式只允许小写字母和连字符
    final newText = newValue.text.replaceAll(RegExp('[^a-z0-9-]'), '');
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
