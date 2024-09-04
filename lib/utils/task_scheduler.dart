import 'package:miofeed/tasks/subscribe_update.dart';

class TaskScheduler {
  static Future<void> start() async {
    _taskSubscribeUpdate();
  }

  static _taskSubscribeUpdate() async {
    SubscribeUpdateTask().startUp(
      callback: () => Future.delayed(const Duration(minutes: 15), () {
        SubscribeUpdateTask().startUp();
      }),
    );
  }
}