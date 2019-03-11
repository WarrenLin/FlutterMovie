import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';

class CastView extends StatelessWidget {
  List<Casts> castImages;

  CastView(this.castImages);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Cast",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 100.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: castImages.map((cast) => AvatarWidget(cast)).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  Casts cast;

  AvatarWidget(this.cast);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(cast.avatars.large ?? ""),
                backgroundColor: Colors.transparent),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Text(cast.name, style: TextStyle(fontSize: 12.0),),
            )
          ],
        ),
      ),
    );
  }
}
