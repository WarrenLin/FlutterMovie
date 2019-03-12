import 'package:flutter_movie_app/model/movie.dart';

class PageStatus {
  List<Movie> movieList = [];
  bool isLoading = false;
  int itemIndex = 0;
  int totalCount = 0;
  Error error;
  Exception e;
}

class SearchStatus extends PageStatus {
  bool isSearching = false;
  String searchKeyWord = "";
}
