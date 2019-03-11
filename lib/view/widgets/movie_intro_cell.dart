import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';

class MovieIntroCell extends StatelessWidget {
  String imgUrl;
  String title;
  String sorts;
  String avgRatings;
  List<Directors> alDirectors;

  MovieIntroCell({
    @required this.imgUrl,
    @required this.title,
    @required this.sorts,
    @required this.avgRatings,
    this.alDirectors,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(flex: 4, child: Image.network(imgUrl)),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: contentWidgets(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> contentWidgets() {
    List<Widget> alWidget = [];

    //片名
    final tvTitle = Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 22.0, color: Colors.white),
      ),
    );

    List<Widget> columnWidgets = [];

    //類型
    final tvSort = Align(
      alignment: Alignment.topLeft,
      child: Text(
        sorts,
        style: TextStyle(fontSize: 18.0, color: Colors.white70),
      ),
    );
    columnWidgets.add(tvSort);

    //導演
    if (alDirectors != null && alDirectors.isNotEmpty) {
      StringBuffer directorsText = StringBuffer("導演：");
      for (int i = 0; i < alDirectors.length; i++) {
        Directors director = alDirectors[i];
        String directorName = director.name;
        (i == alDirectors.length - 1)
            ? directorsText.write(directorName)
            : directorsText.write("$directorName｜");
      }
      final tvDirectors = Align(
        alignment: Alignment.topLeft,
        child: Text(directorsText.toString(),
            style: TextStyle(color: Colors.amber)),
      );

      columnWidgets.add(tvDirectors);
    }

    final column = Column(children: columnWidgets);

    //評分
    final tvAvgRatings = Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          avgRatings,
          style: TextStyle(
              fontSize: 26.0,
              color: Colors.pinkAccent,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    alWidget..add(tvTitle)..add(column)..add(tvAvgRatings);

    return alWidget;
  }
}
