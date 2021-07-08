import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        accentColor: Colors.red.shade800,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        accentColor: Colors.red.shade800,
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}
