import 'package:flutter/material.dart';
import 'package:flutter_movie_app/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_movie',
      theme: ThemeData(
        primaryColor: const Color(0xFF1C306D),
        accentColor: const Color(0xFFFFAD32),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: MainPage(),
    );
  }
}


