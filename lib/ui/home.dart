import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/navigator_controller.dart';

import 'models/navigation_bar.dart';

class HomeUI extends StatelessWidget {
  HomeUI({super.key, required this.title});

  final String title;

  final NavigatorController nctr = Get.put(NavigatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: Center(),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}
