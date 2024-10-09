import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/ui/models/navigation_bar.dart';
import 'package:miofeed/utils/app_info.dart';

import '../../controllers/progressbar_controller.dart';

class AboutUI extends StatelessWidget {
  AboutUI({super.key, required this.title});

  final String title;

  final ProgressbarController _progressbar = Get.find();
  @override
  Widget build(BuildContext context) {
    int ic = 0;

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
      body: ListView(
        children: [
          InkWell(
            child: ListTile(
              title: Text(
                  'MioFeed 版本 ${AppInfo.appVersion}(+${AppInfo.appBuildNumber})'),
            ),
            onTap: () async {},
          ),
          InkWell(
            child: ListTile(
              title: Text(
                  '平台 ${Platform.operatingSystem} ${Platform.operatingSystemVersion}'),
            ),
            onTap: () async {
              ic++;
              if (ic == 10) {
                Get.dialog(
                  SimpleDialog(
                    children: [
                      ListTile(
                        title: const Text(
                            '🏳️‍🌈🏳‍⚧ 无论身陷何处，无论世界如何，终将对你温柔以待❤🧡💛💚💙💜。'),
                        subtitle: Container(
                          alignment: Alignment.bottomRight,
                          child: const Text('—— Author of MioFeed'),
                        ),
                      ),
                    ],
                  ),
                );
                ic = 0;
              }
            },
          ),
          InkWell(
            child: ListTile(
              title: Text('包名 ${AppInfo.appPackageName}'),
            ),
            onTap: () async {},
          ),
        ],
      ),
      bottomNavigationBar: navigationBar(),
    );
  }
}
