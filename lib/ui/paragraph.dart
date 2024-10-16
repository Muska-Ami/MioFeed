import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/main.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/models/universal_item.dart';
import 'package:miofeed/storages/settings_storage.dart';
import 'package:miofeed/ui/models/navigation_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:miofeed/utils/after_layout.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/paragraph_utils.dart';

class ParagraphUI extends StatelessWidget {
  ParagraphUI({
    super.key,
    // this.title,
    required this.data,
    required this.parent,
  });

  // final title;
  final UniversalItem data;
  final UniversalFeed parent;

  final ProgressbarController _progressbar = Get.find();
  final _ParagraphUIController _ctr = Get.put(_ParagraphUIController());

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return AfterLayout(
      callback: (RenderAfterLayout ral) {
        _ctr.load();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '$title - ${data.title.length < 7 ? data.title : '${data.title.substring(0, 7)}...'}'),
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 3),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 3,
              child: Obx(() => _progressbar.widget.value),
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
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: parent.icon.isNotEmpty
                                  ? Image.network(
                                      parent.icon,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return ParagraphUtils.buildColorIcon(
                                            parent.title);
                                      },
                                    )
                                  : ParagraphUtils.buildColorIcon(
                                      parent.title)),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${parent.title} | ${data.publishTime != null ? dateFormatter.format(data.publishTime!) : '未知'}',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
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
                    child: Obx(() => SizedBox(
                          width: _ctr.renderLimitWidth.value
                              ? MediaQuery.of(context).size.width -
                                  _ctr.renderLimitWidthValue.value
                              : null,
                          child: HtmlWidget(
                            data.content,
                            onTapUrl: (url) => launchUrl(Uri.parse(url)),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Text(
                            '发布时间: ${data.publishTime != null ? dateFormatter.format(data.publishTime!) : '未知'}'),
                        Text(
                            '更新时间: ${data.updateTime != null ? dateFormatter.format(data.publishTime!) : '未知'}'),
                        if (data.generator != null)
                          Text('Generated by ${data.generator}')
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.link),
                        onPressed: data.link != null
                            ? () {
                                launchUrl(Uri.parse(data.link!));
                              }
                            : null,
                        tooltip: '访问网站',
                      ),
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.share),
                        onPressed: data.link != null
                            ? () {
                                Share.share('${data.title} - ${data.link!}');
                              }
                            : null,
                        tooltip: '分享',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: navigationBar(),
      ),
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

class _ParagraphUIController extends GetxController {
  final _settings = SettingsStorage();

  var renderLimitWidth = false.obs;
  RxDouble renderLimitWidthValue = 0.0.obs;

  load() async {
    await _initValues();
  }

  _initValues() async {
    renderLimitWidth.value = await _settings.getRenderLimitWidth() ?? false;
    renderLimitWidthValue.value =
        await _settings.getRenderLimitWidthValue() ?? 0.0;
  }
}
