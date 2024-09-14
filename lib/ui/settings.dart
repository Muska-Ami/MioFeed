import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigator_controller.dart';
import '../controllers/progressbar_controller.dart';
import 'models/navigation_bar.dart';

class SettingsUI extends StatelessWidget {
  SettingsUI({super.key, required this.title});

  final String title;

  final NavigatorController nctr = Get.put(NavigatorController());
  final ProgressbarController progressbar = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: ListView(
        children: [
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text("订阅设置"),
            ),
            onTap: () async {
              Get.toNamed('/settings/rss_subscribe');
            },
          ),
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.colorize),
              title: Text("主题设置"),
            ),
            onTap: () async {
              Get.toNamed('/settings/theme');
            },
          ),
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.view_in_ar),
              title: Text("渲染设置"),
            ),
            onTap: () async {
              Get.toNamed('/settings/render');
            },
          ),
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.info),
              title: Text("关于"),
            ),
            onTap: () async {
              Get.toNamed('/about');
            },
          ),
        ],
      ),
      bottomNavigationBar: navigationBar(),
    );
  }
}
