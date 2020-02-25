import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_movie_app/model/celebrity.dart';
import 'package:flutter_movie_app/model/movie_comment.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter/services.dart' show rootBundle;

class DoubanAPI {
  static final DoubanAPI _internal = DoubanAPI.internal();

  factory DoubanAPI() => _internal;
  Dio _dio;
  final _fetchCount = 10;

  BaseOptions _options =
      new BaseOptions(connectTimeout: 5000, receiveTimeout: 5000);

  DoubanAPI.internal() {
    _dio = new Dio(_options);
  }

  Future<Response<T>> _dioGet<T>(String path) async {
    print("dioGet:$path");
    return Future.value(_dio.get(path));
  }

  Future<Movies> getInTheaters({int startIndex}) async {
    var path =
        new StringBuffer("https://api.douban.com/v2/movie/in_theaters" + "?apikey=0df993c66c0c636e29ecbb5344252a4a&");
    path.write("start=$startIndex");
    path.write("&count=$_fetchCount");
    print("getInTheaters:${path.toString()}");
    Response response = await _dioGet(path.toString());
    return Movies.from(response.data);
  }

  Future<Movies> search({String keyword, int startIndex}) async {
    var path = new StringBuffer("https://api.douban.com/v2/movie/search" + "?apikey=0df993c66c0c636e29ecbb5344252a4a&");
    path.write("q=$keyword");
    path.write("&start=$startIndex");
    path.write("&count=$_fetchCount");
    print("search:${path.toString()}");
    Response response = await _dioGet(path.toString());
    print(response.data.toString());
    return Movies.from(response.data);
  }

  ///取得完整電影資訊(包含劇照)，需要有apiKey，若失效則call getMovieInfo
  Future<MovieInfo> getFullMoveInfo({String id}) async {
    final requestCount = 10;
    final requestApiKey = "0df993c66c0c636e29ecbb5344252a4a";
    var path = StringBuffer(
        "https://api.douban.com/v2/movie/subject/$id/photos?count=$requestCount&apikey=$requestApiKey");
    print("getFullMoveInfo:${path.toString()}");
    try {
      Response response = await _dioGet(path.toString());
      print(response.data.toString());
      MovieInfo movieInfo = MovieInfo.from(response.data["subject"]);
      List list = response.data["photos"];
      if (list != null) {
        var photos = list.map((jsonObj) => jsonObj["image"] as String).toList();
        print("photos : $photos");
        movieInfo.setPhotos(photos);
      }

      ///call getMovieInfo 取得電影summary
      movieInfo.summary = (await getMovieInfo(id: id)).summary;
      return movieInfo;
    } catch (e) {
      print("getFullMoveInfo error");
      return getMovieInfo(id: id);
    }
  }

  Future<MovieInfo> getMovieInfo({String id}) async {
    var path = new StringBuffer("https://api.douban.com/v2/movie/subject/");
    final requestApiKey = "0df993c66c0c636e29ecbb5344252a4a";
    path.write("$id");
    path.write("?apikey=$requestApiKey");

    print("getMovieInfo:${path.toString()}");
    Response response = await _dioGet(path.toString());
    print(response.data.toString());
    return MovieInfo.from(response.data);
  }

  Future<Map<String, dynamic>> getTheater() async {
    return parseJsonFromAssets('assets/data/theater.json');
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  Future<CelebrityInfo> getCelebrityInfo({String castId}) async {
    var path = new StringBuffer("https://api.douban.com/v2/movie/celebrity/");
    path.write("$castId");
    final requestApiKey = "0df993c66c0c636e29ecbb5344252a4a";
    path.write("?apikey=$requestApiKey");

    print("getCelebrityInfo:${path.toString()}");
    Response response = await _dioGet(path.toString());
    print(response.data.toString());
    return CelebrityInfo.from(response.data);
  }

  ///獲取電影條目短評論
  Future<MovieComment> getMovieComment({String movieId, int start}) async {
    final requestCount = 20;
    final requestApiKey = "0df993c66c0c636e29ecbb5344252a4a";
    var path = new StringBuffer(
        "https://api.douban.com/v2/movie/subject/$movieId/comments?start=$start&count=$requestCount&apikey=$requestApiKey");
    print("getMovieComment:${path.toString()}");
    Response response = await _dioGet(path.toString());
    print(response.data.toString());
    return MovieComment.from(response.data);
  }
}
