import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/view/page/detail_page.dart';
import 'package:flutter_movie_app/view/page_status.dart';
import 'package:flutter_movie_app/view/widgets/home_cell.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;
import 'package:flutter_movie_app/view/widgets/loading_footer.dart';

const String defaultErrorMessage = "網路異常請稍後再試";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageStatus _status;
  ScrollController _scrollController;

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");

      ///get more data
      if (_status.movieList.length < _status.totalCount) {
        _status.itemIndex = _status.movieList.length;
        _getMovieByApi();
        setLoading(true);
      }
    }
  }

  void _getMovieByApi() {
    api.DoubanAPI()
        .getInTheaters(startIndex: _status.itemIndex)
        .then((Movies movies) {
      _status.totalCount = movies.total;
      movies.subjects.forEach((Movie movie) => _status.movieList.add(movie));
      setLoading(false);
    }).catchError((onError) {
      print("_getMovieByApi xxxx:$onError");
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(minutes: 1),
        content: Text("發生錯誤"),
        action: SnackBarAction(
          label: "重試",
          onPressed: () => _getMovieByApi(),
        ),
      ));
    });
  }

  void setLoading(bool isLoading) {
    setState(() => _status.isLoading = isLoading);
  }

  @override
  void initState() {
    _status = PageStatus();
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    _getMovieByApi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_listener);
    print("HomePage dispose!!!!");
  }

  @override
  Widget build(BuildContext context) {
    if (_status.movieList.isNotEmpty) {
      return _createBody();
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _createBody() {
    List<Widget> alWidget = []..add(_createMovieGridView());
    if (_status.isLoading) {
      alWidget.add(LoadingFooter());
    }
    return Stack(children: alWidget);
  }

  Widget _createMovieGridView() {
    print("_createMovieGridView");
    return GridView.builder(
        itemCount: _status.movieList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          Movie movie = _status.movieList[index];
          String img = movie?.images?.large ?? "";
          return Hero(
            tag: img + "homePage",
            child: HomeCell(movie, () {
              print("click:" + movie.title);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          id: movie.id,
                          title: movie.title,
                          imgUrl: img,
                          heroTag: img + "homePage",
                        )),
              );
            }),
          );
        });
  }
}
