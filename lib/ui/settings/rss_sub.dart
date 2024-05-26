import 'package:flutter/material.dart';

import '../models/navigation_bar.dart';

class RssSubSettingUI extends StatelessWidget {
  RssSubSettingUI({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.add),
              title: Text('添加新订阅...'),
            ),
            onTap: () async {
              //TODO: Add RSS sub
            },
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.bookmark_added),
                  title: Text("已订阅"),
                ),
                ListTile(
                  title: Text('demo sub'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarX().build(),
    );
  }
}
