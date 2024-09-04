import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static Future<PackageInfo> get _instance async => await PackageInfo.fromPlatform();

  static late final String appVersion;
  static late final String appBuildNumber;
  static late final String appPackageName;

  static Future<void> init() async {
    appVersion = (await _instance).version;
    appBuildNumber = (await _instance).buildNumber;
    appPackageName = (await _instance).packageName;
  }
}