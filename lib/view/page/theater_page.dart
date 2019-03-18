import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/theater.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;
import 'package:url_launcher/url_launcher.dart';

class TheaterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TheaterState();
  }
}

class TheaterState extends State<TheaterPage> {
  Map<String, dynamic> _theaters;

  @override
  void initState() {
    super.initState();
    api.DoubanAPI.internal()
        .getTheater()
        .then((Map<String, dynamic> theaters) => _theaters = theaters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var key = _theaters.keys.toList()[index];
              final List theaters = _theaters[key];
              return MovieInTitles(key,
                  theaters.map((theater) => Theater.from(theater)).toList());
            },
            itemCount: _theaters?.length ?? 0));
  }
}

class MovieInTitles extends StatefulWidget {
  final String listTitle;
  final List<Theater> theaters;

  MovieInTitles(this.listTitle, this.theaters);

  @override
  State<StatefulWidget> createState() => _ListWidget();
}

class _ListWidget extends State<MovieInTitles>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    animation = new Tween(begin: 0.0, end: 0.5).animate(animationController);
  }

  _changeOpacity(bool expand) {
    setState(() {
      if (expand) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.listTitle, style: TextStyle(color: Colors.white)),
      trailing: RotationTransition(
        turns: animation,
        child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
      ),
      onExpansionChanged: (bool) {
        _changeOpacity(bool);
      },
      children:
          widget.theaters.map((theater) => getSubTitleWidget(theater)).toList(),
    );
  }

  Widget getSubTitleWidget(Theater theater) {
    return Container(
      height: 110.0,
      color: Colors.black54,
      margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(theater.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(theater.phone,
                          style: TextStyle(color: Colors.white70))),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(theater.address,
                        style: TextStyle(color: Colors.white70))),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.theaters,
                  color: Colors.amber,
                ),
                onPressed: () {
                  launchURL(theater.web);
                }),
          )
        ],
      ),
    );
  }

  launchURL(String url) async {
    print("launchURL:$url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
