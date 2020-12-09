import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/animations/ScaleInPageRoute.dart';
import 'package:mobile/animations/SlideFromBottomPageRoute.dart';
import 'package:mobile/animations/SlideFromRightPageRoute.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddHeadacheOnGoingScreen.dart';
import 'package:mobile/view/AddHeadacheSuccessScreen.dart';
import 'package:mobile/view/CalendarHeadacheLogDayDetailsScreen.dart';
import 'package:mobile/view/CalendarScreen.dart';
import 'package:mobile/view/CalendarIntensityScreen.dart';
import 'package:mobile/view/CalendarTriggersScreen.dart';
import 'package:mobile/view/CurrentHeadacheProgressScreen.dart';
import 'package:mobile/view/HeadacheStartedScreen.dart';
import 'package:mobile/view/HomeScreen.dart';
import 'package:mobile/view/LogDayNoHeadacheScreen.dart';
import 'package:mobile/view/LogDayScreen.dart';
import 'package:mobile/view/LogDaySuccessScreen.dart';
import 'package:mobile/view/NotificationScreen.dart';
import 'package:mobile/view/NotificationTimer.dart';
import 'package:mobile/view/OnBoardCreateAccountScreen.dart';
import 'package:mobile/view/OnBoardExitScreen.dart';
import 'package:mobile/view/OnBoardHeadacheInfoScreen.dart';
import 'package:mobile/view/OnBoardHeadacheNameScreen.dart';
import 'package:mobile/view/OnBoardingSignUpScreen.dart';
import 'package:mobile/view/PartOneOnBoardScreenTwo.dart';
import 'package:mobile/view/PartThreeOnBoardScreens.dart';
import 'package:mobile/view/PartTwoOnBoardMoveOnScreen.dart';
import 'package:mobile/view/PostNotificationOnBoardScreen.dart';
import 'package:mobile/view/PostPartThreeOnBoardScreen.dart';
import 'package:mobile/view/PrePartThreeOnBoardScreen.dart';
import 'package:mobile/view/PrePartTwoOnBoardScreen.dart';
import 'package:mobile/view/ProfileComplete.dart';
import 'package:mobile/view/SignUpFirstStepCompassResult.dart';
import 'package:mobile/view/SignUpOnBoardPersonalizedHeadacheCompass.dart';
import 'package:mobile/view/SignUpOnBoardSecondStepPersonalizedHeadacheCompass..dart';
import 'package:mobile/view/SignUpOnBoardSplash.dart';
import 'package:mobile/view/SignUpOnBoardStartAssessment.dart';
import 'package:mobile/view/SignUpSecondStepCompassResult.dart';
import 'package:mobile/view/Splash.dart';
import 'package:mobile/view/WelcomeStartAssessmentScreen.dart';
import 'package:mobile/view/WelcomeScreen.dart';
import 'package:mobile/view/login_screen.dart';
import 'package:mobile/view/part_two_on_board_screens.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'package:mobile/view/sign_up_location_services.dart';
import 'package:mobile/view/sign_up_name_screen.dart';
import 'package:mobile/view/sign_up_on_board_screen.dart';
import 'package:mobile/view/sign_up_screen.dart';

