import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/navigator_controller.dart';
import 'package:miofeed/models/universal_item.dart';
import 'package:miofeed/utils/after_layout.dart';

import '../controllers/progressbar_controller.dart';
import '../utils/rss/rss_utils.dart';
import 'models/navigation_bar.dart';

class HomeUI extends StatelessWidget {
  HomeUI({super.key, required this.title});

  final String title;

  final contentRegExp = RegExp(r'<[^>]*>|&[^;]+;');

  final NavigatorController nctr = Get.put(NavigatorController());
  final ProgressbarController progressbar = Get.find();

  @override
  Widget build(BuildContext context) {
    final _HomeController hctr = Get.put(_HomeController());

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
      body: AfterLayout(
        callback: (RenderAfterLayout ral) {
          hctr.load();
        },
        child: hctr.allParagraph.isNotEmpty
            ? Obx(
                () => Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: ListView.builder(
                    itemCount: hctr.allParagraph.length,
                    itemBuilder: (context, index) {
                      final para = hctr.allParagraph[index];
                      final UniversalItem paraData = para['item'];

                      final paraDesc = paraData.content.replaceAll(
                        contentRegExp,
                        ' ',
                      ).trim();

                      return Card(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                paraData.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(paraDesc.length <= 320
                                    ? paraDesc
                                    : '${paraDesc.substring(0, 320)}......'),
                              ),
                              _buildLabels(paraData.categories ?? []),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const Center(
                child: Text('空空如也 ￣△￣'),
              ),
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }

  Widget _buildLabels(List<String> data) {
    String labels = '';
    for (var label in data) {
      labels += ' | $label';
    }
    labels = labels.length > 3 ? labels.substring(3, labels.length) : labels;
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: Icon(
            color: Get.theme.disabledColor,
            Icons.category,
            size: 18,
          ),
        ),
        Text(
          labels,
          style: TextStyle(
            color: Get.theme.disabledColor,
          ),
        ),
      ],
    );
  }
}

class _HomeController extends GetxController {
  var allParagraph = [].obs;

  load() {
    allParagraph.value = RssUtils.allRssParagraph;
  }
}
