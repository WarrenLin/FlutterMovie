import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/utils/Util.dart';

class MovieDesc extends StatelessWidget {
  final String title;
  final String originalTitle;
  final String year;
  final List<String> sorts;
  final List<String> durations;
  final List<String> pubDates;
  final List<Directors> directors;

  MovieDesc(
      {@required this.title,
      this.originalTitle,
      this.year,
      this.sorts,
      this.directors,
      this.durations,
      this.pubDates});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = []..add(
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
      );

    Util.addIfNonNull(widgets, _getOriginalNameText());
    Util.addIfNonNull(widgets, _getSortText());
    Util.addIfNonNull(widgets, _getDurationsMsg());
    Util.addIfNonNull(widgets, _getDirectorMsg());
    Util.addIfNonNull(widgets, _getPubDatesMsg());

    return DefaultTextStyle(
      style: TextStyle(fontFamily: "zhFont", color: Colors.grey, fontSize: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget _getOriginalNameText() {
    if (originalTitle != null && originalTitle.isNotEmpty) {
      return Text("原名：$originalTitle");
    }
    return null;
  }

  Widget _getSortText() {
    StringBuffer sb = StringBuffer(year ?? "");
    if (sorts != null) {
      for (String s in sorts) {
        sb.write(" / ");
        sb.write(s);
      }
    }
    return sb.isNotEmpty ? Text(sb.toString()) : null;
  }

  Widget _getDirectorMsg() {
    if (directors != null && directors.isNotEmpty) {
      StringBuffer sb = StringBuffer("導演：");
      for (int i = 0; i < directors.length; i++) {
        if (i > 0) {
          sb.write(" / ");
        }
        sb.write(directors[i].name);
      }
      return Text(sb.toString());
    }
    return null;
  }

  Widget _getPubDatesMsg() {
    if (pubDates != null && pubDates.isNotEmpty) {
      StringBuffer sb = StringBuffer("上映時間：");
      for (int i = 0; i < pubDates.length; i++) {
        if (i > 0) {
          sb.write(" / ");
        }
        sb.write(pubDates[i]);
      }
      return Text(sb.toString());
    }
    return null;
  }

  Widget _getDurationsMsg() {
    if (durations != null && durations.isNotEmpty) {
      StringBuffer sb = StringBuffer("片長：");
      for (int i = 0; i < durations.length; i++) {
        if (i > 0) {
          sb.write(" / ");
        }
        sb.write(durations[i]);
      }
      return Text(sb.toString());
    }
    return null;
  }
}
