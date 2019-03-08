
class Movie {
  Rating rating;
  List<String> genres;
  String title;
  List<Casts> casts;
  var collect_count;
  String original_title;
  String subtype;
  List<Directors> directors;
  String year;
  Avatars images;
  String alt;
  String id;

  Movie({this.rating, this.genres, this.title, this.casts, this.collect_count, this.original_title, this.subtype, this.directors, this.year, this.images, this.alt, this.id});

  factory Movie.from(Map<String, dynamic> json) {
    final List<String> genres = (json['genres'] as List<dynamic>).cast<String>();
    final List casts = json['casts'];
    final List directors = json['directors'];

    return Movie(
        rating: Rating.from(json['rating']),
        genres: genres,
        title: json['title'],
        casts: casts.map((item) => Casts.from(item)).toList(),
        collect_count: json['collect_count'],
        original_title: json['original_title'],
        subtype: json['subtype'],
        directors: directors.map((item) => Directors.from(item)).toList(),
        year: json['year'],
        images: Avatars.from(json['images']),
        alt: json['alt'],
        id: json['id']
    );
  }

  @override
  String toString() {
    return 'Movie{title: $title}';
  }

//  @override
//  String toString() {
//    return 'Movie{rating: $rating, genres: $genres, title: $title, casts: $casts, collect_count: $collect_count, original_title: $original_title, subtype: $subtype, directors: $directors, year: $year, images: $images, alt: $alt, id: $id}';
//  }


}

class Rating {
  var max = 0;
  var average;
  var stars = "";
  var min = 0;

  Rating({this.max, this.average, this.stars, this.min});

  factory Rating.from(Map<String, dynamic> json) {
    if (json != null) {
      return Rating(
          max: json["max"],
          average: json["average"],
          stars: json["stars"],
          min: json["min"]
      );
    }
    return Rating();
  }

  @override
  String toString() {
    return 'Rating{max: $max, average: $average, stars: $stars, min: $min}';
  }
}

class Casts {
  String alt = "";
  String name = "";
  String id = "";
  Avatars avatars;

  Casts({this.alt, this.name, this.id, this.avatars});

  factory Casts.from(Map<String, dynamic> json) {
    if (json != null) {
      return Casts(
          alt: json['alt'],
          name: json['name'],
          id: json['id'],
          avatars: Avatars.from(json['avatars'])
      );
    }
    return Casts();
  }

  @override
  String toString() {
    return 'Casts{alt: $alt, name: $name, id: $id, avatars: $avatars}';
  }
}

class Avatars {
  String small = "";
  String medium = "";
  String large = "";

  Avatars({this.small, this.medium, this.large});

  factory Avatars.from(Map<String, dynamic> json) {
    if (json != null) {
      return Avatars(
          small: json['small'],
          medium: json['medium'],
          large: json['large']
      );
    }
    return Avatars();
  }

  @override
  String toString() {
    return 'Avatars{small: $small, medium: $medium, large: $large}';
  }
}

class Directors {
  String alt;
  String name;
  String id;
  Avatars avatars;

  Directors({this.alt, this.name, this.id, this.avatars});

  factory Directors.from(Map<String, dynamic> json) {
    if (json != null) {
      return Directors(
          alt: json['alt'],
          name: json['name'],
          id: json['id'],
          avatars: Avatars.from(json['avatars'])
      );
    }
    return Directors();
  }

  @override
  String toString() {
    return 'Directors{alt: $alt, name: $name, id: $id, avatars: $avatars}';
  }
}