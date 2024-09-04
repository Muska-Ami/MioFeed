import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/storages/settings_storage.dart';
import 'package:miofeed/tasks/task.dart';
import 'package:miofeed/ui/home.dart';
import 'package:miofeed/ui/settings.dart';
import 'package:miofeed/ui/settings/about.dart';
import 'package:miofeed/ui/settings/render.dart';
import 'package:miofeed/ui/settings/rss_subscribe.dart';
import 'package:miofeed/ui/settings/theme.dart';
import 'package:miofeed/storages/rss/rss_cache.dart';
import 'package:miofeed/utils/app_info.dart';
import 'package:miofeed/utils/shared_data.dart';

const String title = "MioFeed";

late final bool _useMonet;
late final int _useThemeMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedData.init();
  await RssCache.readAllToRemCache();
  await AppInfo.init();

  await _initSelfConfig();
  Task.register();

  runApp(const MyApp());
}

// 初始化一些配置项目
_initSelfConfig() async {
  final settings = SettingsStorage();

  _useMonet = await settings.getThemeMonet() ?? true;
  _useThemeMode = await settings.getThemeMode() ?? 0;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 默认主题色种子
  static const _defaultColorSeed = Colors.blueAccent;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Task.doConfigure();
    Get.put(ProgressbarController());

    // 处理主题模式
    ThemeMode themeMode;
    switch (_useThemeMode) {
      case 1:
        themeMode = ThemeMode.light;
        break;
      case 2:
        themeMode = ThemeMode.dark;
        break;
      case 0:
      default:
        themeMode = ThemeMode.system;
    }

    // Monet 取色
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (_useMonet && lightDynamic != null && darkDynamic != null) {
          // 从系统获取
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // 不支持或者禁用了 Monet 取色，Fallback
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _defaultColorSeed,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _defaultColorSeed,
            brightness: Brightness.dark,
          );
        }
        return GetMaterialApp(
          title: 'MioFeed',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            fontFamily: 'Microsoft YaHei',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: darkColorScheme,
            fontFamily: 'Microsoft YaHei',
          ),
          themeMode: themeMode,
          routes: {
            '/home': (context) => HomeUI(title: title),
            '/settings': (context) => SettingsUI(title: title),
            '/settings/rss_subscribe': (context) =>
                const RssSubSettingUI(title: title),
            '/settings/theme': (context) => ThemeSettingUI(title: title),
            '/settings/render': (context) => RenderSettingUI(title: title),
            '/about': (context) => AboutUI(title: title),
          },
          home: HomeUI(title: title),
        );
      },
    );
  }
}
