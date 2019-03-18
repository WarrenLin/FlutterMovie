import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;
import 'package:flutter_movie_app/view/widgets/cast_view.dart';
import 'package:flutter_movie_app/view/widgets/movie_intro_cell.dart';

class DetailPage extends StatefulWidget {
  final String id;
  final String title;

  DetailPage({@required this.id, @required this.title});

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
    final backgroundImage = Image.asset(
      ImageAssets.backgroundImage,
      fit: BoxFit.cover,
    );
    final content = Scaffold(
        appBar: createAppBar(),
        body: _movieInfo == null
            ? Center(child: CircularProgressIndicator())
            : _createBody());

    return Stack(
        fit: StackFit.expand,
        children: <Widget>[backgroundImage, content]);
  }

  AppBar createAppBar() {
    final backBtn = GestureDetector(
      child: Icon(Icons.arrow_back_ios),
      onTap: () => Navigator.pop(context),
    );

    return AppBar(
        leading: backBtn,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
        ),
        backgroundColor: Color(0xFF152451));
  }

  Widget _createBody() {
    return Container(
      decoration: BoxDecoration(color: Colors.black26),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: MovieIntroCell(
                  imgUrl: _movieInfo.images.large,
                  title: _getTitle(),
                  avgRatings: _movieInfo.rating.average.toString(),
                  alDirectors: _movieInfo.directors,
                  sorts: _movieInfo.genres == null || _movieInfo.genres.isEmpty
                      ? ""
                      : _movieInfo.genres.toString()),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                _movieInfo.summary + _movieInfo.summary,
                style: TextStyle(
                    color: Colors.white70, fontSize: 16.0, letterSpacing: 2.0),
              ),
            ),
            CastView(_movieInfo.casts),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    StringBuffer sb = StringBuffer();
    String title = _movieInfo.title;
    String originalTitle = _movieInfo.original_title;
    if (title != null && title.isNotEmpty) {
      sb.write(title);
    }
    if (originalTitle != null &&
        originalTitle.isNotEmpty &&
        title != originalTitle) {
      sb.write("($originalTitle)");
    }
    return sb.toString();
  }
}
