import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/main.dart';
import 'package:miofeed/models/universal_item.dart';
import 'package:miofeed/ui/models/navigation_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: Text(
            '$title - ${data.title.length < 7 ? data.title : '${data.title.substring(0, 7)}...'}'),
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
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(fontSize: 30),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.supervised_user_circle,
                      size: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(_buildAuthorText()),
                    ),
                  ],
                ),
                _buildLabels(data.categories ?? []),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                SelectionArea(
                  child: HtmlWidget(
                    data.content,
                    onTapUrl: (url) => launchUrl(Uri.parse(url)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }

  String _buildAuthorText() {
    String s = '';
    for (var author in data.authors) {
      s += ' $author';
    }
    s = s.isEmpty ? '未知作者' : s.substring(1, s.length);
    return s;
  }

  Widget _buildLabels(List<String> data) {
    String labels = '';
    for (var label in data) {
      labels += ' | $label';
    }
    labels = labels.isEmpty
        ? '没有分类信息'
        : labels.length > 3
            ? labels.substring(3, labels.length)
            : labels;
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(
            // color: Get.theme.disabledColor,
            Icons.category,
            size: 18,
          ),
        ),
        Text(
          labels,
          // style: TextStyle(
          //   color: Get.theme.disabledColor,
          // ),
        ),
      ],
    );
  }
}
