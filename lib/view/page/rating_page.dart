import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/model/movie_comment.dart';
import 'package:flutter_movie_app/repository/douban_api.dart' as api;
import 'package:flutter_movie_app/utils/Util.dart';
import 'package:flutter_movie_app/view/widgets/loading_footer.dart';
import 'package:flutter_movie_app/view/widgets/rating_card.dart';

const MAXScore = 5;

class RatingPage extends StatefulWidget {
  final String movieId;
  final String title;
  final String headerImgUrl;

  RatingPage({@required this.movieId, @required this.title, this.headerImgUrl});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  bool _isLoading = true;
  int _itemIndex = 0;
  int _totalCount = 0;

  List<CommentBean> _commentList = [];
  SubjectRatingBean _subjectRatingBean;
  ScrollController _scrollController;

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");

      ///get more data
      if (_commentList.length < _totalCount) {
        _itemIndex = _commentList.length;
        _getRatingData();
        setLoading(true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    _getRatingData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SliverAppBar appBar = SliverAppBar(
      backgroundColor: Color(0xFF152451),
      expandedHeight: 150.0,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraint) {
          return FlexibleSpaceBar(
            title: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: constraint.biggest.height > 80 ? 0.0 : 1.0,
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.white),
              ),
            ),
            background: RatingScore(
                ratingBean: _subjectRatingBean,
                headerImgUrl: widget.headerImgUrl),
          );
        },
      ),
      floating: true,
      pinned: true,
    );

    List<Widget> bodyWidget = []..add(Image.asset(
        ImageAssets.backgroundImage,
        fit: BoxFit.cover,
      ));

    bodyWidget.add(CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        appBar,
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int position) {
              return _createCommentCell(_commentList[position]);
            },
            childCount: _commentList.length,
          ),
        )
      ],
    ));

    Util.addIfNonNull(bodyWidget, _isLoading ? LoadingFooter() : null);

    return Scaffold(
      backgroundColor: Color(0xFF152451),
      body: Stack(
        fit: StackFit.expand,
        children: bodyWidget,
      ),
    );
  }

  void _getRatingData() {
    api.DoubanAPI()
        .getMovieComment(movieId: widget.movieId, start: _itemIndex)
        .then((MovieComment movieComment) {
      _subjectRatingBean = movieComment?.subjectBean?.rating;
      _commentList.addAll(movieComment.comments);
      _totalCount = movieComment.total;
      setLoading(false);
    });
  }

  void setLoading(bool isLoading) {
    if (this.mounted) {
      setState(() => _isLoading = isLoading);
    }
  }

  Widget _createCommentCell(CommentBean movieComment) {
    print("_createCommentCell:$movieComment");
    AuthorBean author = movieComment.author;
    var authorWidget = Row(
      children: <Widget>[
        SizedBox(
          width: 20.0,
        ),
        CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(author.avatar),
            backgroundColor: Colors.transparent),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                author.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 18.0,
                ),
              ),
              Row(children: _getStarIcons(movieComment))
            ],
          ),
        ),
      ],
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: authorWidget,
          ),
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(movieComment.content),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                movieComment.created_at,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getStarIcons(CommentBean movieComment) {
    int score = movieComment?.rating?.value?.toInt() ?? 0;
    List<Widget> starIcons = [];
    if (score != 0) {
      print("_getStarIcons score :$score");
      Color starColor;
      switch (score) {
        case 5:
          starColor = Colors.green;
          break;
        case 4:
          starColor = Colors.lightGreen;
          break;
        case 3:
          starColor = Colors.amberAccent;
          break;
        case 2:
          starColor = Colors.orangeAccent;
          break;
        case 1:
          starColor = Colors.red;
          break;
      }

      for (int i = 0; i < MAXScore; i++) {
        if (score > i) {
          starIcons.add(Icon(Icons.star, color: starColor));
        } else {
          starIcons.add(Icon(Icons.star, color: Colors.black12));
        }
      }
    }
    return starIcons;
  }
}

class RatingScore extends StatelessWidget {
  final SubjectRatingBean ratingBean;
  final String headerImgUrl;

  RatingScore({@required this.ratingBean, this.headerImgUrl});

  @override
  Widget build(BuildContext context) {
    Map map = ratingBean?.details;
    List<Widget> scoreRowList = [];

    if (map != null) {
      int maxScore = 0;
      for (dynamic value in map.values) {
        int v = (value as double).toInt();
        if (v > maxScore) {
          maxScore = v;
        }
      }
      var sortedKeys = map.keys.toList()
        ..sort((a, b) => int.parse(b).compareTo(int.parse(a)));

      for (String key in sortedKeys) {
        int value = (map[key] as double).toInt();
        print("key=$key and value=${value.toString()}");

        Widget w = Row(children: <Widget>[
          Icon(
            Icons.star,
            size: 14.0,
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              key,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: LinearProgressIndicator(
                value: value / maxScore,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white),
              maxLines: 1,
            ),
          )
        ]);

        scoreRowList.add(Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: w,
        ));
      }
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(
          headerImgUrl ?? "",
          fit: BoxFit.fill,
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, 0.7],
            colors: [Colors.black87, Colors.transparent],
          )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: RatingCard(
                    collectCount: 0,
                    averageRating: ratingBean?.average ?? 0,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: scoreRowList,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
