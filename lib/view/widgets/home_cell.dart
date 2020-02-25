import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/utils/Util.dart';

class HomeCell extends StatelessWidget {
  final Movie _movie;
  final VoidCallback _callback;

  HomeCell(this._movie, this._callback);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
//        Image.network(_movie.images.large, fit: BoxFit.fill),
        _moviePoster(),
        _TextualInfo(_movie),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _callback,
            child: Container(),
          ),
        ),
      ],
    );
  }

  Widget _moviePoster() {
    return FadeInImage.assetNetwork(
      placeholder: ImageAssets.transparentImage,
      image: _movie.images.large,
      fadeInDuration: const Duration(milliseconds: 300),
      fit: BoxFit.cover,
    );
  }
}

//底下漸層
class _TextualInfo extends StatelessWidget {
  final Movie _movie;

  _TextualInfo(this._movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildGradientBackground(),
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: _itemInfoContent(),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.0, 0.5],
        colors: [Colors.black, Colors.transparent],
      ),
    );
  }

  Widget _itemInfoContent() {
    return DefaultTextStyle(
      style: Util.fontCh(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _movie.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(_movie.genres.toString(),
              style: const TextStyle(fontSize: 12.0, color: Colors.white70))
        ],
      ),
    );
  }
}
