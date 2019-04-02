import 'package:flutter_movie_app/model/movie.dart';

class CelebrityInfo {
  String id;
  String mobile_url;
  String name;
  String name_en;
  String born_place;
  String gender;
  String alt;
  List<String> aka;
  List<String> aka_en;
  Avatars avatars;
  List<WorksBean> works;

  CelebrityInfo({
    this.id,
    this.mobile_url,
    this.name,
    this.name_en,
    this.born_place,
    this.gender,
    this.alt,
    this.aka_en,
    this.aka,
    this.avatars,
    this.works,
  });

  factory CelebrityInfo.from(dynamic json) {
    final List items = json["works"];
    return CelebrityInfo(
      id: json["id"] as String,
      mobile_url: json["mobile_url"] as String,
      name: json["name"] as String,
      name_en: json["name_en"] as String,
      born_place: json["born_place"] as String,
      gender: json["gender"] as String,
      alt: json["alt"] as String,
      aka: new List<String>.from(json["aka"]),
      aka_en: new List<String>.from(json["aka_en"]),
      avatars: Avatars.from(json["avatars"]),
      works: items.map((item) => WorksBean.from(item)).toList(),
    );
  }

  @override
  String toString() {
    return 'CelebrityInfo{id: $id, mobile_url: $mobile_url, name: $name, name_en: $name_en, born_place: $born_place, gender: $gender, alt: $alt, aka: $aka, aka_en: $aka_en, avatars: $avatars, works: $works}';
  }
}

class WorksBean {
  List<String> roles;
  Movie subject;

  WorksBean({this.roles, this.subject});

  factory WorksBean.from(dynamic json) {
    return WorksBean(
      roles: new List<String>.from(json["roles"]),
      subject: Movie.from(json["subject"]),
    );
  }

  @override
  String toString() {
    return 'WorksBean{roles: $roles, subjects: $subject}';
  }
}
