import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/Login.dart';
import 'package:quiz_app/Splash.dart';

import 'Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData.dark(),
      home: Splash(),
      // home: Login(),
    );
  }
}