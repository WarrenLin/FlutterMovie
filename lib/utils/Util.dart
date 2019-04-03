import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static int currentTimeMillis() => DateTime.now().millisecondsSinceEpoch;

  static TextStyle fontCh() => TextStyle(fontFamily: "zhFont");

  static void launchURL(String url) async {
    print("launchURL:$url");
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static void addIfNonNull(List<Widget> collectedWidgets, Widget widget) {
    if (widget != null) {
      collectedWidgets.add(widget);
    }
  }
}
