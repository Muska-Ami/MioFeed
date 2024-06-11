import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/models/rss.dart';
import 'package:miofeed/utils/network/get_rss.dart';
import 'package:miofeed/utils/rss/rss_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/navigation_bar.dart';

late BuildContext _context;
late var _setInfoDialog;

class RssSubSettingUI extends StatefulWidget {
  RssSubSettingUI({super.key, required this.title});

  final String title;

  @override
  State<RssSubSettingUI> createState() => _RssSubSettingState(title: title);
}

class _RssSubSettingState extends State<RssSubSettingUI> {
  _RssSubSettingState({required this.title});

  final String title;

  final _RssSubController rsctr = Get.put(_RssSubController());

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
    _context = context;
    _setInfoDialog = setInfoDialog;
    rsctr.load();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.add),
              title: Text('添加新订阅...'),
            ),
            onTap: () async => Get.dialog(setInfoDialog()),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.bookmark_added),
                  title: Text("已订阅"),
                ),
                Obx(() => Column(
                      children: rsctr.subListWidgets.value,
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }

  AlertDialog setInfoDialog({
    String? name = null,
    String? showName = null,
    String? link = null,
    bool twiceClose = false,
  }) {
    if (name != null) rssSubNameController.text = name;
    if (showName != null) rssSubShowNameController.text = showName;
    if (link != null) rssSubLinkTextController.text = link;
    return AlertDialog(
      title: Text('订阅'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("订阅链接"),
            subtitle: TextField(
              controller: rssSubLinkTextController,
            ),
          ),
          name == null
              ? ListTile(
                  title: Text("订阅名"),
                  subtitle: TextField(
                    controller: rssSubNameController,
                  ),
                )
              : Container(),
          ListTile(
            title: Text("显示名称"),
            subtitle: TextField(
              controller: rssSubShowNameController,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async => Get.close(0),
          child: Text('取消'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (rssSubLinkTextController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("请输入订阅链接"),
                ),
              );
            } else if (name == null && rssSubNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("请输入订阅名"),
                ),
              );
            } else {
              RssStorage()
                  .setRss(
                    rssSubNameController.text,
                    RSS(
                      name: name ?? rssSubNameController.text,
                      showName: rssSubShowNameController.text.isNotEmpty
                          ? rssSubShowNameController.text
                          : rssSubNameController.text,
                      subscribeUrl: rssSubLinkTextController.text,
                      type: 0,
                      autoUpdate: true,
                    ),
                  )
                  .then((v) => rsctr.load());
              final res = await NetworkGetRss().get(rssSubLinkTextController.text);
              
              Get.close(0);
              if (twiceClose) Get.close(0);
            }
          },
          child: Text('确定'),
        ),
      ],
    );
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

class _RssSubController extends GetxController {
  var subListWidgets = <Widget>[].obs;

  load() async {
    final rssList = await RssStorage().getRssList() ?? [];
    if (rssList.isEmpty) {
      subListWidgets.clear();
      subListWidgets.add(Center(
        child: Text('啥都没有~'),
      ));
      subListWidgets.refresh();
    } else {
      subListWidgets.clear();
      for (String key in rssList) {
        // print(key);
        RSS data = await RssStorage().getRss(key);
        var uuid = Uuid();
        subListWidgets.add(
          Dismissible(
            key: Key('${uuid.v8()}@${data.name}'),
            child: InkWell(
              child: ListTile(
                title: Text('${data.showName} (${data.name})'),
                subtitle: Text(data.subscribeUrl),
              ),
              onTap: () async {
                Get.dialog(SimpleDialog(
                  title: Text('操作'),
                  children: [
                    SimpleDialogOption(
                      child: Text('更新信息'),
                      onPressed: () async => Get.dialog(_setInfoDialog(
                        name: data.name,
                        showName: data.showName,
                        link: data.subscribeUrl,
                        twiceClose: true,
                      )),
                    ),
                  ],
                ));
              },
            ),
            onDismissed: (direction) {
              RssStorage().removeRss(data.name);
              ScaffoldMessenger.of(_context).showSnackBar(
                SnackBar(
                  content: Text('已删除'),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      subListWidgets.refresh();
    }
  }
}
