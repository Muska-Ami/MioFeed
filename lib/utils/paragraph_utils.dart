import 'package:flutter/material.dart';
import 'package:miofeed/utils/color.dart' as color_utils;

class ParagraphUtils {
  /// 通过订阅名生成文字图标
  static Widget buildColorIcon(String subName) {
    return Container(
      color: color_utils.Color.stringToColor(subName),
      child: Center(child: Text(subName.substring(0, 1))),
    );
  }
}