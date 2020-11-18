import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/TabNavigator.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/DeleteHeadacheTypeActionSheet.dart';
import 'package:mobile/view/GenerateReportActionSheet.dart';
import 'package:mobile/view/MedicalHelpActionSheet.dart';
import 'package:mobile/view/MoreTriggersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
   saveHomePosition();
   print(Utils.getDateTimeInUtcFormat(DateTime.now()));
  }
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
                Constant.meUnselected,
                height: 25,
              ),
              activeIcon: Image.asset(
                Constant.meSelected,
                height: 25,
              ),
              title: Text(
                Constant.me,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constant.recordsUnselected,
                height: 25,
              ),
              activeIcon: Image.asset(
                Constant.recordsSelected,
                height: 25,
              ),
              title: Text(
                Constant.records,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constant.discoverUnselected,
                height: 25,
              ),
              activeIcon: Image.asset(
                Constant.discoverSelected,
                height: 25,
              ),
              title: Text(
                Constant.discover,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constant.jostMedium,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constant.moreUnselected,
                height: 25,
                width: 30,
              ),
              activeIcon: Image.asset(
                Constant.moreSelected,
                height: 25,
                width: 30,
              ),
              title: Text(
                Constant.more,
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
    switch (index) {
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
        navigateToOtherScreenCallback: navigateToOtherScreen,
        openActionSheetCallback: _openActionSheet,
        openTriggerMedicationActionSheetCallback: _openTriggersMedicationActionSheet,
      ),
    );
  }

  void _openActionSheet(String actionSheetType) async {
    switch (actionSheetType) {
      case Constant.medicalHelpActionSheet:
        var resultOfActionSheet = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (context) => MedicalHelpActionSheet());
        break;
      case Constant.generateReportActionSheet:
        var resultOfActionSheet = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (context) => GenerateReportActionSheet());
        break;
      case Constant.deleteHeadacheTypeActionSheet:
        var resultOfActionSheet = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (context) => DeleteHeadacheTypeActionSheet()
        );
        break;
    }
  }

  Future<dynamic> navigateToOtherScreen(String routerName) async {
    if (routerName == TabNavigatorRoutes.recordsRoot) {
      await Utils.saveDataInSharedPreference(Constant.tabNavigatorState, "1");
      setState(() {
        currentIndex = 1;
      });
    } else {
      if(routerName == Constant.welcomeStartAssessmentScreenRouter) {
        return await Navigator.pushReplacementNamed(context, routerName);
      } else {
        return await Navigator.pushNamed(context, routerName);
      }
    }
  }

  void _openTriggersMedicationActionSheet(List<Values> valuesList) {
    showModalBottomSheet(
        elevation: 4,
        backgroundColor: Constant.backgroundTransparentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => BottomSheetContainer(
            selectOptionList: valuesList,
            selectedAnswerCallback: (index) {
              setState(() {});
            }));
  }

  void saveHomePosition() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constant.userAlreadyLoggedIn, true);
  }
}
