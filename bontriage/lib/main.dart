import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/animations/ScaleInPageRoute.dart';
import 'package:mobile/animations/SlideFromBottomPageRoute.dart';
import 'package:mobile/animations/SlideFromRightPageRoute.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddHeadacheOnGoingScreen.dart';
import 'package:mobile/view/AddHeadacheSuccessScreen.dart';
import 'package:mobile/view/CalendarHeadacheLogDayDetailsScreen.dart';
import 'package:mobile/view/CalendarScreen.dart';
import 'package:mobile/view/CalendarIntensityScreen.dart';
import 'package:mobile/view/CalendarTriggersScreen.dart';
import 'package:mobile/view/ChangePasswordScreen.dart';
import 'package:mobile/view/CompassScreen.dart';
import 'package:mobile/view/CurrentHeadacheProgressScreen.dart';
import 'package:mobile/view/HeadacheStartedScreen.dart';
import 'package:mobile/view/HomeScreen.dart';
import 'package:mobile/view/LogDayNoHeadacheScreen.dart';
import 'package:mobile/view/LogDayScreen.dart';
import 'package:mobile/view/LogDaySuccessScreen.dart';
import 'package:mobile/view/MoreNotificationScreen.dart';
import 'package:mobile/view/NotificationScreen.dart';
import 'package:mobile/view/NotificationTimer.dart';
import 'package:mobile/view/OnBoardCreateAccountScreen.dart';
import 'package:mobile/view/OnBoardExitScreen.dart';
import 'package:mobile/view/OnBoardHeadacheInfoScreen.dart';
import 'package:mobile/view/OnBoardHeadacheNameScreen.dart';
import 'package:mobile/view/OnBoardingSignUpScreen.dart';
import 'package:mobile/view/OtpValidationScreen.dart';
import 'package:mobile/view/PDFScreen.dart';
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
import 'package:mobile/view/WebViewScreen.dart';
import 'package:mobile/view/WelcomeStartAssessmentScreen.dart';
import 'package:mobile/view/WelcomeScreen.dart';
import 'package:mobile/view/login_screen.dart';
import 'package:mobile/view/part_two_on_board_screens.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'package:mobile/view/sign_up_location_services.dart';
import 'package:mobile/view/sign_up_name_screen.dart';
import 'package:mobile/view/sign_up_on_board_screen.dart';

import 'util/constant.dart';
import 'view/SignUpOnBoardBubbleTextView.dart';
import 'view/SignUpOnBoardSplash.dart';
import 'view/Splash.dart';
import 'view/sign_up_on_board_screen.dart';

void main() {
  Paint.enableDithering = true;

  ///Uncomment the below code when providing the build to tester for automation.
  //enableFlutterDriverExtension();
  runApp(MyApp());
}

