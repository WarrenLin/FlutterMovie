import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CupertinoActivityIndicator(radius: 6.0),
      ),
    );
  }
}
