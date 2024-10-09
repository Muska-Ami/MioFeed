import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  final _instance = SharedPreferences.getInstance();

  // 主题配置
  /// 主题模式
  /// [value] [0..2] => System,Light,Dark
  void setThemeMode(int value) async {
    switch (value) {
      case 0:
      case 1:
      case 2:
        (await _instance).setInt(_MAP.THEME_MODE, value);
      default:
        throw UnsupportedError('Invalid input! Expected [0..2], but got $value!');
    }
  }
  Future<int?> getThemeMode() async => (await _instance).getInt(_MAP.THEME_MODE);

  /// Monet 取色开关
  void setThemeMonet(bool value) async => (await _instance).setBool(_MAP.THEME_MONET, value);
  Future<bool?> getThemeMonet() async => (await _instance).getBool(_MAP.THEME_MONET);

  // 渲染配置
  /// 限制最大渲染宽度
  void setRenderLimitWidth(bool value) async => (await _instance).setBool(_MAP.RENDER_LIMIT_WIDTH, value);
  Future<bool?> getRenderLimitWidth() async => (await _instance).getBool(_MAP.RENDER_LIMIT_WIDTH);
  void setRenderLimitWidthValue(double value) async => (await _instance).setDouble(_MAP.RENDER_LIMIT_WIDTH_VALUE, value);
  Future<double?> getRenderLimitWidthValue() async => (await _instance).getDouble(_MAP.RENDER_LIMIT_WIDTH_VALUE);
}

class _MAP {
  static const THEME_MODE = 'settings@theme.mode';
  static const THEME_MONET = 'settings@theme.monet';

  static const RENDER_LIMIT_WIDTH = 'settings@render.limit-width';
  static const RENDER_LIMIT_WIDTH_VALUE = 'settings@render.limit-width.value';
}
