import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/progressbar_controller.dart';
import '../models/navigation_bar.dart';

class ThemeSettingUI extends StatelessWidget {
  ThemeSettingUI({super.key, required this.title});

  final String title;

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
      body: Center(
        child: Text('test'),
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}
