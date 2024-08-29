import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/models/rss.dart';
import 'package:miofeed/ui/settings/rss_subscribe/new.dart';
import 'package:miofeed/storages/rss/rss_cache.dart';
import 'package:miofeed/storages/rss/rss_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/navigation_bar.dart';

late BuildContext _context;
// late var _setInfoDialog;

class RssSubSettingUI extends StatefulWidget {
  const RssSubSettingUI({super.key, required this.title});

  final String title;

  @override
  State<RssSubSettingUI> createState() => _RssSubSettingState(title: title);
}

class _RssSubSettingState extends State<RssSubSettingUI> {
  _RssSubSettingState({required this.title});

  final String title;

  final _RssSubscribeSettingsController _ctr = Get.put(_RssSubscribeSettingsController());
  final ProgressbarController progressbar = Get.find();

  @override
  Widget build(BuildContext context) {
    _context = context;
    // _setInfoDialog = setInfoDialog;
    _ctr.load();
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
            onTap: () async {
              final res = await Get.to(() => const RssSubNewUI());
              if (res != null && res) _ctr.load();
            },
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                const ListTile(
                  leading: Icon(Icons.bookmark_added),
                  title: Text("已订阅"),
                ),
                Obx(() => Column(
                      children: _ctr.subListWidgets.value,
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}

class _RssSubscribeSettingsController extends GetxController {
  var subListWidgets = <Widget>[].obs;

  load() async {
    final rssList = await RssStorage().getRssList() ?? [];
    if (rssList.isEmpty) {
      subListWidgets.clear();
      subListWidgets.add(const Center(
        child: Text('啥都没有~'),
      ));
      subListWidgets.refresh();
    } else {
      subListWidgets.clear();
      for (String key in rssList) {
        // print(key);
        RSS data = await RssStorage().getRss(key);
        var uuid = const Uuid();
        subListWidgets.add(
          // 手势
          Dismissible(
            key: Key('${uuid.v8()}@${data.name}'),
            onDismissed: (direction) {
              RssStorage().removeRss(data.name);
              RssCache.deleteAll(data);
              ScaffoldMessenger.of(_context).showSnackBar(
                const SnackBar(
                  content: Text('已删除'),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            // 点击
            child: InkWell(
              child: ListTile(
                title: Text('${data.showName} (${data.name})'),
                subtitle: Text(data.subscribeUrl),
              ),
              onTap: () async {
                Get.dialog(SimpleDialog(
                  title: const Text('操作'),
                  children: [
                    SimpleDialogOption(
                      child: const Text('更新信息'),
                      onPressed: () async {
                        final res = await Get.to(() => RssSubNewUI(
                              name: data.name,
                              showName: data.showName,
                              link: data.subscribeUrl,
                              type: data.type,
                            ));
                        if (res != null && res) load();
                        Get.close(0);
                      },
                    ),
                  ],
                ));
              },
            ),
          ),
        );
      }
      subListWidgets.refresh();
    }
  }
}
