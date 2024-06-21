import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/models/rss.dart';
import 'package:miofeed/ui/settings/rss_sub/new.dart';
import 'package:miofeed/utils/rss/rss_cache.dart';
import 'package:miofeed/utils/rss/rss_storage.dart';
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

  final _RssSubController rsctr = Get.put(_RssSubController());
  final ProgressbarController progressbar = Get.find();

  @override
  Widget build(BuildContext context) {
    _context = context;
    // _setInfoDialog = setInfoDialog;
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
            onTap: () async {
              final res = await Get.to(() => const RssSubNewUI());
              if (res != null && res) rsctr.load();
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
  //
  // AlertDialog setInfoDialog({
  //   String? name = null,
  //   String? showName = null,
  //   String? link = null,
  //   bool twiceClose = false,
  //   int type = -1,
  // }) {
  //
  //   // 订阅类型
  //   int typeCode = type;
  //
  //   return AlertDialog(
  //     title: Text('订阅'),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         ListTile(
  //           title: Text("订阅链接"),
  //           subtitle: TextField(
  //             controller: rssSubLinkTextController,
  //           ),
  //         ),
  //         name == null
  //             ? ListTile(
  //                 title: Text("订阅名"),
  //                 subtitle: TextField(
  //                   controller: rssSubNameController,
  //                 ),
  //               )
  //             : Container(),
  //         ListTile(
  //           title: Text("显示名称"),
  //           subtitle: TextField(
  //             controller: rssSubShowNameController,
  //           ),
  //         ),
  //         ListTile(
  //           title: Text("订阅类型"),
  //           subtitle: // Column(
  //               // crossAxisAlignment: CrossAxisAlignment.start,
  //               // children: [
  //               // Text("当前：${_typeSelected(typeCode)}"),
  //               DropdownMenu(
  //             controller: TextEditingController(text: _typeSelected(typeCode)),
  //             dropdownMenuEntries: [
  //               DropdownMenuEntry(value: 0, label: 'Atom'),
  //               DropdownMenuEntry(value: 1, label: 'RSS 1.0'),
  //               DropdownMenuEntry(value: 2, label: 'RSS 2.0'),
  //             ],
  //             onSelected: (value) async {
  //               if (value == null) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text("无效的订阅类型"),
  //                   ),
  //                 );
  //                 return;
  //               }
  //               typeCode = value;
  //             },
  //           ),
  //           // ],
  //           // ),
  //         ),
  //       ],
  //     ),
  //     actions: [
  //       ElevatedButton(
  //         onPressed: () async => Get.close(0),
  //         child: Text('取消'),
  //       ),
  //       ElevatedButton(
  //         // 确定订阅逻辑
  //         onPressed: () async {
  //           if (rssSubLinkTextController.text.isEmpty) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text("请输入订阅链接"),
  //               ),
  //             );
  //             return;
  //           }
  //           if (name == null && rssSubNameController.text.isEmpty) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text("请输入订阅名"),
  //               ),
  //             );
  //             return;
  //           }
  //           if (typeCode == -1) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text("当前没有选择订阅类型，请选择"),
  //               ),
  //             );
  //             return;
  //           }
  //           progressbar.start();
  //           // 最终数据
  //           final rss = RSS(
  //             name: name ?? rssSubNameController.text,
  //             showName: rssSubShowNameController.text.isNotEmpty
  //                 ? rssSubShowNameController.text
  //                 : rssSubNameController.text,
  //             subscribeUrl: rssSubLinkTextController.text,
  //             type: typeCode,
  //             autoUpdate: true,
  //           );
  //           // 保存订阅
  //           RssStorage()
  //               .setRss(rssSubNameController.text, rss)
  //               .then((v) => rsctr.load());
  //           final res;
  //           try {
  //             res = await NetworkGetRss().get(rssSubLinkTextController.text);
  //           } catch (e, s) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text("无法请求订阅，请检查订阅链接是否正确或重试！"),
  //               ),
  //             );
  //             progressbar.finish();
  //             return;
  //           }
  //           //print(res);
  //           late final parsed;
  //           try {
  //             parsed = _parse(res, typeCode);
  //           } catch (e, s) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text("解析订阅失败，可能订阅类型有误，请重试！"),
  //               ),
  //             );
  //             progressbar.finish();
  //             return;
  //           }
  //           // print(parsed);
  //           RssCache.save(rss, res);
  //           progressbar.finish();
  //           Get.close(0);
  //           if (twiceClose) Get.close(0);
  //         },
  //         child: Text('确定'),
  //       ),
  //     ],
  //   );
  // }
}

class _RssSubController extends GetxController {
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
