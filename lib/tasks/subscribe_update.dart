import 'package:background_fetch/background_fetch.dart';

class SubscribeUpdateTask {
  @pragma('vm:entry-point')
  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      // This task has exceeded its allowed running-time.
      // You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    print('[BackgroundFetch] Headless event received.');
    // Do your work here...
    BackgroundFetch.finish(taskId);
  }
}

  // void _onClickEnable(enabled) {
  //   setState(() {
  //     _enabled = enabled;
  //   });
  //   if (enabled) {
  //     BackgroundFetch.start().then((int status) {
  //       print('[BackgroundFetch] start success: $status');
  //     }).catchError((e) {
  //       print('[BackgroundFetch] start FAILURE: $e');
  //     });
  //   } else {
  //     BackgroundFetch.stop().then((int status) {
  //       print('[BackgroundFetch] stop success: $status');
  //     });
  //   }
  // }
  //
  // void _onClickStatus() async {
  //   int status = await BackgroundFetch.status;
  //   print('[BackgroundFetch] status: $status');
  //   setState(() {
  //     _status = status;
  //   });
  // }