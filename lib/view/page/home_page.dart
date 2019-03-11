import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/view/page/detail_page.dart';
import 'package:flutter_movie_app/view/widgets/home_cell.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;

const String defaultErrorMessage = "網路異常請稍後再試";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _movieIndex = 0;
  int _totalCount = 0;
  bool _isLoading = true;
  List<Movie> _alMovie = [];
  ScrollController _scrollController;

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      if (_movieIndex < _totalCount)
        setState(() {
          _isLoading = true;
          _movieIndex = _alMovie.length;
          print("load data start from $_movieIndex");
        });
    }
  }

  @override
  void initState() {
//    moviesFuture = api.DoubanAPI.internal().getInTheaters(startIndex: 0);
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_listener);
    print("dispose!!!!");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movies>(
        future: api.DoubanAPI.internal().getInTheaters(startIndex: _movieIndex),
        builder: (context, AsyncSnapshot<Movies> snapshot) {
          if (snapshot.hasError && _totalCount == 0) {
            print("error:" + snapshot.error.toString());
            return Center(
                child: Text(defaultErrorMessage,
                    style: TextStyle(color: Colors.white)));
          }

          if (snapshot.hasData) {
            Movies movies = snapshot.data;
            if (movies.start == _movieIndex) {
              print("get movie" + movies.subjects.toString());
              _totalCount = snapshot.data.total;
              movies.subjects.forEach((Movie movie) => _alMovie.add(movie));
              _isLoading = false;
            }
          }

          if (_totalCount == 0) {
            return Center(child: CircularProgressIndicator());
          }

          return _createBody();
        });
  }

  Widget _createBody() {
    List<Widget> alWidget = []..add(_createMovieGridView());
    if (_isLoading) {
      alWidget.add(Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CupertinoActivityIndicator(radius: 6.0),
        ),
      ));
    }
    return Stack(children: alWidget);
  }

  Widget _createMovieGridView() {
    print("_createMovieGridView");
    return GridView.builder(
        itemCount: _alMovie.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          Movie movie = _alMovie[index];
          return GestureDetector(
            child: HomeCell(movie),
            onTap: () {
              print("click:" + movie.title);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(id: movie.id)),
              );
            },
          );
        });
  }
}
