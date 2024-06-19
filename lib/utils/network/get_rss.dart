import 'package:dio/dio.dart';

class NetworkGetRss {
  Future<String> get(subUrl) async {
    final instance = Dio();

    final res = await instance.get(subUrl);
    String resFeed = res.data;
    return resFeed;
  }
}
