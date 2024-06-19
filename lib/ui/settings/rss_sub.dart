import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/models/rss.dart';
import 'package:miofeed/utils/network/get_rss.dart';
import 'package:miofeed/utils/rss/rss_cache.dart';
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
    _context = context;
    _setInfoDialog = setInfoDialog;
    rsctr.load();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 3),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 3,
            child: Obx(() => progressbar.widget.value),
          ),
        ),
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
    int type = -1,
  }) {
    if (name != null) rssSubNameController.text = name;
    if (showName != null) rssSubShowNameController.text = showName;
    if (link != null) rssSubLinkTextController.text = link;

    // 订阅类型
    int typeCode = type;

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
          ListTile(
            title: Text("订阅类型"),
            subtitle: // Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // children: [
                // Text("当前：${_typeSelected(typeCode)}"),
                DropdownMenu(
              controller: TextEditingController(text: _typeSelected(typeCode)),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 0, label: 'Atom'),
                DropdownMenuEntry(value: 1, label: 'RSS 1.0'),
                DropdownMenuEntry(value: 2, label: 'RSS 2.0'),
              ],
              onSelected: (value) async {
                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("无效的订阅类型"),
                    ),
                  );
                  return;
                }
                typeCode = value;
              },
            ),
            // ],
            // ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async => Get.close(0),
          child: Text('取消'),
        ),
        ElevatedButton(
          // 确定订阅逻辑
          onPressed: () async {
            if (rssSubLinkTextController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("请输入订阅链接"),
                ),
              );
              return;
            }
            if (name == null && rssSubNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("请输入订阅名"),
                ),
              );
              return;
            }
            if (typeCode == -1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
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
              type: typeCode,
              autoUpdate: true,
            );
            // 保存订阅
            RssStorage()
                .setRss(rssSubNameController.text, rss)
                .then((v) => rsctr.load());
            final res;
            try {
              res = await NetworkGetRss().get(rssSubLinkTextController.text);
            } catch (e, s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("无法请求订阅，请检查订阅链接是否正确或重试！"),
                ),
              );
              progressbar.finish();
              return;
            }
            //print(res);
            late final parsed;
            try {
              parsed = _parse(res, typeCode);
            } catch (e, s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("解析订阅失败，可能订阅类型有误，请重试！"),
                ),
              );
              progressbar.finish();
              return;
            }
            // print(parsed);
            RssCache.save(rss, res);
            progressbar.finish();
            Get.close(0);
            if (twiceClose) Get.close(0);
          },
          child: Text('确定'),
        ),
      ],
    );
  }

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
                        type: data.type,
                      )),
                    ),
                  ],
                ));
              },
            ),
            onDismissed: (direction) {
              RssStorage().removeRss(data.name);
              RssCache.deleteAll(data);
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
