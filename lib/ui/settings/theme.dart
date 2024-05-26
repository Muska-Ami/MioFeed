import 'package:flutter/material.dart';

import '../models/navigation_bar.dart';

class ThemeSettingUI extends StatelessWidget {
  ThemeSettingUI({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('test'),
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}