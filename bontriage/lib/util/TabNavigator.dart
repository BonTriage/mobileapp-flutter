import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/view/DemoMeScreen.dart';
import 'package:mobile/view/DiscoverScreen.dart';
import 'package:mobile/view/MoreFaqScreen.dart';
import 'package:mobile/view/MoreGenerateReportScreen.dart';
import 'package:mobile/view/MoreMyInfoScreen.dart';
import 'package:mobile/view/MoreNotificationScreen.dart';
import 'package:mobile/view/MoreScreen.dart';
import 'package:mobile/view/MoreSettingScreen.dart';
import 'package:mobile/view/MoreSupportScreen.dart';
import 'package:mobile/view/RecordScreen.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String root;
  final Function(String) openActionSheetCallback;

  TabNavigator({this.navigatorKey, this.root, this.openActionSheetCallback});

  void _push(BuildContext context, String routeName) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
        context,
        PageRouteBuilder(
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
        ));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) =>
          DemoMeScreen(onPush: (context, routeName) {
            _push(context, routeName);
          }),
      TabNavigatorRoutes.meRoot: (context) =>
          DemoMeScreen(onPush: (context, routeName) {
            _push(context, routeName);
          }),
      TabNavigatorRoutes.recordsRoot: (context) =>
          RecordScreen(onPush: (context, routeName) {
            _push(context, routeName);
          }),
      TabNavigatorRoutes.discoverRoot: (context) =>
          DiscoverScreen(onPush: (context, routeName) {
            _push(context, routeName);
          }),
      TabNavigatorRoutes.moreRoot: (context) => MoreScreen(
            onPush: (context, routeName) {
              _push(context, routeName);
            },
            openActionSheetCallback: (actionSheetType) {
              openActionSheetCallback(actionSheetType);
            },
          ),
      TabNavigatorRoutes.moreSettingRoute: (context) => MoreSettingScreen(
        onPush: _push,
      ),
      TabNavigatorRoutes.moreMyInfoScreenRoute: (context) => MoreMyInfoScreen(),
      TabNavigatorRoutes.moreGenerateReportRoute: (context) =>
          MoreGenerateReportScreen(
            onPush: (context, routeName) {
              _push(context, routeName);
            },
            openActionSheetCallback: (actionSheetType) {
              openActionSheetCallback(actionSheetType);
            },
          ),
      TabNavigatorRoutes.moreSupportRoute: (context) => MoreSupportScreen(
        onPush: _push,
      ),
      TabNavigatorRoutes.moreFaqScreenRoute: (context) => MoreFaqScreen(),
      TabNavigatorRoutes.moreNotificationScreenRoute: (context) => MoreNotificationScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}
