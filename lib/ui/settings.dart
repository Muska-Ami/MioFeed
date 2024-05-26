import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigator_controller.dart';
import 'models/navigation_bar.dart';

class SettingsUI extends StatelessWidget {
  SettingsUI({super.key, required this.title});

  final String title;

  final NavigatorController nctr = Get.put(NavigatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: ListView(
        children: [
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text("订阅设置"),
            ),
            onTap: () async {
              Get.toNamed('/settings/rss_sub');
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
        ],
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}
