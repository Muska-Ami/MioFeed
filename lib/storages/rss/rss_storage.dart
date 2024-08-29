import 'dart:convert';

import 'package:miofeed/models/rss.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RssStorage {
  final _instance = SharedPreferences.getInstance();

  /// 设置RSS订阅信息
  Future<void> setRss(String key, RSS val) async {
    final rssList = (await getRssList()) ?? [];
    rssList.add(key);
    // 去重并写入
    _setRssList(rssList.toSet().toList());
    (await _instance).setString('rss_list@$key', json.encode(val.toJson()));
  }

  /// 获取RSS订阅信息
  Future<RSS> getRss(String key) async =>
      RSS.fromJson(json.decode((await _instance).getString('rss_list@$key')!));

  /// 移除RSS订阅信息
  removeRss(String key) async {
    final rssList = (await getRssList()) ?? [];
    rssList.remove(key);
    _setRssList(rssList.toSet().toList());
    (await _instance).remove('rss_list@$key');
  }

  Future<List<String>?> getRssList() async =>
      (await _instance).getStringList('rss_list');
  void _setRssList(List<String> list) async =>
      (await _instance).setStringList('rss_list', list);
}
