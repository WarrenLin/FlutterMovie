import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie.dart';

class HomeCell extends StatelessWidget {
  Movie _movie;
  VoidCallback _callback;
  HomeCell(this._movie,this._callback);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(_movie.images.large,fit:BoxFit.fill),
          _TextualInfo(_movie),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _callback,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

//底下漸層
class _TextualInfo extends StatelessWidget {
  Movie _movie;

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
        stops: [0.0, 0.7, 0.7],
        colors: [
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _itemInfoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _movie.title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
        const SizedBox(height: 4.0),
        Text(
          _movie.genres.toString(),
          style: const TextStyle(fontSize: 12.0, color: Colors.white70),
        )
      ],
    );
  }
}
