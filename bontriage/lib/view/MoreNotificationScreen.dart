import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LocalNotificationModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

import 'NotificationSection.dart';

class MoreNotificationScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const MoreNotificationScreen({Key key, this.onPush}) : super(key: key);

  @override
  _MoreNotificationScreenState createState() => _MoreNotificationScreenState();
}

class _MoreNotificationScreenState extends State<MoreNotificationScreen>
    with SingleTickerProviderStateMixin {
  String dailyLogStatus = 'Daily, 8:00 PM';
  String medicationStatus = 'Daily, 2:30 PM';
  String exerciseStatus = 'Off';

  AnimationController _animationController;

  bool _notificationSwitchState = false;
  List<LocalNotificationModel> allNotificationListData = [];
  StreamController<dynamic> _localNotificationStreamController;

  bool isAddedCustomNotification = false;
  bool isAlreadyAddedCustomNotification = false;

  bool isSaveButtonVisible = false;

  Stream<dynamic> get localNotificationDataStream =>
      _localNotificationStreamController.stream;
  TextEditingController textEditingController;
  String customNotificationValue = "";

  StreamSink<dynamic> get localNotificationDataSink =>
      _localNotificationStreamController.sink;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    _localNotificationStreamController = StreamController<dynamic>.broadcast();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 350),
        reverseDuration: Duration(milliseconds: 350),
        vsync: this);
    getNotificationListData();
  }

  @override
  void dispose() {
    _localNotificationStreamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery
                .of(context)
                .size
                .height,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Constant.moreBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(Constant.leftArrow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Constant.notifications,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, bottom: 15),
                          child: Text(
                            Constant.notifications,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Switch(
                            value: _notificationSwitchState,
                            onChanged: (bool state) {
                              setState(() {
                                _notificationSwitchState = state;

                                if (state) {
                                  _animationController.forward();
                                  isSaveButtonVisible = true;
                                } else {
                                  _animationController.reverse();
                                   isSaveButtonVisible = false;
                                }
                              });
                            },
                            activeColor: Constant.chatBubbleGreen,
                            inactiveThumbColor: Constant.chatBubbleGreen,
                            inactiveTrackColor: Constant.chatBubbleGreenBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizeTransition(
                    sizeFactor: _animationController,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: Column(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Constant.moreBackgroundColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                NotificationSection(
                                  notificationId: 0,
                                  notificationName: 'Daily Log',
                                  localNotificationDataStream:
                                  localNotificationDataStream,
                                  allNotificationListData: allNotificationListData,
                                ),
                                SizedBox(height: 5),
                                NotificationSection(
                                  notificationId: 1,
                                  localNotificationDataStream:
                                  localNotificationDataStream,
                                  allNotificationListData: allNotificationListData,
                                  notificationName: 'Medication',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                NotificationSection(
                                  notificationId: 2,
                                  notificationName: 'Exercise',
                                  localNotificationDataStream:
                                  localNotificationDataStream,
                                  allNotificationListData: allNotificationListData,
                                ),
                                Visibility(
                                  visible: isAlreadyAddedCustomNotification,
                                  child: NotificationSection(
                                      customNotification: () {
                                        openCustomNotificationDialog(
                                            context, allNotificationListData);
                                      },
                                      notificationId: 3,
                                      allNotificationListData:
                                      allNotificationListData,
                                      notificationName: customNotificationValue,
                                      isNotificationTimerOpen:
                                      isAddedCustomNotification,
                                      localNotificationDataStream:
                                      localNotificationDataStream),
                                ),
                                Visibility(
                                  visible: !isAlreadyAddedCustomNotification,
                                  child: GestureDetector(
                                    onTap: () {
                                      openCustomNotificationDialog(
                                          context, allNotificationListData);
                                    },
                                    child: Container(
                                      child: Text(
                                        Constant.addCustomNotification,
                                        style: TextStyle(
                                            color: Constant
                                                .addCustomNotificationTextColor,
                                            fontSize: 16,
                                            fontFamily: Constant.jostMedium),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Visibility(
                            visible: isSaveButtonVisible,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: GestureDetector(
                                onTap: () {
                                  localNotificationDataSink.add('Clicked');
                                  //saveAllNotification();
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
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: isSaveButtonVisible,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                Constant.weKnowItCanBeEasy,
                                style: TextStyle(
                                    color: Constant.locationServiceGreen,
                                    fontSize: 14,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openCustomNotificationDialog(BuildContext context,
      List<LocalNotificationModel> allNotificationListData) {
    DateTime _selectedDateTime = DateTime.now();
    textEditingController.text = setInitialValue();
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
                              customNotificationValue = textEditingController.text;
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
                                isAlreadyAddedCustomNotification = true;
                                setNotificationName(textEditingController.text);
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

  /// this Method will be use for to get all notification data from the DB. If user has set any Local notifications from
  /// this screen.
  void getNotificationListData() async {
    var notificationListData =
    await SignUpOnBoardProviders.db.getAllLocalNotificationsData();
    if (notificationListData != null) {
      setState(() {
        var customNotificationData = notificationListData.firstWhere(
                (element) => element.isCustomNotificationAdded,
            orElse: () => null);
        if (customNotificationData != null) {
          isAlreadyAddedCustomNotification = true;
        }
        isSaveButtonVisible = true;
        _notificationSwitchState = true;
        allNotificationListData = notificationListData;
        _animationController.forward();
      });
    }
  }

  setNotificationName(String notificationName) {
    LocalNotificationModel localNotificationNameModel = allNotificationListData
        .firstWhere(
            (element) => element.isCustomNotificationAdded ?? false,
        orElse: () => null);
    if (localNotificationNameModel != null) {
      customNotificationValue =  localNotificationNameModel.notificationName;
      localNotificationNameModel.notificationName = notificationName;
    }else{
      customNotificationValue = notificationName;
    }
  }
/// This Method will be use for to set initial value of custom notification edit text.
  String setInitialValue() {
    LocalNotificationModel localNotificationNameModel = allNotificationListData
        .firstWhere(
            (element) => element.isCustomNotificationAdded ?? false,
        orElse: () => null);
    if (localNotificationNameModel != null) {
      return localNotificationNameModel.notificationName;
    }else return '';
  }
}
