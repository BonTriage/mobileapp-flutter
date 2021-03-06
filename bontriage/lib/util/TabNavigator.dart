import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/animations/SlideFromBottomPageRoute.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/view/DiscoverScreen.dart';
import 'package:mobile/view/MeScreen.dart';
import 'package:mobile/view/MoreAgeScreen.dart';
import 'package:mobile/view/MoreFaqScreen.dart';
import 'package:mobile/view/MoreGenderScreen.dart';
import 'package:mobile/view/MoreGenerateReportScreen.dart';
import 'package:mobile/view/MoreHeadachesScreen.dart';
import 'package:mobile/view/MoreLocationServicesScreen.dart';
import 'package:mobile/view/MoreMedicationScreen.dart';
import 'package:mobile/view/MoreMyProfileScreen.dart';
import 'package:mobile/view/MoreNameScreen.dart';
import 'package:mobile/view/MoreNotificationScreen.dart';
import 'package:mobile/view/MoreScreen.dart';
import 'package:mobile/view/MoreSettingScreen.dart';
import 'package:mobile/view/MoreSexScreen.dart';
import 'package:mobile/view/MoreSupportScreen.dart';
import 'package:mobile/view/MoreTriggersScreen.dart';
import 'package:mobile/view/PDFScreen.dart';
import 'package:mobile/view/RecordScreen.dart';


class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String root;
  final Future<dynamic> Function(String,dynamic) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;
  final Function(GlobalKey, GlobalKey) getButtonsGlobalKeyCallback;

  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;

  final Function(Questions questions, Function(int) selectedAnswerCallback) openTriggerMedicationActionSheetCallback;
  final Future<DateTime> Function (CupertinoDatePickerMode, Function, DateTime) openDatePickerCallback;

  TabNavigator({this.navigatorKey, this.root, this.openActionSheetCallback,this.navigateToOtherScreenCallback, this.openTriggerMedicationActionSheetCallback, this.showApiLoaderCallback, this.getButtonsGlobalKeyCallback, this.openDatePickerCallback});


  Future<dynamic> _push(BuildContext context, String routeName, dynamic argument) async {
    var routeBuilders = _routeBuilders(context, argument);

    print('RouteName???$routeName');

    return await Navigator.push(
        context,
        routeName == TabNavigatorRoutes.pdfScreenRoute ? SlideFromBottomPageRoute(
          widget: routeBuilders[routeName](context),
        ) : PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              routeBuilders[routeName](context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 350),
          settings: RouteSettings(name: routeName),
        ));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, dynamic arguments) {
    return {
      TabNavigatorRoutes.root: (context) {
        print('Root name: $root');
       return Container();
      },
      TabNavigatorRoutes.meRoot: (context) => MeScreen(
          navigateToOtherScreenCallback: navigateToOtherScreenCallback,
        showApiLoaderCallback: showApiLoaderCallback,
        getButtonsGlobalKeyCallback: getButtonsGlobalKeyCallback,
      ),
      TabNavigatorRoutes.pdfScreenRoute: (context) => PDFScreen(
        base64String: arguments,
      ),
      TabNavigatorRoutes.recordsRoot: (context) =>
          RecordScreen(
              onPush: (context, routeName) {
                _push(context, routeName, arguments);
              },
            navigateToOtherScreenCallback: navigateToOtherScreenCallback,
            showApiLoaderCallback: showApiLoaderCallback,
            openActionSheetCallback: openActionSheetCallback,
            openDatePickerCallback: openDatePickerCallback,
          ),
      TabNavigatorRoutes.discoverRoot: (context) =>
          DiscoverScreen(onPush: (context, routeName) {
            _push(context, routeName, arguments);
          }),
      TabNavigatorRoutes.moreRoot: (context) => MoreScreen(
            onPush: _push,
            openActionSheetCallback: openActionSheetCallback,
            showApiLoaderCallback: showApiLoaderCallback,
            navigateToOtherScreenCallback: navigateToOtherScreenCallback,
          ),
      TabNavigatorRoutes.moreSettingRoute: (context) => MoreSettingScreen(

            onPush: _push,
          ),

      TabNavigatorRoutes.moreMyProfileScreenRoute: (context) => MoreMyProfileScreen(
        onPush: _push,
        showApiLoaderCallback: showApiLoaderCallback,
      ),

      TabNavigatorRoutes.moreGenerateReportRoute: (context) =>
          MoreGenerateReportScreen(
            onPush: _push,
            openActionSheetCallback: openActionSheetCallback,
          ),
      TabNavigatorRoutes.moreSupportRoute: (context) => MoreSupportScreen(
            onPush: _push,
          ),
      TabNavigatorRoutes.moreFaqScreenRoute: (context) => MoreFaqScreen(),

      TabNavigatorRoutes.moreNotificationScreenRoute: (context) => MoreNotificationScreen(
        openActionSheetCallback: openActionSheetCallback,
      ),
      TabNavigatorRoutes.moreHeadachesScreenRoute: (context) => MoreHeadachesScreen(
        openActionSheetCallback: openActionSheetCallback,
        moreHeadacheScreenArgumentModel: arguments,
        showApiLoaderCallback: showApiLoaderCallback,
        navigateToOtherScreenCallback: navigateToOtherScreenCallback,
        onPush: _push,
      ),
      TabNavigatorRoutes.moreLocationServicesScreenRoute: (context) => MoreLocationServicesScreen(),
      TabNavigatorRoutes.moreNameScreenRoute: (context) => MoreNameScreen(
        selectedAnswerList: arguments,
        openActionSheetCallback: openActionSheetCallback,
      ),
      TabNavigatorRoutes.moreAgeScreenRoute: (context) => MoreAgeScreen(
        selectedAnswerList: arguments,
        openActionSheetCallback: openActionSheetCallback,
      ),
      TabNavigatorRoutes.moreGenderScreenRoute: (context) => MoreGenderScreen(
        selectedAnswerList: arguments,
        openActionSheetCallback: openActionSheetCallback,
      ),
      TabNavigatorRoutes.moreSexScreenRoute: (context) => MoreSexScreen(
        selectedAnswerList: arguments,
        openActionSheetCallback: openActionSheetCallback,
      ),
      TabNavigatorRoutes.moreTriggersScreenRoute: (context) => MoreTriggersScreen(
        openTriggerMedicationActionSheetCallback: openTriggerMedicationActionSheetCallback,
        openActionSheetCallback: openActionSheetCallback,
        moreTriggersArgumentModel: arguments,
        showApiLoaderCallback: showApiLoaderCallback,
      ),
      TabNavigatorRoutes.moreMedicationsScreenRoute: (context) => MoreMedicationScreen(
        openTriggerMedicationActionSheetCallback: openTriggerMedicationActionSheetCallback,
        moreMedicationArgumentModel: arguments,
        showApiLoaderCallback: showApiLoaderCallback,
        openActionSheetCallback: openActionSheetCallback,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context, null);

    return Navigator(
        key: navigatorKey,
        initialRoute: root,
        onGenerateRoute: (routeSettings) {
          print('Route name ${routeSettings.name}');
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context),
              settings: RouteSettings(name: routeSettings.name),
          );
        },
    );
  }
}
