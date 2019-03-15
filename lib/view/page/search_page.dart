import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter_movie_app/view/page/detail_page.dart';
import 'package:flutter_movie_app/view/page_status.dart';
import 'package:flutter_movie_app/view/widgets/loading_footer.dart';
import 'package:flutter_movie_app/view/widgets/movie_intro_cell.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;

const String defaultHint = "請輸入關鍵字";

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController;
  ScrollController _scrollController;
  SearchStatus _status;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      if (_status.movieList.length < _status.totalCount)
        setState(() {
          _status.isLoading = true;
          _status.itemIndex = _status.movieList.length;
          _searchMovie(_status.searchKeyWord);
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _status = SearchStatus();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
    print("SearchPage dispose!!!!");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[createEditText(), createContent()],
    );
  }

  Widget createEditText() {
    final widget = Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: _textEditingController,
          onFieldSubmitted: (keyword) => searchBtnClick(keyword),
          decoration: InputDecoration(
              labelText: defaultHint,
              labelStyle: TextStyle(color: Colors.amberAccent),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 0.0), // width: 0.0 produces a thin "hairline" border
              )),
          style: TextStyle(fontFamily: "Poppins", color: Colors.white),
        ),
      ),
    );

    return widget;
  }

  Widget createContent() {
    if (_status.isSearching) {
      return CircularProgressIndicator();
    }

    /// ListView
    if (_status.movieList.isNotEmpty) {
      Widget lv = Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: _createListView(),
      );
      if (_status.isLoading) {
        return Expanded(
          child: Stack(children: <Widget>[
            lv,
            LoadingFooter(),
          ]),
        );
      }
      return Expanded(child: Stack(children: [lv]));
    }

    String searchText = _textEditingController.text;
    if (searchText != null && searchText.isEmpty) {
      return Center();
    }

    return Text(
      "找不到 『 $searchText 』 相關資訊 😅",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22.0,
      ),
    );
  }

  void _searchMovie(String keyword) {
    print("search : $keyword");
    _status.searchKeyWord = keyword;
    api.DoubanAPI.internal()
        .search(keyword: keyword, startIndex: _status.itemIndex)
        .then((Movies movie) {
      /// handle data
      List<Movie> subjects = movie.subjects;
      if (subjects != null && subjects.isNotEmpty) {
        _status.totalCount = movie.total;
        subjects.forEach((Movie m) => _status.movieList.add(m));
      }
      setSearchStatus(false);
    }).catchError((error) {
      print("occur error ${error.message}");
      setSearchStatus(false);
    });
  }

  ListView _createListView() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: _status.movieList.length,
        itemBuilder: (BuildContext context, int index) {
          Movie movie = _status.movieList[index];
          MovieIntroCell cell = MovieIntroCell(
            imgUrl: movie.images.large,
            title: movie.title,
            sorts: (movie.genres == null || movie.genres.isEmpty)
                ? ""
                : movie.genres.toString(),
            avgRatings: movie.rating.average.toString(),
          );
          return Column(children: <Widget>[
            InkWell(
              child: cell,
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              id: movie.id,
                              title: movie.title,
                            )),
                  ),
            ),
            Divider(color: Colors.white24)
          ]);
        });
  }

  void searchBtnClick(String keyword) {
    if (keyword.isEmpty) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
          defaultHint,
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      ///清空資料&還原index預設值
      _status.movieList.clear();
      _status.itemIndex = 0;

      setSearchStatus(true);
      _searchMovie(keyword);
    }
  }

  void setSearchStatus(bool isSearch) {
    setState(() {
      _status.isSearching = isSearch;
      _status.isLoading = isSearch;
    });
  }
}
