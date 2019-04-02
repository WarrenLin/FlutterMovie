import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/model/celebrity.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/model/movie_info.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;
import 'package:flutter_movie_app/utils/ui_util.dart';
import 'package:flutter_movie_app/view/widgets/cast_info_card.dart';
import 'package:flutter_movie_app/view/widgets/cast_view.dart';
import 'package:flutter_movie_app/view/widgets/loading_footer.dart';
import 'package:flutter_movie_app/view/widgets/movie_desc.dart';
import 'package:flutter_movie_app/view/widgets/rating_card.dart';

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
  Map<String, CelebrityInfo> _castMap = {};

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

    ///use bottomSheet，occur a error => Scaffold.of() called with a context that
    ///does not contain a ScaffoldThis exception happens because you are using
    ///the context of the widget that instantiated Scaffold Not the context of a child of Scaffold.
    ///https://stackoverflow.com/questions/51304568/scaffold-of-called-with-a-context-that-does-not-contain-a-scaffold/51304732
    final content = Scaffold(
        appBar: createAppBar(),
        body: Builder(builder: (context) => _createBody(context)));

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

  Widget _createBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black26),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: 300,
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Hero(
                  tag: widget.heroTag.isEmpty ? DefaultHeroTag : widget.heroTag,
                  child: Image.network(
                      widget.imgUrl ?? _movieInfo?.images?.large ?? ""),
                )),
            _createMovieInfo(),
            _createCastView(context),
          ],
        ),
      ),
    );
  }

  Widget _createMovieInfo() {
    if (_movieInfo == null) return Container();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 0.01],
          colors: <Color>[Color(0xffCCCCCC), Color(0XFFF8F8F8)],
        ),
      ),
      child: Column(
        children: <Widget>[_createMovieDesc(), _createMovieSummary()],
      ),
    );
  }

  Widget _createMovieDesc() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: MovieDesc(
            title: _movieInfo?.title,
            originalTitle: _movieInfo?.original_title,
            year: _movieInfo?.year,
            sorts: _movieInfo?.genres,
            directors: _movieInfo?.directors,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: RatingCard(
          ratingCount: _movieInfo?.ratings_count ?? 0,
          averageRating: _movieInfo?.rating?.average ?? 0,
        ),
      )
    ]);
  }

  Widget _createMovieSummary() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Text(
        _movieInfo?.summary ?? "",
        style: TextStyle(
          fontFamily: "zhFont",
          color: Colors.black,
          fontSize: 16.0,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _createCastView(BuildContext context) {
    if (_movieInfo?.casts == null) {
      return LoadingFooter();
    }
    return CastView(_movieInfo?.casts ?? List<Casts>(), (cast) {
      print("cast id:${cast.id}");
      _processCastDetail(context, cast);
    });
  }

  void _processCastDetail(BuildContext context, Casts cast) {
    String castId = cast.id ?? "";
    CelebrityInfo castDetail = _castMap[castId];
    if (castDetail == null) {
      UIUtil.showLoadingDialog(context);
      _getCelebrityInfo(context, castId);
      return;
    }
    _showCastBottomSheet(context, castDetail);
  }

  void _getCelebrityInfo(BuildContext context, String castId) {
    api.DoubanAPI()
        .getCelebrityInfo(castId: castId)
        .then((info) => _showCastBottomSheet(context, _castMap[castId] = info))
        .catchError((onError) => print("_getCelebrityInfoByApi error$onError"))
        .whenComplete(() => Navigator.pop(context));
  }

  void _showCastBottomSheet(BuildContext context, CelebrityInfo celebrityInfo) {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) => CastInfoCard(
            celebrityInfo,
            callback: (movie, heroTag) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          id: movie.id,
                          title: movie.title,
                          imgUrl: movie?.images?.large,
                          heroTag: heroTag,
                        )),
              );
            },
          ),
    );
  }
}
