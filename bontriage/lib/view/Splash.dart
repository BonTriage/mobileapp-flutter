import 'dart:async';
import 'dart:io';

//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/CheckVersionUpdateBloc.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/constant.dart';
import 'package:mobile/models/VersionUpdateModel.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer _timer;
  CheckVersionUpdateBloc _checkVersionUpdateBloc;

  @override
  void initState() {
    super.initState();
    _checkVersionUpdateBloc = CheckVersionUpdateBloc();
    _listenToNetworkStreamController();
    _checkCriticalVersionUpdate();
  }

  @override
  void dispose() {
    try {
      _checkVersionUpdateBloc.dispose();
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
    sharedPreferences.remove(Constant.updateMeScreenData);
  }

  /// This method will be use for to check critical update from server.So if get critical update from server. So
  /// we will show a popup to the user. if it's nt then we move to user into Home Screen.
  void _checkCriticalVersionUpdate() async {
    VersionUpdateModel responseData = await _checkVersionUpdateBloc.checkVersionUpdateData();
    if(responseData != null) {
      if(kIsWeb) {
        getTutorialsState();
      } else {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        int appVersionNumber = int.tryParse(
            packageInfo.version.replaceAll('.', ''));
        if (Platform.isAndroid) {
          int serverVersionNumber = int.tryParse(
              responseData.androidVersion.replaceAll('.', ''));
          if (serverVersionNumber > appVersionNumber &&
              responseData.androidCritical) {
            Utils.showCriticalUpdateDialog(
                context, responseData.androidBuildDetails);
          } else {
            getTutorialsState();
          }
        } else if (Platform.isIOS) {
          int serverVersionNumber = int.tryParse(
              responseData.iosVersion.replaceAll('.', ''));
          if (serverVersionNumber > appVersionNumber &&
              responseData.iosCritical) {
            Utils.showCriticalUpdateDialog(context, responseData.description);
          } else {
            int serverVersionNumber = int.tryParse(
                responseData.iosVersion.replaceAll('.', ''));
            if (serverVersionNumber > appVersionNumber &&
                responseData.iosCritical) {
              Utils.showCriticalUpdateDialog(context, responseData.description);
            } else {
              getTutorialsState();
            }
          }
        } else {
          getTutorialsState();
        }
      }
    }
  }

  void _listenToNetworkStreamController() {
    _checkVersionUpdateBloc.networkStream.listen((event) {
      if(event is String && event != null && event.isNotEmpty) {
        final snackBar = SnackBar(content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragStart: (_) => debugPrint("no can do!"),
          child: Text(event,style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Colors.black)),
          ),
          backgroundColor: Constant.chatBubbleGreen,
          duration: Duration(days: 3),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _checkCriticalVersionUpdate();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}