import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';

class ScreenShotsView extends StatelessWidget {
  final List<String> imgUrls;

  ScreenShotsView({@required this.imgUrls});

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
                "Screenshots",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 120.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: imgUrls.map((url) => _imageCell(url)).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageCell(String url) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
      child: FadeInImage.assetNetwork(
        placeholder: ImageAssets.transparentImage,
        image: url,
        fadeInDuration: const Duration(milliseconds: 300),
        fit: BoxFit.cover,
      ),
    );
  }
}
