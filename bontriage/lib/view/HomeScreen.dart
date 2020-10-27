import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigator.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/GenerateReportActionSheet.dart';
import 'package:mobile/view/MedicalHelpActionSheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  Map<int, GlobalKey<NavigatorState>> navigatorKey = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
      !await navigatorKey[currentIndex].currentState.maybePop(),
      child: Scaffold(
        body: Container(
          decoration: Constant.backgroundBoxDecoration,
          child: Stack(
            children: [
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
              _buildOffstageNavigator(2),
              _buildOffstageNavigator(3),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constant.backgroundColor,
          currentIndex: currentIndex,
          selectedItemColor: Constant.chatBubbleGreen,
          unselectedItemColor: Constant.unselectedTextColor,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/me_unselected.png',
                height: 25,
              ),
              activeIcon: Image.asset(
                'images/me_selected.png',
                height: 25,
              ),
              title: Text(
                'ME',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/records_unselected.png',
                height: 25,
              ),
              activeIcon: Image.asset(
                'images/records_selected.png',
                height: 25,
              ),
              title: Text(
                'RECORDS',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/discover_unselected.png',
                height: 25,
              ),
              activeIcon: Image.asset(
                'images/discover_unselected.png',
                height: 25,
              ),
              title: Text(
                'DISCOVER',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/more_unselected.png',
                height: 25,
                width: 30,
              ),
              activeIcon: Image.asset(
                'images/more_unselected.png',
                height: 25,
                width: 30,
              ),
              title: Text(
                'MORE',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
  
  String _getRootRoute(int index) {
    switch(index) {
      case 0:
        return TabNavigatorRoutes.meRoot;
      case 1:
        return TabNavigatorRoutes.recordsRoot;
      case 2:
        return TabNavigatorRoutes.discoverRoot;
      default:
        return TabNavigatorRoutes.moreRoot;
    }
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: currentIndex != index,
      child: TabNavigator(
        navigatorKey: navigatorKey[index],
        root: _getRootRoute(index),
        openActionSheetCallback: _openActionSheet,
      ),
    );
  }

  void _openActionSheet(String actionSheetType) async {
    switch(actionSheetType) {
      case Constant.medicalHelpActionSheet:
        var resultOfActionSheet = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (context) => MedicalHelpActionSheet()
        );
        break;
      case Constant.generateReportActionSheet:
        var resultOfActionSheet = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (context) => GenerateReportActionSheet()
        );
        break;
    }
  }
}