Map<int, Color> color =
{
  50:Constant.chatBubbleGreen,
  100:Constant.chatBubbleGreen,
  200:Constant.chatBubbleGreen,
  300:Constant.chatBubbleGreen,
  400:Constant.chatBubbleGreen,
  500:Constant.chatBubbleGreen,
  600:Constant.chatBubbleGreen,
  700:Constant.chatBubbleGreen,
  800:Constant.chatBubbleGreen,
  900:Constant.chatBubbleGreen,
};

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
        primarySwatch: MaterialColor(0xffafd794, color),
      ),
      home: Scaffold(body : Splash()),
      onGenerateRoute: (settings) {
        RouteSettings routeSettings = RouteSettings(name: settings.name);
        switch (settings.name) {
          case Constant.splashRouter:
            {
              return SlideFromBottomPageRoute(widget: Splash(), routeSettings: routeSettings);
            }
          case Constant.welcomeScreenRouter:
            {
              return SlideFromRightPageRoute(widget: WelcomeScreen(), routeSettings: routeSettings);
            }
          case Constant.homeRouter:
            {
              return SlideFromRightPageRoute(widget: HomeScreen(homeScreenArgumentModel: settings.arguments), routeSettings: routeSettings);
            }
          case Constant.loginRouter:
            {
              return SlideFromRightPageRoute(widget: LoginScreen(isFromSignUp: settings.arguments,), routeSettings: routeSettings);
            }
          case Constant.signUpOnBoardSplashRouter:
            {
              return SlideFromBottomPageRoute(widget: SignUpOnBoardSplash(), routeSettings: routeSettings);
            }
          case Constant.signUpOnBoardStartAssessmentRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: SignUpOnBoardStartAssessment(), routeSettings: routeSettings);
            }
          case Constant.signUpNameScreenRouter:
            {
              return SlideFromRightPageRoute(widget: SignUpNameScreen(), routeSettings: routeSettings);
            }
          case Constant.signUpAgeScreenRouter:
            {
              return SlideFromRightPageRoute(widget: SignUpAgeScreen(), routeSettings: routeSettings);
            }
          case Constant.signUpLocationServiceRouter:
            {
              return SlideFromRightPageRoute(widget: SignUpLocationServices(), routeSettings: routeSettings);
            }
          case Constant.signUpOnBoardProfileQuestionRouter:
            {
              return SlideFromBottomPageRoute(widget: SignUpOnBoardScreen(), routeSettings: routeSettings);
            }
          case Constant.signUpFirstStepHeadacheResultRouter:
            {
              return ScaleInPageRoute(widget: SignUpFirstStepCompassResult(), routeSettings: routeSettings);
            }
          case Constant.signUpOnBoardPersonalizedHeadacheResultRouter:
            {
              return ScaleInPageRoute(
                  widget: SignUpOnBoardPersonalizedHeadacheCompass(), routeSettings: routeSettings);
            }
          case Constant.partTwoOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PartTwoOnBoardScreens(
                    partTwoOnBoardArgumentModel: settings.arguments,
                  ),
                routeSettings: routeSettings,
              );
            }
          case Constant.partThreeOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(widget: PartThreeOnBoardScreens(), routeSettings: routeSettings);
            }
          case Constant.loginScreenRouter:
            {
              return SlideFromRightPageRoute(widget: LoginScreen(isFromSignUp: settings.arguments,), routeSettings: routeSettings);
            }
          case Constant.onBoardingScreenSignUpRouter:
            {
              return SlideFromRightPageRoute(widget: OnBoardingSignUpScreen(), routeSettings: routeSettings);
            }
          case Constant.signUpSecondStepHeadacheResultRouter:
            {
              return ScaleInPageRoute(widget: SignUpSecondStepCompassResult(), routeSettings: routeSettings);
            }
          case Constant.signUpOnBoardSecondStepPersonalizedHeadacheResultRouter:
            {
              return ScaleInPageRoute(
                  widget: SignUpOnBoardSecondStepPersonalizedHeadacheCompass(), routeSettings: routeSettings);
            }
          case Constant.welcomeScreenRouter:
            {
              return SlideFromRightPageRoute(widget: WelcomeScreen(), routeSettings: routeSettings);
            }
          case Constant.welcomeStartAssessmentScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: WelcomeStartAssessmentScreen(), routeSettings: routeSettings);
            }
          case Constant.onBoardHeadacheInfoScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: OnBoardHeadacheInfoScreen(), routeSettings: routeSettings);
            }
          case Constant.partOneOnBoardScreenTwoRouter:
            {
              return SlideFromRightPageRoute(widget: PartOneOnBoardScreenTwo(), routeSettings: routeSettings);
            }
          case Constant.onBoardCreateAccountScreenRouter:
            {
              return SlideFromRightPageRoute(widget: OnBoardCreateAccount(), routeSettings: routeSettings);
            }
          case Constant.prePartTwoOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(widget: PrePartTwoOnBoardScreen(), routeSettings: routeSettings);
            }
          case Constant.onBoardHeadacheNameScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: OnBoardHeadacheNameScreen(), routeSettings: routeSettings);
            }
          case Constant.partTwoOnBoardMoveOnScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PartTwoOnBoardMoveOnScreen(), routeSettings: routeSettings);
            }
          case Constant.prePartThreeOnBoardScreenRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PrePartThreeOnBoardScreen(), routeSettings: routeSettings);
            }
          case Constant.signUpOnBoardBubbleTextViewRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: SignUpOnBoardBubbleTextView(), routeSettings: routeSettings);
            }
          case Constant.postPartThreeOnBoardRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PostPartThreeOnBoardScreen(), routeSettings: routeSettings);
            }
          case Constant.postNotificationOnBoardRouter:
            {
              return SlideFromRightPageRoute(
                  widget: PostNotificationOnBoardScreen(), routeSettings: routeSettings);
            }
          case Constant.notificationScreenRouter:
            {
              return SlideFromRightPageRoute(widget: NotificationScreen(), routeSettings: routeSettings);
            }
          case Constant.headacheStartedScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: HeadacheStartedScreen(), routeSettings: routeSettings);
            }
          case Constant.currentHeadacheProgressScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: CurrentHeadacheProgressScreen(currentUserHeadacheModel: settings.arguments,), routeSettings: routeSettings);
            }
          case Constant.addHeadacheOnGoingScreenRouter:
            {
              final Widget widget = AddHeadacheOnGoingScreen(
                currentUserHeadacheModel: settings.arguments,
              );
              return SlideFromBottomPageRoute(widget: widget, routeSettings: routeSettings);
            }

          case Constant.logDayScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: LogDayScreen(logDayScreenArgumentModel: settings.arguments), routeSettings: routeSettings);

            }
          case Constant.addHeadacheSuccessScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: AddHeadacheSuccessScreen(), routeSettings: routeSettings);
            }
          case Constant.logDaySuccessScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: LogDaySuccessScreen(), routeSettings: routeSettings);
            }
          case Constant.profileCompleteScreenRouter:
            {
              return SlideFromRightPageRoute(widget: ProfileComplete(), routeSettings: routeSettings);

            }
          case Constant.notificationTimerRouter:
            {
              return SlideFromBottomPageRoute(widget: NotificationTimer(), routeSettings: routeSettings);
            }
          case Constant.calendarTriggersScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CalendarTriggersScreen(), routeSettings: routeSettings);
            }
          case Constant.calendarSeverityScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: CalendarIntensityScreen(), routeSettings: routeSettings);
            }
          case Constant.logDayNoHeadacheScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: LogDayNoHeadacheScreen(), routeSettings: routeSettings);
            }
          case Constant.calenderScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CalendarScreen(), routeSettings: routeSettings);
            }
          case Constant.onCalendarHeadacheLogDayDetailsScreenRouter:
            {
              return SlideFromBottomPageRoute(
                  widget: CalendarHeadacheLogDayDetailsScreen(
                dateTime: settings.arguments,
              ), routeSettings: routeSettings);
            }

          case Constant.onBoardExitScreenRouter:
            {
              bool isUserAlreadyLoggedIn = settings.arguments;
              return SlideFromRightPageRoute(
                  widget: OnBoardExitScreen(
                      isAlreadyLoggedIn: (isUserAlreadyLoggedIn != null)
                          ? isUserAlreadyLoggedIn
                          : false), routeSettings: routeSettings);
            }
          case Constant.compassScreenRouter:
            {
              return SlideFromBottomPageRoute(widget: CompassScreen(), routeSettings: routeSettings);
            }
          case Constant.webViewScreenRouter:
            {
              return SlideFromRightPageRoute(widget: WebViewScreen(url: settings.arguments,), routeSettings: routeSettings);
            }
          case Constant.otpValidationScreenRouter:
            {
              return SlideFromRightPageRoute(widget: OtpValidationScreen(otpValidationArgumentModel: settings.arguments,), routeSettings: routeSettings);
            }
          case Constant.changePasswordScreenRouter:
            {
              return SlideFromRightPageRoute(widget: ChangePasswordScreen(changePasswordArgumentModel: settings.arguments), routeSettings: routeSettings);
            }
          case TabNavigatorRoutes.pdfScreenRoute:
            {
              return SlideFromBottomPageRoute(widget: PDFScreen(base64String: settings.arguments), routeSettings: routeSettings);
            }
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
