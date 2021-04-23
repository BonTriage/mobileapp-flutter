import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/HomeScreenArgumentModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/TabNavigator.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CompassHeadacheTypeActionSheet.dart';
import 'package:mobile/view/DateRangeActionSheet.dart';
import 'package:mobile/view/DeleteHeadacheTypeActionSheet.dart';
import 'package:mobile/view/GenerateReportActionSheet.dart';
import 'package:mobile/view/MeScreenTutorial.dart';
import 'package:mobile/view/MedicalHelpActionSheet.dart';
import 'package:mobile/view/SaveAndExitActionSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DateTimePicker.dart';
import 'EditGraphViewBottomSheet.dart';
import 'SignUpBottomSheet.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenArgumentModel homeScreenArgumentModel;

  const HomeScreen({Key key, this.homeScreenArgumentModel}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  GlobalKey _logDayGlobalKey;
  GlobalKey _addHeadacheGlobalKey;
  GlobalKey _recordsGlobalKey;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Map<int, GlobalKey<NavigatorState>> navigatorKey = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),/*
    3: GlobalKey<NavigatorState>(),*/
  };

  @override
  void initState() {
    super.initState();
    saveHomePosition();
    _recordsGlobalKey = GlobalKey();
    saveCurrentIndexOfTabBar(0);
    print(Utils.getDateTimeInUtcFormat(DateTime.now()));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the opened app!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        Utils.showValidationErrorDialog(context, 'From opened app ${message.data.toString()}');
      }
    });

    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print('Got a message whilst in the background app!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      Utils.showValidationErrorDialog(context, 'From Background ${message.data.toString()}');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKey[currentIndex].currentState.maybePop(),
      child: MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: mediaQueryData.textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
        ),
        child: Scaffold(
          body: Container(
            decoration: Constant.backgroundBoxDecoration,
            child: Stack(
              children: [
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                /*_buildOffstageNavigator(2),*/
                _buildOffstageNavigator(2),
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
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontFamily: Constant.jostMedium,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontFamily: Constant.jostMedium,
            ),
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
                label: Constant.me,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  Constant.recordsUnselected,
                  height: 25,
                  key: _recordsGlobalKey,
                ),
                activeIcon: Image.asset(
                  Constant.recordsSelected,
                  height: 25,
                ),
                label: Constant.records,
              ),
              /*BottomNavigationBarItem(
                icon: Image.asset(
                  Constant.discoverUnselected,
                  height: 25,
                ),
                activeIcon: Image.asset(
                  Constant.discoverSelected,
                  height: 25,
                ),
                label: Constant.discover,
              ),*/
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
                label: Constant.more,
              ),
            ],
            onTap: (index) {
              if(index != currentIndex) {
                setState(() {
                  print(index);
                  currentIndex = index;
                  saveCurrentIndexOfTabBar(currentIndex);
                });
              }
            },
          ),
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
      /*case 2:
        return TabNavigatorRoutes.discoverRoot;*/
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
        openTriggerMedicationActionSheetCallback:
            _openTriggersMedicationActionSheet,
        showApiLoaderCallback: showApiLoader,
        getButtonsGlobalKeyCallback: getButtonsGlobalKey,
        openDatePickerCallback: _openDatePickerBottomSheet,
      ),
    );
  }

  Future<dynamic> _openActionSheet(String actionSheetType,dynamic argument) async {
    switch (actionSheetType) {
      case Constant.medicalHelpActionSheet:
        var resultOfActionSheet = await showCupertinoModalPopup(
            context: context,
            builder: (context) => MedicalHelpActionSheet());
        return resultOfActionSheet;
        break;
      case Constant.generateReportActionSheet:
        UserProfileInfoModel userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

        var resultOfActionSheet = await showCupertinoModalPopup(
            context: context,
            builder: (context) => GenerateReportActionSheet(userProfileInfoModel: userProfileInfoData,));
        return resultOfActionSheet;
        break;
      case Constant.deleteHeadacheTypeActionSheet:
        var resultOfActionSheet = await showCupertinoModalPopup(
            context: context,
            builder: (context) => DeleteHeadacheTypeActionSheet());
        return resultOfActionSheet;
        break;
      case Constant.saveAndExitActionSheet:
        var resultOfActionSheet = await showCupertinoModalPopup(
            context: context,
            builder: (context) => SaveAndExitActionSheet());
        return resultOfActionSheet;
        break;
      case Constant.dateRangeActionSheet:
        var resultOfActionSheet = await showCupertinoModalPopup(
            context: context,
            builder: (context) => DateRangeActionSheet());
        return resultOfActionSheet;
        break;
      case Constant.compassHeadacheTypeActionSheet:
        var resultOfActionSheet = await showModalBottomSheet(
            backgroundColor: Constant.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (context) => CompassHeadacheTypeActionSheet(headacheListModelData: argument));
        return resultOfActionSheet;
        break;
      case Constant.editGraphViewBottomSheet:
        var resultOfActionSheet = showModalBottomSheet(
          context: context,
          backgroundColor: Constant.backgroundColor,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          builder: (context) => EditGraphViewBottomSheet(editGraphViewFilterModel: argument),
        );
        return resultOfActionSheet;
        break;
      default: return null;
    }
  }

  Future<dynamic> navigateToOtherScreen(String routerName, dynamic argument) async {
    if (routerName == TabNavigatorRoutes.calenderRoute || routerName == TabNavigatorRoutes.trendsRoute) {
      await Utils.saveDataInSharedPreference(Constant.tabNavigatorState, "1");
      await saveCurrentIndexOfTabBar(1);
      setState(() {
        print('set state 4');
        currentIndex = 1;
      });
    } else {
      if (routerName == Constant.welcomeStartAssessmentScreenRouter) {
        return await Navigator.pushReplacementNamed(context, routerName,arguments: argument);
      } else {
        return await Navigator.pushNamed(context, routerName,arguments: argument);
      }
    }
  }

  void _openTriggersMedicationActionSheet(Questions questions, Function(int) selectedAnswerCallback) {
    showModalBottomSheet(
        backgroundColor: Constant.transparentColor  ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => BottomSheetContainer(
          question: questions,
          selectedAnswerCallback: selectedAnswerCallback,
          isFromMoreScreen: true,
        ));
  }

  void saveHomePosition() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constant.userAlreadyLoggedIn, true);
    print('Device Token Start???${await _fcm.getToken()}???End');
    Utils.showValidationErrorDialog(context, 'Terminated App ${sharedPreferences.getString('notification_data')}');
    sharedPreferences.remove('notification_data');
  }

  Future<void> saveCurrentIndexOfTabBar(int currentIndex) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(Constant.currentIndexOfTabBar, currentIndex);
  }

  ///This method is used to show api loader dialog
  void showApiLoader(Stream networkStream, Function tapToRetryFunction) {
    print('Home show api loader');
    Utils.showApiLoaderDialog(context, networkStream: networkStream, tapToRetryFunction: tapToRetryFunction);
  }

  void getButtonsGlobalKey(GlobalKey logDayGlobalKey, GlobalKey addHeadacheGlobalKey) {
    _logDayGlobalKey = logDayGlobalKey;
    _addHeadacheGlobalKey = addHeadacheGlobalKey;

    Future.delayed(Duration(milliseconds: 350), () {
      _showTutorialDialog();
    });
  }

  ///This method is used to show tutorial dialog
  void _showTutorialDialog() async {
    bool isTutorialHasSeen = await SignUpOnBoardProviders.db.isUserHasAlreadySeenTutorial(1);
    if(!isTutorialHasSeen) {
      await SignUpOnBoardProviders.db.insertTutorialData(1);
      showGeneralDialog(
          context: context,
          barrierColor: Colors.transparent,
          pageBuilder: (buildContext, animation, secondaryAnimation) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: MeScreenTutorialDialog(
                logDayGlobalKey: _logDayGlobalKey,
                recordsGlobalKey: _recordsGlobalKey,
                addHeadacheGlobalKey: _addHeadacheGlobalKey,
                isFromOnBoard: widget.homeScreenArgumentModel != null ? widget.homeScreenArgumentModel.isFromOnBoard ?? false : false,
              ),
            );
          }
      );
    }
  }

  /// @param cupertinoDatePickerMode: for time and date mode selection
  Future<DateTime> _openDatePickerBottomSheet(
      CupertinoDatePickerMode cupertinoDatePickerMode, Function dateTimeCallbackFunction, DateTime initialDateTime) async {
    var resultFromActionSheet = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
          cupertinoDatePickerMode: cupertinoDatePickerMode,
          onDateTimeSelected: dateTimeCallbackFunction,
          initialDateTime: initialDateTime,
          isFromHomeScreen: true,
        ));

    return resultFromActionSheet;
  }

}
