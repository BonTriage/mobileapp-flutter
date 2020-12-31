import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LocalNotificationModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/NotificationSection.dart';
import 'package:mobile/view/NotificationTimer.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  bool _locationServicesSwitchState = false;
  StreamController<dynamic> _localNotificationStreamController;

  StreamSink<dynamic> get localNotificationDataSink =>
      _localNotificationStreamController.sink;

  Stream<dynamic> get localNotificationDataStream =>
      _localNotificationStreamController.stream;

  var isAddedCustomNotification = false;

  TextEditingController textEditingController;

  String customNotificationValue = "";

  bool isCustomTimerLayoutOpen = false;
  List<LocalNotificationModel> allNotificationListData = [];

  @override
  void initState() {
    super.initState();
    _localNotificationStreamController = StreamController<dynamic>.broadcast();
    textEditingController = TextEditingController();
    Utils.saveUserProgress(0, Constant.notificationEventStep);
    getNotificationListData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Constant.backgroundColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Utils.navigateToExitScreen(context);
                        },
                        child: Image(
                          image: AssetImage(Constant.closeIcon),
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Constant.notifications,
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 16,
                          fontFamily: Constant.jostMedium),
                    ),
                    Switch(
                      value: _locationServicesSwitchState,
                      onChanged: (bool state) {
                        setState(() {
                          _locationServicesSwitchState = state;
                          print(state);
                        });
                      },
                      activeColor: Constant.chatBubbleGreen,
                      inactiveThumbColor: Constant.chatBubbleGreen,
                      inactiveTrackColor: Constant.chatBubbleGreenBlue,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Visibility(
                  visible: _locationServicesSwitchState,
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          NotificationSection(
                              notificationId: 0,
                              notificationName: 'Daily Log',
                              allNotificationListData: allNotificationListData,
                              localNotificationDataStream:
                                  localNotificationDataStream),
                          SizedBox(height: 5),
                          NotificationSection(
                            notificationId: 1,
                            allNotificationListData: allNotificationListData,
                            notificationName: 'Medication',
                            localNotificationDataStream:
                                localNotificationDataStream,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          NotificationSection(
                              notificationId: 2,
                              notificationName: 'Exercise',
                              allNotificationListData: allNotificationListData,
                              localNotificationDataStream:
                                  localNotificationDataStream),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                            visible: !isAddedCustomNotification,
                            child: GestureDetector(
                              onTap: () {
                                openCustomNotificationDialog(
                                    context, allNotificationListData);
                              },
                              child: Text(
                                Constant.addCustomNotification,
                                style: TextStyle(
                                    color:
                                        Constant.addCustomNotificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isAddedCustomNotification,
                            child: NotificationSection(
                                notificationId: 3,
                                allNotificationListData:
                                    allNotificationListData,
                                notificationName: customNotificationValue,
                                isNotificationTimerOpen:
                                    isAddedCustomNotification,
                                localNotificationDataStream:
                                    localNotificationDataStream),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: GestureDetector(
                              onTap: () {
                                localNotificationDataSink.add('Clicked');
                                saveAllNotification();
                                /*   Navigator.pushReplacementNamed(context,
                                    Constant.postNotificationOnBoardRouter);*/
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color: Color(0xffafd794),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    Constant.save,
                                    style: TextStyle(
                                        color: Constant.bubbleChatTextView,
                                        fontSize: 15,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context,
                                    Constant.postNotificationOnBoardRouter);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: 1,
                                      color: Constant.chatBubbleGreen),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                        color: Constant.chatBubbleGreen,
                                        fontSize: 15,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openCustomNotificationDialog(BuildContext context,
      List<LocalNotificationModel> allNotificationListData) {
    DateTime _selectedDateTime = DateTime.now();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 410,
                ),
                child: Container(
                  width: 300,
                  height: 390,
                  decoration: BoxDecoration(
                    color: Constant.backgroundTransparentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAddedCustomNotification = true;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Image(
                                  image: AssetImage(Constant.closeIcon),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            onEditingComplete: () {},
                            onSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            controller: textEditingController,
                            onChanged: (String value) {
                              customNotificationValue =
                                  textEditingController.text;
                              //print(value);
                            },
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 15,
                                fontFamily: Constant.jostMedium),
                            cursorColor: Constant.chatBubbleGreen,
                            decoration: InputDecoration(
                              hintText: 'Tap to Title notification',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(50, 175, 215, 148),
                                  fontSize: 15,
                                  fontFamily: Constant.jostMedium),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constant.chatBubbleGreen)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constant.chatBubbleGreen)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 180,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                    fontSize: 18,
                                    color: Constant.locationServiceGreen,
                                    fontFamily: Constant.jostRegular),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              backgroundColor: Colors.transparent,
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: false,
                              onDateTimeChanged: (dateTime) {
                                _selectedDateTime = dateTime;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 80),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isAddedCustomNotification = true;
                                LocalNotificationModel localNotificationModel =
                                    LocalNotificationModel();
                                localNotificationModel.notificationType =
                                    'Custom';
                                localNotificationModel.notificationName =
                                    customNotificationValue;

                                localNotificationModel.notificationTime =
                                    _selectedDateTime.toIso8601String();
                                allNotificationListData
                                    .add(localNotificationModel);
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(0xffafd794),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.save,
                                  style: TextStyle(
                                      color: Constant.bubbleChatTextView,
                                      fontSize: 15,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 80),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontSize: 15,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void openTimerLayout() {
    setState(() {
      if (isCustomTimerLayoutOpen) {
        isCustomTimerLayoutOpen = false;
      } else {
        isCustomTimerLayoutOpen = true;
      }
    });
  }

  /// this Method will be use for to get all notification data from the DB. If user has set any Local notifications from
  /// this screen.
  void getNotificationListData() async {
    var notificationListData =
        await SignUpOnBoardProviders.db.getAllLocalNotificationsData();
    if (notificationListData != null) {
      setState(() {
        _locationServicesSwitchState = true;
        allNotificationListData = notificationListData;
      });
    }
  }

  /// This Method will be use for save the all Notification Data for the any alarm set by User.
  void saveAllNotification() {
    Future.delayed(Duration(milliseconds: 300), () {
      SignUpOnBoardProviders.db
          .insertUserNotifications(allNotificationListData);
    });
  }
}
