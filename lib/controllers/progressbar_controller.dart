import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressbarController extends GetxController {
  var widget = Container().obs;

  _updateWidget(bool loading) {
    if (loading)
      widget.value = Container(
        child: LinearProgressIndicator(
          value: null,
        ),
      );
    else
      widget.value = Container();
  }

  start() => _updateWidget(true);
  finish() => _updateWidget(false);
}
