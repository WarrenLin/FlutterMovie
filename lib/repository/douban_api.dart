
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_movie_app/model/theater.dart';

class DoubanAPI {
  static final DoubanAPI _internal = DoubanAPI.internal();
  factory DoubanAPI() => _internal;
  Dio _dio;
  final _fetchCount = 10;

  BaseOptions _options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000
  );

  DoubanAPI.internal() {
    _dio = new Dio(_options);
  }

  Future<Response<T>> _dioGet<T>(String path) async {
    print("dioGet:$path");
    return Future.value(_dio.get(path));
  }

  Future<Movies> getInTheaters({int startIndex}) async{
    var path = new StringBuffer("https://api.douban.com/v2/movie/in_theaters" + "?");
    path.write("start=$startIndex");
    path.write("&count=$_fetchCount");
    print("getInTheaters:${path.toString()}");
    Response response = await _dioGet(path.toString());
    return Movies.from(response.data);
  }

  Future<Movies> search({String keyword, int startIndex}) async {
    var path = new StringBuffer("https://api.douban.com/v2/movie/search" + "?");
    path.write("q=$keyword");
    path.write("&start=$startIndex");
    path.write("&count=$_fetchCount");
    print("search:${path.toString()}");
    Response response = await _dioGet(path.toString());
    print(response.data.toString());
    return Movies.from(response.data);
  }

  Future<MovieInfo> getMovieInfo({String id}) async{
    var path = new StringBuffer("https://api.douban.com/v2/movie/subject/");
    path.write("$id");
    print("getMovieInfo:${path.toString()}");
    Response response = await _dioGet(path.toString());
    print(response.data.toString());
    return MovieInfo.from(response.data);
  }

  Future<Map<String, dynamic>> getTheater() async {
    return parseJsonFromAssets('assets/data/theater.json');
//    Map<String, dynamic> dmap = await parseJsonFromAssets('assets/data/theater.json');
//    return (dmap[cityName] as List).map((value) => Theater.from(value)).toList();
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }
}