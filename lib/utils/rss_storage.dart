import 'dart:convert';

import 'package:miofeed/models/rss.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RssStorage {
  final _instance = SharedPreferences.getInstance();

  /// 设置RSS订阅信息
  setRss(String key, RSS val) async => (await _instance).setString('rss_list@$key', val.toJson().toString());
  /// 获取RSS订阅信息
  getRss(String key) async => RSS.fromJson(json.decode((await _instance).getString('rss_list@$key')!));
  /// 移除RSS订阅信息
  removeRss(String key) async => (await _instance).remove('rss_list@$key');
}