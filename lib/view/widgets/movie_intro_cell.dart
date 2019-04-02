import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';

class MovieIntroCell extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String sorts;
  final String avgRatings;
  final List<Directors> alDirectors;

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
          Expanded(flex: 3, child: Image.network(imgUrl ?? "")),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: contentWidgets(),
                  ),
                  ratingWidget()
                ],
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
        maxLines: 3,
        style: TextStyle(fontSize: 22.0, color: Colors.white),
      ),
    );
    alWidget.add(tvTitle);

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

    alWidget.add(Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(children: columnWidgets),
    ));

    return alWidget;
  }

  Widget ratingWidget() {
    //評分
    if (avgRatings != "0") {
      final tvAvgRatings = Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                avgRatings,
                style: TextStyle(color: Colors.amberAccent, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
      return tvAvgRatings;
    }
    return Container();
  }
}
