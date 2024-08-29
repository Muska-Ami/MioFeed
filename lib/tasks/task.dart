import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:miofeed/tasks/subscribe_update.dart';

class Task {
  static final _config = BackgroundFetchConfig(
    minimumFetchInterval: 15,
    stopOnTerminate: false,
    enableHeadless: true,
    requiresBatteryNotLow: false,
    requiresCharging: false,
    requiresStorageNotLow: false,
    requiresDeviceIdle: false,
    requiredNetworkType: NetworkType.ANY,
  );

  static Future<void> doConfigure() async {
    int status = await BackgroundFetch.configure(
      _config,
      _callbackHandler,
      _errorHandler,
    );
    print('[BackgroundFetch] configure success: $status');
  }

  static void _callbackHandler(String taskId) async {
    // <-- Event handler
    // This is the fetch-event callback.
    print("[BackgroundFetch] Event received $taskId");
    BackgroundFetch.finish(taskId);
  }

  static void _errorHandler(String taskId) async {
    // <-- Task timeout handler.
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    BackgroundFetch.finish(taskId);
  }

  static void register() {
    if (Platform.isAndroid) {
      BackgroundFetch.registerHeadlessTask(
        SubscribeUpdateTask.backgroundFetchHeadlessTask,
      );
    }
  }
}
