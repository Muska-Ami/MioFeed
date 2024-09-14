import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigator_controller.dart';

  final NavigatorController _nCtr = Get.put(NavigatorController());

  navigationBar() => NavigationBar(
        selectedIndex: _nCtr.currentPage.value,
        onDestinationSelected: (index) async {
          _nCtr.currentPage.value = index;
          _nCtr.subCurrentPage.value = 0;
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
