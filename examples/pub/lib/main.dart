import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';

import 'search.dart';

void main() {
  runApp(const FstateScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SearchPage());
  }
}
