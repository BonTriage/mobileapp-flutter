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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacementNamed(Constant.signUpOnBoardBubbleTextViewRouter);
      });
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          decoration: Constant.backgroundBoxDecoration,
          child: Center(
            child: PhotoHero(
              photo: Constant.userAvatar,
              width: 130.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return true;
  }
}
