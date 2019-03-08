import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;

class DetailPage extends StatefulWidget {
  final String id;

  DetailPage({@required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MovieInfo _movieInfo;

  @override
  void initState() {
    super.initState();
    api.DoubanAPI.internal()
        .getMovieInfo(id: widget.id)
        .then((movieInfo) => setState(() => _movieInfo = movieInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: _movieInfo == null
            ? Center(child: CircularProgressIndicator())
            : createBody(),
      ),
    );
  }

  Widget createBody() {
//    return Column(
//      children: <Widget>[Text("title:${_movieInfo.title}")],
//    );
    return Center(child: Text("title:${_movieInfo.title}"));
  }
}
