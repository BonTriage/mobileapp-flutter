import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

import '../util/constant.dart';
import '../util/constant.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2000),(){Navigator.pushReplacementNamed(context,Constant.welcomeScreenRouter);});
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(Constant.brain),
                width: 56,
                height: 50,
              ),
              SizedBox(width: 10,),
              Text(
                Constant.migraineMentor,
                style: TextStyle(
                  color: Constant.splashTextColor,
                  fontSize: 22,
                  fontFamily: Constant.futuraMaxiLight
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Constant.splashColor,
    );
  }
}
