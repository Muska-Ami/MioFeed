import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SharedData {
  /// 文档目录
  static late final String documentPath;

  static Future<void> _initPaths() async {
    documentPath = (await getApplicationDocumentsDirectory()).path + '/MioFeed';
    final dir = await Directory(documentPath);
    if (!(await dir.exists())) await dir.create();
  }

  static Future<void> init() async {
    _initPaths();
  }
}
