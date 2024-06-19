import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/ui/home.dart';
import 'package:miofeed/ui/settings.dart';
import 'package:miofeed/ui/settings/rss_sub.dart';
import 'package:miofeed/ui/settings/theme.dart';
import 'package:miofeed/utils/shared_data.dart';

const String title = "MioFeed";

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SharedData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(ProgressbarController());
    return GetMaterialApp(
      title: 'MioFeed',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueAccent),
      routes: {
        '/home': (context) => HomeUI(title: title),
        '/settings': (context) => SettingsUI(title: title),
        '/settings/rss_sub': (context) => RssSubSettingUI(title: title),
        '/settings/theme': (context) => ThemeSettingUI(title: title),
      },
      home: HomeUI(title: title),
    );
  }
}
