import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/storages/settings_storage.dart';

import '../../controllers/progressbar_controller.dart';
import '../../utils/after_layout.dart';
import '../models/navigation_bar.dart';

class ThemeSettingUI extends StatelessWidget {
  ThemeSettingUI({super.key, required this.title});

  final String title;

  final _ThemeSettingsController _ctr = Get.put(_ThemeSettingsController());
  final ProgressbarController progressbar = Get.find();

  @override
  Widget build(BuildContext context) {
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
      body: AfterLayout(
        callback: (RenderAfterLayout ral) {
          _ctr.load();
        },
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Card(
                elevation: 0,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text('在修改主题配置后，您需要重启软件才能看到更改。'),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.invert_colors),
              title: Row(
                children: [
                  const Text("Monet 取色"),
                  Expanded(child: Container()),
                  Obx(() => Switch(
                        value: _ctr.themeMonet.value,
                        onChanged: (v) async {
                          _ctr._settings.setThemeMonet(v);
                          _ctr.themeMonet.value = v;
                        },
                      )),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Row(
                children: [
                  const Text("主题模式"),
                  Expanded(child: Container()),
                  Obx(() => PopupMenuButton<_ThemeMode>(
                        initialValue: _ctr.themeMode.value,
                        onSelected: (v) async {
                          _ctr.themeMode.value = v;
                          switch (v) {
                            case _ThemeMode.system:
                              _ctr._settings.setThemeMode(0);
                              break;
                            case _ThemeMode.light:
                              _ctr._settings.setThemeMode(1);
                              break;
                            case _ThemeMode.dark:
                              _ctr._settings.setThemeMode(2);
                              break;
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              _getThemeModeText(_ctr.themeMode.value),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: const Icon(Icons.api),
                            ),
                          ],
                        ),
                        itemBuilder: (context) => <PopupMenuEntry<_ThemeMode>>[
                          const PopupMenuItem(
                            value: _ThemeMode.system,
                            child: Text('跟随系统'),
                          ),
                          const PopupMenuItem(
                            value: _ThemeMode.light,
                            child: Text('亮色模式'),
                          ),
                          const PopupMenuItem(
                            value: _ThemeMode.dark,
                            child: Text('暗色模式'),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            // const ListTile(
            //   leading: Icon(Icons.view_in_ar),
            //   title: Text("渲染设置"),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }

  _getThemeModeText(v) {
    switch (v) {
      case _ThemeMode.system:
        return '跟随系统';
      case _ThemeMode.light:
        return '亮色模式';
      case _ThemeMode.dark:
        return '暗色模式';
    }
  }
}

enum _ThemeMode { system, light, dark }

class _ThemeSettingsController extends GetxController {
  final _settings = SettingsStorage();

  var themeMonet = false.obs;
  Rx<_ThemeMode> themeMode = _ThemeMode.light.obs;

  load() async {
    themeMonet.value = await _settings.getThemeMonet() ?? true;
    switch (await _settings.getThemeMode()) {
      case 1:
        themeMode.value = _ThemeMode.light;
        break;
      case 2:
        themeMode.value = _ThemeMode.dark;
        break;
      case 0:
      default:
        themeMode.value = _ThemeMode.system;
    }
  }
}
