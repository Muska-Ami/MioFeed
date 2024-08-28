import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miofeed/controllers/progressbar_controller.dart';
import 'package:miofeed/ui/home.dart';
import 'package:miofeed/ui/settings.dart';
import 'package:miofeed/ui/settings/render.dart';
import 'package:miofeed/ui/settings/rss_sub.dart';
import 'package:miofeed/ui/settings/theme.dart';
import 'package:miofeed/utils/rss/rss_cache.dart';
import 'package:miofeed/utils/shared_data.dart';

const String title = "MioFeed";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedData.init();
  await RssCache.readAllToRemCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 默认主题色种子
  static const _defaultColorSeed = Colors.blueAccent;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(ProgressbarController());
    // Monet 取色
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // lightColorScheme = lightColorScheme.copyWith(secondary: _defaultColorSeed);
          // (Optional) If applicable, harmonize custom colors.
          // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
          // darkColorScheme = darkColorScheme.copyWith(secondary: _defaultColorSeed);
          // darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
        } else {
          // Fallback
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
          themeMode: ThemeMode.system,
          routes: {
            '/home': (context) => HomeUI(title: title),
            '/settings': (context) => SettingsUI(title: title),
            '/settings/rss_sub': (context) =>
                const RssSubSettingUI(title: title),
            '/settings/theme': (context) => ThemeSettingUI(title: title),
            '/settings/render': (context) => RenderSettingUI(title: title),
          },
          home: HomeUI(title: title),
        );
      },
    );
  }
}
