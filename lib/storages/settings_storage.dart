import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  final _instance = SharedPreferences.getInstance();

  /// 主题模式
  /// [value] [0..2] => System,Light,Dark
  void setThemeMode(int value) async {
    switch (value) {
      case 0:
      case 1:
      case 2:
        (await _instance).setInt(_MAP.THEME_MODE, value);
      default:
        throw UnsupportedError(
            'Invalid input! Expected [0..2], but got $value!');
    }
  }

  Future<int?> getThemeMode() async =>
      (await _instance).getInt(_MAP.THEME_MODE);

  /// Monet 取色开关
  void setThemeMonet(bool value) async {
    (await _instance).setBool(_MAP.THEME_MONET, value);
  }

  Future<bool?> getThemeMonet() async =>
      (await _instance).getBool(_MAP.THEME_MONET);
}

class _MAP {
  static const THEME_MODE = 'settings@theme.mode';
  static const THEME_MONET = 'settings@theme.monet';
}
