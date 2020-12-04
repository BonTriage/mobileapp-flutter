import 'package:flutter/material.dart';

class ScaleInPageRoute extends PageRouteBuilder {
  final Widget widget;

  ScaleInPageRoute({this.widget}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return ScaleTransition(
        alignment: Alignment.center,
        scale: animation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 350),
  );
}