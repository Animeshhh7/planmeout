import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planmeout/pages/home_page.dart';

void main() async {
  // initializing hive
  await Hive.initFlutter();

  // opening a box
  await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
