import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/celebrity.dart';
import 'package:flutter_movie_app/model/movie.dart';
import 'package:flutter_movie_app/utils/Util.dart';
import 'package:url_launcher/url_launcher.dart';

const bigText =
    TextStyle(fontFamily: "zhFont", color: Colors.black, fontSize: 22.0);
const smallText =
    TextStyle(fontFamily: "zhFont", color: Colors.black26, fontSize: 16.0);

typedef RelativeMovieCallback(Movie movie, String heroTag);

class CastInfoCard extends StatelessWidget {
  final CelebrityInfo celebrityInfo;

  final RelativeMovieCallback callback;

  CastInfoCard(this.celebrityInfo, {this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      height: MediaQuery.of(context).size.height / 4 * 3,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white30,
            child: Center(
              child: IconButton(
                iconSize: 28.0,
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Color(0xFF152451),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Expanded(child: _createCardBody()),
        ],
      ),
    );
  }

  Widget _createCardBody() {
    List<WorksBean> works = celebrityInfo?.works ?? [];
    return ListView.builder(
        itemCount: 1 + works.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _createCelebrityHeader(context);
          }

          WorksBean worksBean = works[index - 1];
          print("castInfoCard:$worksBean");
          return _createRelativeMovieCell(worksBean, index);
        });
  }

  Widget _createCelebrityHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Image.network(celebrityInfo.avatars.large),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${celebrityInfo.name}(${celebrityInfo.name_en})",
                        style: bigText,
                      ),
                      Text(
                        celebrityInfo.born_place.isEmpty
                            ? ""
                            : "出生地：${celebrityInfo.born_place}",
                        style: smallText,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          _createMoreBtn(context)
        ],
      ),
    );
  }

  Widget _createRelativeMovieCell(WorksBean worksBean, int index) {
    Movie movie = worksBean.subject;
    String heroTag = Util.currentTimeMillis().toString() + index.toString();
    return Card(
      child: ListTile(
        leading: Hero(
          tag: heroTag,
          child: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                movie?.images?.large,
              )),
        ),
        title: Text(
          movie.title ?? "",
          maxLines: 1,
          style: bigText,
        ),
        subtitle: Text(
          _getRolesMsg(worksBean.roles),
          maxLines: 1,
          style: smallText,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.star,
              color: Colors.amber,
            ),
            Text(
              movie?.rating?.average?.toString() ?? "?",
              style: TextStyle(
                color: Color(0xFF152451),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => callback(movie, heroTag),
      ),
    );
  }

  String _getRolesMsg(List<String> roles) {
    if (roles != null) {
      StringBuffer sb = StringBuffer();
      for (int i = 0; i < roles.length; i++) {
        if (i > 0) {
          sb.write("/");
        }
        sb.write(roles[i]);
        return sb.toString();
      }
    }
    return "";
  }

  Widget _createMoreBtn(BuildContext context) {
    String mobileUrl = celebrityInfo.mobile_url;
    if (mobileUrl != null && mobileUrl.isNotEmpty) {
      var btnStyle =
          TextStyle(color: Color(0xFF152451), fontWeight: FontWeight.bold);
      return MaterialButton(
        child: Text("more", style: btnStyle),
        onPressed: () {
          launchURL(mobileUrl);
        },
      );
    }
    return Container();
  }

  launchURL(String url) async {
    print("launchURL:$url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
