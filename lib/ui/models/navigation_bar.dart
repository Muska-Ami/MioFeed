import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigator_controller.dart';

class NavigationBarX {
  final NavigatorController nctr = Get.put(NavigatorController());

  build() => NavigationBar(
        selectedIndex: nctr.currentPage.value,
        onDestinationSelected: (index) async {
          nctr.currentPage.value = index;
          nctr.subCurrentPage.value = 0;
          switch (index) {
            case 0:
              // 首页
              Get.toNamed("/home");
            // return Material(child: HomeUI());
            case 1:
              // 设置
              Get.toNamed("/settings");
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "阅读"),
          NavigationDestination(icon: Icon(Icons.settings), label: "设置"),
        ],
      );
}
