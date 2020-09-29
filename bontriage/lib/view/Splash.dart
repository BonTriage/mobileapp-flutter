import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/WelcomeOnBoardProfileBloc.dart';
import 'package:mobile/util/constant.dart';

import '../util/constant.dart';
import '../util/constant.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {

      Navigator.pushReplacementNamed(context, Constant.welcomeScreenRouter);
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(Constant.splashCompass),
                width: 78,
                height: 78,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                Constant.migraineMentor,
                style: TextStyle(
                    color: Constant.splashTextColor,
                    fontSize: 22,
                    fontFamily: Constant.jostRegular),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Constant.splashColor,
    );
  }
}
