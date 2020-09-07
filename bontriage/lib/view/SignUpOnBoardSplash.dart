import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile/util/PhotoHero.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/SignUpOnBoardBubbleTextView.dart';

import 'ChatBubbleLeftPointed.dart';

class SignUpOnBoardSplash extends StatefulWidget {
  @override
  _SignUpOnBoardSplashState createState() => _SignUpOnBoardSplashState();
}

class _SignUpOnBoardSplashState extends State<SignUpOnBoardSplash> {


  Widget build(BuildContext context) {
    timeDilation = 4.0; // 1.0 means normal animation speed.
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute<void>(builder: (BuildContext context) {
        return SignUpOnBoardBubbleTextView();
      }));
    });
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: Center(
          child: PhotoHero(
            photo: 'images/user_avatar.png',
            width: 120.0,
          ),
        ),
      ),
    );
  }
}
