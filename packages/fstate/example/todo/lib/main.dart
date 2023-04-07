import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:todo/src/page/main/main_page.dart';

void main() {
  runApp(const FstateScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}
