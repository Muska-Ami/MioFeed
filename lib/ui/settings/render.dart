import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/storages/settings_storage.dart';
import 'package:miofeed/utils/after_layout.dart';

import '../../controllers/progressbar_controller.dart';
import '../models/navigation_bar.dart';

class RenderSettingUI extends StatelessWidget {
  RenderSettingUI({super.key, required this.title});

  final String title;

  final _RenderSettingsController _ctr = Get.put(_RenderSettingsController());
  final ProgressbarController _progressbar = Get.find();
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
            child: Obx(() => _progressbar.widget.value),
          ),
        ),
      ),
      body: AfterLayout(
        callback: (RenderAfterLayout ral) {
          _ctr.load();
        },
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.width_wide),
              title: Row(
                children: [
                  const Text('文章正文左右间距'),
                  Expanded(child: Container()),
                  Obx(() => Switch(
                        value: _ctr.renderLimitWidth.value,
                        onChanged: (v) async {
                          _ctr._settings.setRenderLimitWidth(v);
                          _ctr.renderLimitWidth.value = v;
                        },
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Obx(
                () => Visibility(
                  visible: _ctr.renderLimitWidth.value,
                  child: ListTile(
                    title: Row(
                      children: [
                        const Text('文章正文左右间距'),
                        Expanded(child: Container()),
                        Obx(() => Slider(
                              value: _ctr.renderLimitWidthValue.value,
                              onChanged: (v) async {
                                _ctr.renderLimitWidthValue.value = v;
                              },
                              onChangeEnd: (v) async {
                                _ctr._settings.setRenderLimitWidthValue(v);
                              },
                              label: _ctr.renderLimitWidthValue.value.toString(),
                              min: 100,
                              max: 500,
                              divisions: 400,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const ListTile(
            //   leading: Icon(Icons.view_in_ar),
            //   title: Text("渲染设置"),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: navigationBar(),
    );
  }
}

class _RenderSettingsController extends GetxController {
  final _settings = SettingsStorage();

  var renderLimitWidth = false.obs;
  RxDouble renderLimitWidthValue = 100.0.obs;

  load() async {
    await _initValues();
  }

  _initValues() async {
    renderLimitWidth.value = await _settings.getRenderLimitWidth() ?? false;
    renderLimitWidthValue.value =
        await _settings.getRenderLimitWidthValue() ?? 100.0;
  }
}
