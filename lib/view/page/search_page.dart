import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/model/movies.dart';
import 'package:flutter_movie_app/view/page/detail_page.dart';
import 'package:flutter_movie_app/view/widgets/movie_intro_cell.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController;
  List<Movie> alSearchMovie = [];
  bool _isSearching = false;
  int _searchIndex = 0;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[createEditText(), createContent()],
    );
  }

  Widget createEditText() {
    final row = Row(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _textEditingController,
              onSubmitted: (s) => searchBtnClick(),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '請輸入關鍵字',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.orange,
                size: 30.0,
              ),
              onPressed: () => searchBtnClick()),
        )
      ],
    );

    return row;
  }

  Widget createContent() {
    if (_isSearching) {
      return Center(child: CircularProgressIndicator());
    }

    if (alSearchMovie.isNotEmpty) {
      ListView lv = _createListView();
      return Expanded(child: lv);
    }

    String searchText = _textEditingController.text;
    if (searchText != null && searchText.isEmpty) {
      return Center();
    }

    return Expanded(
        child: Text(
      "找不到'$searchText'相關資訊",
      style: TextStyle(color: Colors.white),
    ));
  }

  void _searchMovie(String keyword) {
    print("search : $keyword");
    api.DoubanAPI.internal()
        .search(keyword: keyword, startIndex: _searchIndex)
        .then((Movies movie) {
      /// handle data
      List<Movie> subjects = movie.subjects;
      if (subjects != null && subjects.isNotEmpty) {
        subjects.forEach((Movie m) => alSearchMovie.add(m));
      }
      setSearchStatus(false);
    }).catchError((error) {
      print("occur error ${error.message}");
      setSearchStatus(false);
    });
  }

  void setSearchStatus(bool isSearch) {
    setState(() => _isSearching = isSearch);
  }

  ListView _createListView() {
    return ListView.builder(
        itemCount: alSearchMovie.length,
        itemBuilder: (BuildContext context, int index) {
          Movie movie = alSearchMovie[index];
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

  void searchBtnClick() {
    alSearchMovie.clear();
    setSearchStatus(true);
    _searchMovie(_textEditingController.text);
  }
}
