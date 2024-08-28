import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/navigator_controller.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/models/universal_item.dart';
import 'package:miofeed/ui/paragraph.dart';
import 'package:miofeed/utils/after_layout.dart';
import 'package:miofeed/utils/paragraph_utils.dart';

import '../controllers/progressbar_controller.dart';
import '../utils/rss/rss_utils.dart';
import 'models/navigation_bar.dart';

class HomeUI extends StatelessWidget {
  HomeUI({super.key, required this.title});

  final String title;

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
      body: Obx(
        () => AfterLayout(
          callback: (RenderAfterLayout ral) {
            hctr.load();
          },
          child: hctr.allParagraph.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: ListView.builder(
                    itemCount: hctr.allParagraph.length,
                    itemBuilder: (context, index) {
                      final para = hctr.allParagraph[index];
                      final UniversalItem paraData = para['item'];
                      final UniversalFeed paraFeed = para['feed_data'];

                      // print(paraIconUrl);

                      final paraDesc = paraData.content
                          .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                          .replaceAll(RegExp(r'\n{2,}'), ' ')
                          .replaceAll(RegExp(r'\r{2,}'), ' ')
                          .replaceAll(RegExp(r' {2,}'), ' ')
                          .trim();

                      return InkWell(
                        onTap: () async {
                          Get.to(() => ParagraphUI(
                                data: paraData,
                                parent: paraFeed,
                              ));
                        },
                        child: Card(
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
                                Row(
                                  children: [
                                    // 图标
                                    Tooltip(
                                      message: paraFeed.title,
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: paraFeed.icon.isNotEmpty
                                                ? Image.network(
                                                    paraFeed.icon,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return ParagraphUtils
                                                          .buildColorIcon(
                                                        paraFeed.title,
                                                      );
                                                    },
                                                  )
                                                : ParagraphUtils.buildColorIcon(
                                                    paraFeed.title,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    _buildLabels(paraData.categories ?? []),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('空空如也 ￣△￣'),
                ),
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
    if (labels.isEmpty) labels = '没有分类信息';
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
    final dataParagraph = RssUtils.allRssParagraph;
    dataParagraph.sort((a, b) {
      // TODO: 正序还是倒序显示文章
      final aTime = a['item'].publishTime ?? DateTime(0);
      final bTime = b['item'].publishTime ?? DateTime(0);
      final result = bTime.compareTo(aTime);
      // print('${b['item'].title} $bTime, ${a['item'].title} $aTime, RES: $result');
      return result;
    });
    allParagraph.clear();
    // 使用异步方法添加文章，避免大量文章导致UI卡顿
    dataParagraph.forEach((item) async {
      allParagraph.add(item);
      allParagraph.refresh();
    });
  }
}
