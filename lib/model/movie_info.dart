
import 'package:flutter_movie_app/model/movie.dart';

class MovieInfo {
  String title = "";
  Rating rating;
  int reviews_count = 0;
  int wish_count = 0;
  String douban_site = "";
  String year = "";
  Avatars images;
  String alt;
  String id;
  String mobile_url;
  String share_url;
  List<String> countries;
  List<String> genres;
  int collect_count = 0;
  List<Casts> casts;
  String original_title = "";
  String summary = "";
  String subtype = "";
  List<Directors> directors;
  int comments_count = 0;
  int ratings_count = 0;
  List<String> aka;

  MovieInfo({this.title, this.rating, this.reviews_count, this.wish_count,
      this.douban_site, this.year, this.images, this.alt, this.id,
      this.mobile_url, this.share_url, this.countries, this.genres,
      this.collect_count, this.casts, this.original_title, this.summary,
      this.subtype, this.directors, this.comments_count, this.ratings_count,
      this.aka});

  factory MovieInfo.from(Map<String, dynamic> json) {
    List<String> countries = (json['countries'] as List<dynamic>).cast<String>();
    final List<String> genres = (json['genres'] as List<dynamic>).cast<String>();
    final List casts = json['casts'];
    final List directors = json['directors'];
    List<String> aka = (json['aka'] as List<dynamic>).cast<String>();

    return MovieInfo(
        title: json['title'],
        rating: Rating.from(json['rating']),
        reviews_count: json['reviews_count'],
        wish_count: json['wish_count'],
        douban_site: json['douban_site'],
        year: json['year'],
        images: Avatars.from(json['images']),
        alt: json['alt'],
        id: json['id'],
        mobile_url: json['mobile_url'],
        share_url: json['share_url'],
        countries: countries,
        genres: genres,
        collect_count: json['collect_count'],
        casts: casts.map((item) => Casts.from(item)).toList(),
        original_title: json['original_title'],
        summary: json['summary'],
        subtype: json['subtype'],
        directors: directors.map((item) => Directors.from(item)).toList(),
        comments_count: json['comments_count'],
        ratings_count: json['ratings_count'],
        aka: aka
    );
  }

  @override
  String toString() {
    return 'MovieInfo{title: $title, rating: $rating, reviews_count: $reviews_count, wish_count: $wish_count, douban_site: $douban_site, year: $year, images: $images, alt: $alt, id: $id, mobile_url: $mobile_url, share_url: $share_url, countries: $countries, genres: $genres, collect_count: $collect_count, casts: $casts, original_title: $original_title, summary: $summary, subtype: $subtype, directors: $directors, comments_count: $comments_count, ratings_count: $ratings_count, aka: $aka}';
  }
}