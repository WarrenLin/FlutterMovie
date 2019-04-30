import 'package:flutter_movie_app/model/movie.dart';

class MovieComment {
  int count;
  List<CommentBean> comments;
  int start;
  int total;
  int next_starts;
  SubjectBean subjectBean;

  MovieComment({
    this.count,
    this.comments,
    this.start,
    this.total,
    this.next_starts,
    this.subjectBean,
  });

  factory MovieComment.from(dynamic json) {
    final List comments = json["comments"];

    return MovieComment(
      count: json["count"] as int,
      start: json["start"] as int,
      total: json["total"] as int,
      next_starts: json["next_starts"] as int,
      comments: comments.map((c) => CommentBean.from(c)).toList(),
      subjectBean: SubjectBean.from(json["subject"]),
    );
  }

  @override
  String toString() {
    return 'MovieComment{count: $count, comments: $comments, start: $start, total: $total, next_starts: $next_starts, subjectBean: $subjectBean}';
  }
}

class CommentBean {
  CommentRatingBean rating;
  int useful_count;
  AuthorBean author;
  String content;
  String created_at;

  CommentBean(
      {this.rating,
      this.useful_count,
      this.author,
      this.content,
      this.created_at});

  factory CommentBean.from(dynamic json) {
    return CommentBean(
      useful_count: json["useful_count"] as int,
      content: json["content"] as String,
      created_at: json["created_at"] as String,
      rating: CommentRatingBean.from(json["rating"]),
      author: AuthorBean.from(json["author"]),
    );
  }

  @override
  String toString() {
    return 'CommentBean{rating: $rating, useful_count: $useful_count, author: $author, content: $content, created_at: $created_at}';
  }
}

class CommentRatingBean {
  int max;
  num value;
  int min;

  CommentRatingBean({this.max, this.value, this.min});

  factory CommentRatingBean.from(dynamic json) {
    return CommentRatingBean(
        max: json["max"] as int, value: json["value"] as num, min: json["min"]);
  }

  @override
  String toString() {
    return 'CommentRatingBean{max: $max, value: $value, min: $min}';
  }


}

class AuthorBean {
  String uid;
  String avatar;
  String signature;
  String alt;
  String name;

  AuthorBean({this.uid, this.avatar, this.signature, this.alt, this.name});

  factory AuthorBean.from(dynamic json) {
    return AuthorBean(
      uid: json["uid"] as String,
      avatar: json["avatar"] as String,
      signature: json["signature"] as String,
      alt: json["alt"] as String,
      name: json["name"] as String,
    );
  }

  @override
  String toString() {
    return 'AuthorBean{uid: $uid, avatar: $avatar, signature: $signature, alt: $alt, name: $name}';
  }
}

class SubjectBean {
  SubjectRatingBean rating;

  SubjectBean({this.rating});

  factory SubjectBean.from(dynamic json) {
    return SubjectBean(
      rating: SubjectRatingBean.from(json["rating"]),
    );
  }
}

class SubjectRatingBean {
  int max;
  int min;
  double average;
  String stars;
  Map details;

  SubjectRatingBean(
      {this.max, this.min, this.average, this.stars, this.details});

  factory SubjectRatingBean.from(dynamic json) {
    return SubjectRatingBean(
      max: json["max"] as int,
      min: json["min"] as int,
      average: json["average"] as double,
      stars: json["stars"] as String,
      details: json["details"],
    );
  }

  @override
  String toString() {
    return 'SubjectRatingBean{max: $max, min: $min, average: $average, stars: $stars, details: $details}';
  }
}
