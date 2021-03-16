import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/constant.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    getTutorialsState();
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MediaQuery(
        data: mediaQueryData.copyWith(
            textScaleFactor: 1.0
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                getTutorialsState();
              },
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
        ),
      ),
      backgroundColor: Constant.splashColor,
    );
  }

  void getTutorialsState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isTutorialsHasSeen =
        sharedPreferences.getBool(Constant.tutorialsState);
    var userAlreadyLoggedIn =
    sharedPreferences.getBool(Constant.userAlreadyLoggedIn);

    _removeKeysFromSharedPreference(sharedPreferences);
    if(userAlreadyLoggedIn != null && userAlreadyLoggedIn) {
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        Navigator.pushReplacementNamed(context, Constant.homeRouter);
        timer.cancel();
      });
    } else {
      if (isTutorialsHasSeen != null && isTutorialsHasSeen) {
        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
          Navigator.pushReplacementNamed(context, Constant.welcomeStartAssessmentScreenRouter);
          timer.cancel();
        });
      } else {
        if (userAlreadyLoggedIn == null || !userAlreadyLoggedIn) {
          _timer = Timer.periodic(Duration(seconds: 2), (timer) {
            Navigator.pushReplacementNamed(context, Constant.welcomeScreenRouter);
            timer.cancel();
          });
        } else {
          _timer = Timer.periodic(Duration(seconds: 2), (timer) {
            Navigator.pushReplacementNamed(context, Constant.homeRouter);
            timer.cancel();
          });
        }
      }
    }
  }

  void _removeKeysFromSharedPreference(SharedPreferences sharedPreferences) {
    sharedPreferences.remove(Constant.updateCalendarTriggerData);
    sharedPreferences.remove(Constant.updateCalendarIntensityData);
    sharedPreferences.remove(Constant.updateOverTimeCompassData);
    sharedPreferences.remove(Constant.updateCompareCompassData);
    sharedPreferences.remove(Constant.updateTrendsData);
    sharedPreferences.remove(Constant.isSeeMoreClicked);
    sharedPreferences.remove(Constant.isViewTrendsClicked);
  }
}
