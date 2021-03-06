import 'package:flutter/material.dart';

const int totalStarCount = 5;

const Icon starLight = Icon(
  Icons.star,
  color: Colors.amber,
  size: 16,
);

const Icon starHalf = Icon(
  Icons.star_half,
  color: Colors.amber,
  size: 16,
);

const Icon starDark = Icon(
  Icons.star_border,
  color: Colors.amber,
  size: 16,
);

class RatingCard extends StatelessWidget {
  final int collectCount;
  final num averageRating;

  RatingCard({@required this.collectCount, @required this.averageRating});

  @override
  Widget build(BuildContext context) {
    if (averageRating == 0) {
      return Container();
    }

    Widget collectText = (collectCount == 0)
        ? Container()
        : Text(
            collectCount.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              averageRating.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            createStarIcons(),
            collectText
          ],
        ),
      ),
    );
  }

  Widget createStarIcons() {
    List<Widget> stars = [];

    int starLightCount = averageRating ~/ 2.0; //(averageRating / 2.0).toInt()
    int starHalfCount = (averageRating % 2 < 1) ? 0 : 1;
    int starDarkCount = totalStarCount - starHalfCount - starLightCount;

    for (int i = 0; i < starLightCount; i++) {
      stars.add(starLight);
    }

    if (starHalfCount == 1) {
      stars.add(starHalf);
    }

    for (int j = 0; j < starDarkCount; j++) {
      stars.add(starDark);
    }

    //多包一層避免星星被卡到
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisSize: MainAxisSize.min, children: stars));
  }
}
