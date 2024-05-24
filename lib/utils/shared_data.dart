import 'package:path_provider/path_provider.dart';

class SharedData {
  static late final String documentPath;

  static Future<void> _initPaths() async {
    documentPath = (await getApplicationDocumentsDirectory()).path;
  }

  static Future<void> init() async {
    _initPaths();
  }
}