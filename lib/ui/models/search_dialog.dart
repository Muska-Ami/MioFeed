import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:miofeed/models/search_data.dart';
import 'package:miofeed/models/universal_feed.dart';
import 'package:miofeed/models/universal_item.dart';
import 'package:miofeed/ui/paragraph.dart';
import 'package:miofeed/utils/rss/rss_utils.dart';

searchDialog(BuildContext context) {
  void toReadPage(UniversalItem paraData, UniversalFeed paraFeed) {
    Get.to(() => ParagraphUI(
          data: paraData,
          parent: paraFeed,
        ));
  }

  final controller = Get.put(_SearchController());
  final dataParagraph = RssUtils.allRssParagraph;
  controller.hasSearch.value = false;
  controller.searchData.clear();
  return SimpleDialog(
    backgroundColor: Colors.black.withOpacity(0),
    children: [
      SearchBar(
        onChanged: (value) async {
          controller.hasSearch.value = true;
          controller.searchData.clear();
          if (value != '') {
            // 遍历文章数据
            for (var paraInfo in dataParagraph) {
              final UniversalItem item = paraInfo['item'];
              final UniversalFeed feed = paraInfo['feed_data'];

              final String title = item.title;
              final String description = item.content
                  .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                  .replaceAll(RegExp(r'\n{2,}'), ' ')
                  .replaceAll(RegExp(r'\r{2,}'), ' ')
                  .replaceAll(RegExp(r' {2,}'), ' ')
                  .trim();

              bool matchTitle = false;
              String? outputTitle;
              bool matchContent = false;
              List<String>? outputContent;

              // 标题匹配
              if (title.contains(value)) {
                matchTitle = true;
                outputTitle = title.replaceAll(value, "**$value**");
                print(outputTitle);
              }
              // 内容匹配
              if (description.contains(value)) {
                matchContent = true;
                // 使用正则表达式匹配 value
                RegExp regExp = RegExp(
                  '(.{0,17}$value.{0,17})',
                  unicode: true, // 确保处理中文字符
                );
                description.replaceAll(value, "**$value**");
                Iterable<RegExpMatch> matches = regExp.allMatches(description);
                outputContent = [];
                for (var match in matches) {
                  if (match.group(0) != null) {
                    outputContent.add(match.group(0)!);
                  }
                }
                print(outputContent);
                controller.searchData.add(
                  SearchData(
                    matchTitle: matchTitle,
                    matchContent: matchContent,
                    paraData: item,
                    paraFeed: feed,
                    title: outputTitle,
                    contentMatched: outputContent,
                  ),
                );
              }
            }
            print(controller.searchData.length);
          } else {
            controller.hasSearch.value = false;
            controller.searchData.clear();
          }
        },
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: Obx(
              () => controller.hasSearch.value
                  ? ListView.builder(
                      itemCount: controller.searchData.length,
                      itemBuilder: (BuildContext context, int i) {
                        final item = controller.searchData[i];
                        List<Widget> contents = [];

                        if (item.matchContent) {
                          for (var c in item.contentMatched!) {
                            contents.add(MarkdownBody(data: c));
                          }
                        }

                        return controller.searchData.isNotEmpty
                            ? item.matchTitle
                                ? InkWell(
                                    child: ListTile(
                                      title: MarkdownBody(data: item.title!),
                                      shape: const Border(
                                        top: BorderSide(color: Colors.black12),
                                        bottom:
                                            BorderSide(color: Colors.black12),
                                      ),
                                      subtitle: contents.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: contents,
                                            )
                                          : null,
                                    ),
                                    onTap: () async => toReadPage(
                                      item.paraData,
                                      item.paraFeed,
                                    ),
                                  )
                                : InkWell(
                                    child: ListTile(
                                      title: contents.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: contents,
                                            )
                                          : null,
                                      shape: const Border(
                                        top: BorderSide(color: Colors.black12),
                                        bottom:
                                            BorderSide(color: Colors.black12),
                                      ),
                                    ),
                                    onTap: () async => toReadPage(
                                      item.paraData,
                                      item.paraFeed,
                                    ),
                                  )
                            : Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 40),
                                  child: const Text('什么也没搜到...'),
                                ),
                              );
                      })
                  : Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: const Text('来搜点什么吧...'),
                      ),
                    ),
              // child: ListView(
              //   children: [
              //     Center(
              //       child: Container(
              //         margin: const EdgeInsets.only(top: 40),
              //         child: const Text('来搜点什么吧...'),
              //       ),
              //     )
              //   ],
              // ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _SearchController extends GetxController {
  var hasSearch = false.obs;
  var searchData = <SearchData>[].obs;
}
