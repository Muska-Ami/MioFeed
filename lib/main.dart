import 'package:flutter/material.dart';
import 'package:miofeed/ui/home.dart';
import 'package:miofeed/utils/shared_data.dart';

const String title = "MioFeed";

void main() async {
  await SharedData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MioFeed',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeUI(title: title),
    );
  }
}
