import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';

typedef CastCallback(Casts cast);

class CastView extends StatelessWidget {
  final List<Casts> castImages;
  final CastCallback callback;

  CastView(this.castImages, this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          new Container(
            height: 0.5,
            color: Colors.black12,
          ),
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
              children: castImages
                  .map((cast) => AvatarWidget(cast, callback))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final Casts cast;
  final CastCallback callback;

  AvatarWidget(this.cast, this.callback);

  @override
  Widget build(BuildContext context) {
    String imgUrl = cast?.avatars?.large ?? "";
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage(imgUrl),
                  backgroundColor: Colors.transparent),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Text(
                  cast.name,
                  style: TextStyle(fontFamily: "zhFont", fontSize: 12.0),
                ),
              )
            ],
          ),
          onTap: () => callback(cast),
        ),
      ),
    );
  }
}