import 'util/constant.dart';
import 'view/SignUpOnBoardBubbleTextView.dart';
import 'view/SignUpOnBoardSplash.dart';
import 'view/Splash.dart';
import 'view/sign_up_on_board_screen.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
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
        accentColor: Constant.backgroundColor,

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Constant.splashRouter:
            {
              return SlideFromBottomPageRoute(widget: Splash());
            }
          case Constant.welcomeScreenRouter:
            {
              return SlideFromRightPageRoute(widget: WelcomeScreen());
            }
          case Constant.homeRouter:
            {
              return SlideFromRightPageRoute(widget: HomeScreen());
            }
          case Constant.loginRouter:
            {
              return SlideFromRightPageRoute(widget: LoginScreen());
            }
          case Constant.signUpRouter:
            {
              return SlideFromBottomPageRoute(widget: SignUpScreen());
            }
          case Constant.signUpOnBoardSplashRouter:
            {
              return SlideFromBottomPageRoute(widget: SignUpOnBoardSplash());
            }
          case Constant.signUpOnBoardStartAssessmentRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: SignUpOnBoardStartAssessment());
            }
          case Constant.signUpNameScreenRouter:
            {
              return SlideFromRightPageRoute(widget: SignUpNameScreen());
            }
          case Constant.signUpAgeScreenRouter:
            {
              return SlideFromRightPageRoute(widget: SignUpAgeScreen());
            }
          case Constant.signUpLocationServiceRouter:
            {
              return SlideFromRightPageRoute(widget: SignUpLocationServices());
            }
          case Constant.signUpOnBoardProfileQuestionRouter:
            {
              return SlideFromBottomPageRoute(widget: SignUpOnBoardScreen());
            }
          case Constant.signUpFirstStepHeadacheResultRouter:
            {
              return ScaleInPageRoute(
                  widget: SignUpFirstStepCompassResult());
            }
          case Constant.signUpOnBoardPersonalizedHeadacheResultRouter:
            {
              return ScaleInPageRoute(
                  widget: SignUpOnBoardPersonalizedHeadacheCompass());
            }
          case Constant.partTwoOnBoardScreenRouter:
            {
              String argsName = settings.arguments;
              return SlideFromRightPageRoute(
                  widget: PartTwoOnBoardScreens(
                      argumentsName: (argsName != null)
                          ? argsName
                          : Constant.clinicalImpressionShort1));
            }
          case Constant.partThreeOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PartThreeOnBoardScreens());
            }
          case Constant.loginScreenRouter:
            {
              return SlideFromRightPageRoute(widget: LoginScreen());
            }
          case Constant.onBoardingScreenSignUpRouter:
            {
              return SlideFromRightPageRoute(widget: OnBoardingSignUpScreen());
            }
          case Constant.signUpSecondStepHeadacheResultRouter:
            {
              return ScaleInPageRoute(
                  widget: SignUpSecondStepCompassResult());
            }
          case Constant.signUpOnBoardSecondStepPersonalizedHeadacheResultRouter:
            {
              return ScaleInPageRoute(
                  widget: SignUpOnBoardSecondStepPersonalizedHeadacheCompass());
            }
          case Constant.welcomeScreenRouter:
            {
              return SlideFromRightPageRoute(widget: WelcomeScreen());
            }
          case Constant.welcomeStartAssessmentScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: WelcomeStartAssessmentScreen());
            }
          case Constant.onBoardHeadacheInfoScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: OnBoardHeadacheInfoScreen());
            }
          case Constant.partOneOnBoardScreenTwoRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PartOneOnBoardScreenTwo());
            }
          case Constant.onBoardCreateAccountScreenRouter:
            {
              return SlideFromRightPageRoute(widget: OnBoardCreateAccount());
            }
          case Constant.prePartTwoOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PrePartTwoOnBoardScreen());
            }
          case Constant.onBoardHeadacheNameScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: OnBoardHeadacheNameScreen());
            }
          case Constant.partTwoOnBoardMoveOnScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PartTwoOnBoardMoveOnScreen());
            }
          case Constant.prePartThreeOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PrePartThreeOnBoardScreen());
            }
          case Constant.signUpOnBoardBubbleTextViewRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: SignUpOnBoardBubbleTextView());
            }
          case Constant.postPartThreeOnBoardRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PostPartThreeOnBoardScreen());
            }
          case Constant.postNotificationOnBoardRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PostNotificationOnBoardScreen());
            }
          case Constant.notificationScreenRouter:
            {
              return SlideFromRightPageRoute(widget: NotificationScreen());
            }
          case Constant.headacheStartedScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: HeadacheStartedScreen());
            }
          case Constant.currentHeadacheProgressScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: CurrentHeadacheProgressScreen());
            }
          case Constant.addHeadacheOnGoingScreenRouter:
            {
              final Widget widget = AddHeadacheOnGoingScreen(
                currentUserHeadacheModel: settings.arguments,
              );
              return SlideFromBottomPageRoute(
                  widget: widget);
            }

          case Constant.logDayScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: LogDayScreen(selectedDateTime: settings.arguments));
            }
          case Constant.addHeadacheSuccessScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: AddHeadacheSuccessScreen());
            }
          case Constant.logDaySuccessScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: LogDaySuccessScreen());
            }
          case Constant.profileCompleteScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: ProfileComplete());
            }
          case Constant.notificationTimerRouter:
            {
              return SlideFromBottomPageRoute(widget: NotificationTimer());
            }
          case Constant.calendarTriggersScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CalendarTriggersScreen());
            }
          case Constant.calendarSeverityScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CalendarIntensityScreen());
            }
          case Constant.logDayNoHeadacheScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: LogDayNoHeadacheScreen());
            }
          case Constant.calenderScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CalendarScreen());
            }
          case Constant.onCalendarHeadacheLogDayDetailsScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CalendarHeadacheLogDayDetailsScreen(dateTime: settings.arguments,));
            }

          case Constant.onBoardExitScreenRouter:
            {
              bool isUserAlreadyLoggedIn = settings.arguments;
              return SlideFromRightPageRoute(
                  widget: OnBoardExitScreen(
                      isAlreadyLoggedIn: (isUserAlreadyLoggedIn != null)
                          ? isUserAlreadyLoggedIn
                          : false));
            }
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
