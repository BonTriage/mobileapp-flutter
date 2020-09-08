import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/Home.dart';
import 'package:mobile/view/SignUpFirstStepCompassResult.dart';
import 'package:mobile/view/SignUpOnBoardPersonalizedHeadacheCompass.dart';
import 'package:mobile/view/SignUpOnBoardSplash.dart';
import 'package:mobile/view/SignUpOnBoardStartAssessment.dart';
import 'package:mobile/view/Splash.dart';
import 'package:mobile/view/login_screen.dart';
import 'package:mobile/view/part_two_on_board_screens.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'package:mobile/view/sign_up_location_services.dart';
import 'package:mobile/view/sign_up_name_screen.dart';
import 'package:mobile/view/sign_up_on_board_screen.dart';
import 'package:mobile/view/sign_up_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PartTwoOnBoardScreens(),
      routes: {
        Constant.splashRouter: (context) => Splash(),
        Constant.homeRouter: (context) => Home(),
        Constant.loginRouter: (context) => LoginScreen(),
        Constant.signUpRouter: (context) => SignUpScreen(),
        Constant.signUpOnBoardSplashRouter: (context) => SignUpOnBoardSplash(),
        Constant.signUpOnBoardStartAssessmentRouter: (context) =>
            SignUpOnBoardStartAssessment(),

        Constant.signUpNameScreenRouter: (context) => SignUpNameScreen(),
        Constant.signUpAgeScreenRouter: (context) => SignUpAgeScreen(),
        Constant.signUpLocationServiceRouter: (context) =>
            SignUpLocationServices(),
        Constant.signUpOnBoardHeadacheQuestionRouter: (context) =>
            SignUpOnBoardScreen(),
        Constant.signUpFirstStepHeadacheResultRouter: (context) =>
            SignUpFirstStepCompassResult(),
        Constant.signUpOnBoardPersonalizedHeadacheResultRouter: (context)=>
            SignUpOnBoardPersonalizedHeadacheCompass(),
        Constant.partTwoOnBoardScreenRouter: (context) => PartTwoOnBoardScreens()
    },
      debugShowCheckedModeBanner: false,
    );
  }
}
