import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';

class MovieDesc extends StatelessWidget {
  final String title;
  final String originalTitle;
  final String year;
  final List<String> sorts;
  final List<Directors> directors;

  MovieDesc({
    @required this.title,
    this.originalTitle,
    this.year,
    this.sorts,
    this.directors,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontFamily: "zhFont", color: Colors.grey, fontSize: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Text(originalTitle == null ? "" : "原名：$originalTitle"),
          Text(_getSortMsg()),
          Text(_getDirectorMsg())
        ],
      ),
    );
  }

  String _getSortMsg() {
    StringBuffer sb = StringBuffer(year ?? "");
    if (sorts != null) {
      for (String s in sorts) {
        sb.write("/");
        sb.write(s);
      }
    }
    return sb.toString();
  }

  String _getDirectorMsg() {
    if (directors != null && directors.isNotEmpty) {
      StringBuffer sb = StringBuffer("導演：");
      for (int i = 0; i < directors.length; i++) {
        if (i > 0) {
          sb.write("/");
        }
        sb.write(directors[i].name);
      }
      return sb.toString();
    }
    return "";
  }
}
