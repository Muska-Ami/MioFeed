import 'package:get/get.dart';
import 'package:miofeed/utils/rss/rss_utils.dart';

class HomeController extends GetxController {
  var allParagraph = [].obs;

  load() {
    allParagraph.value = RssUtils.allRssParagraph;
  }
}
