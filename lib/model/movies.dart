

import 'package:flutter_movie_app/model/movie.dart';

class Movies {
  int count = 0;
  int start = 0;
  int total = 0;
  String title = "";
  List<Movie> subjects;

  Movies({this.count, this.start, this.total, this.title, this.subjects});

  factory Movies.from(Map<String, dynamic> json) {
    final List items = json['subjects'];

    return Movies(
      count: json['count'],
      start: json['start'],
      total: json['total'],
      title: json['title'],
      subjects: items.map((item) => Movie.from(item)).toList()
    );
  }

  @override
  String toString() {
    return 'Movies{count: $count, start: $start, total: $total, title: $title, subjects: $subjects}';
  }
}