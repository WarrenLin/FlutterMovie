import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;
import 'package:flutter_movie_app/view/widgets/cast_view.dart';
import 'package:flutter_movie_app/view/widgets/loading_footer.dart';
import 'package:flutter_movie_app/view/widgets/movie_intro_cell.dart';

const String DefaultHeroTag = "HeroTag";

class DetailPage extends StatefulWidget {
  final String id;
  final String title;
  final String imgUrl;
  final String heroTag;

  DetailPage({
    @required this.id,
    @required this.title,
    @required this.imgUrl,
    @required this.heroTag,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MovieInfo _movieInfo;

  @override
  void initState() {
    super.initState();
    api.DoubanAPI.internal().getMovieInfo(id: widget.id).then((movieInfo) {
      ///If it is an expected behavior that the Future completes when
      ///the widget already got disposed you can use
      if (this.mounted) {
        setState(() => _movieInfo = movieInfo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = Image.asset(
      ImageAssets.backgroundImage,
      fit: BoxFit.cover,
    );
    final content = Scaffold(
      appBar: createAppBar(),
      body: _createBody(),
    );

    return Stack(
        fit: StackFit.expand, children: <Widget>[backgroundImage, content]);
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
              child: Hero(
                tag: widget.heroTag.isEmpty ? DefaultHeroTag : widget.heroTag,
                child: MovieIntroCell(
                    imgUrl: widget.imgUrl ?? _movieInfo.images.large,
                    title: _getTitle(),
                    avgRatings: _movieInfo?.rating?.average?.toString() ?? "",
                    alDirectors: _movieInfo?.directors ?? [],
                    sorts: _movieInfo?.genres == null || _movieInfo.genres.isEmpty
                        ? ""
                        : _movieInfo.genres.toString()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                _movieInfo?.summary ?? "",
                style: TextStyle(
                    color: Colors.white70, fontSize: 16.0, letterSpacing: 2.0),
              ),
            ),
            _createCastView(),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    StringBuffer sb = StringBuffer();
    String title = _movieInfo?.title ?? "";
    String originalTitle = _movieInfo?.original_title ?? "";
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

  Widget _createCastView() {
    if (_movieInfo?.casts == null) {
      return LoadingFooter();
    }
    return CastView(_movieInfo?.casts ?? List<Casts>());
  }
}
