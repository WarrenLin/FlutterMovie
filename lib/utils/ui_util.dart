import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class UIUtil{

  static void showLoadingDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                  padding: EdgeInsets.all(15.0),
                  width: 90.0,
                  height: 90.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoActivityIndicator(radius: 16.0),
                      Text(
                        "讀取中...",
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  )),
            ),
          );
        });
  }

}