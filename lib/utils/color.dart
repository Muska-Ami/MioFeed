import 'package:flutter/material.dart' as md;

class Color {
  /// 根据字符串生成一个颜色
  /// [string] 字符串
  static md.Color stringToColor(String string) {
    string = string.length > 20 ? string.substring(0, 20) : string;

    int hash = 0;
    for (int i = 0; i < string.length; i++) {
      hash = string.codeUnitAt(i) + ((hash << 5) - hash);
    }

    String colorString = '#';
    for (int i = 0; i < 3; i++) {
      int value = (hash >> (i * 8)) & 0xFF;
      colorString += value.toRadixString(16).padLeft(2, '0');
    }

    return md.Color(
      int.parse(colorString.substring(1), radix: 16) + 0xFF000000,
    );
  }
}
