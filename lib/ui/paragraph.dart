import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/models/universal_item.dart';
import 'package:miofeed/ui/models/navigation_bar.dart';

class ParagraphUI extends StatelessWidget {
  ParagraphUI({
    super.key,
    // this.title,
    required this.data,
  });

  // final title;
  final UniversalItem data;

  final ProgressbarController progressbar = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(data.title.length < 15
            ? data.title
            : '${data.title.substring(0, 15)}...'),
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

        ],
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}
