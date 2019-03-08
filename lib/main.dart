import 'package:flutter/material.dart';
import 'package:flutter_movie_app/main_page.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter_movie_app/model/theater.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;

void main() async {
  //demo
//  api.DoubanAPI.internal().getMovieInfo(id: "26942674")
//      .then((MovieInfo movies){
//    print(movies.toString());
//  });

//  api.DoubanAPI.internal().getTheater(cityName: "Taipei")
//  .then((List<Theater> list){
//    print(list);
//  });

  runApp(MyApp());
}


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


