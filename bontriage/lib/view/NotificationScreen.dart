import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/NotificationTimer.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  bool _locationServicesSwitchState = false;

  bool isTimerLayoutOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.saveUserProgress(0, Constant.notificationEventStep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Constant.dailyLog,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                          GestureDetector(
                            onTap: () {
                              openTimerLayout();
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Daily, 8:00 PM',
                                  style: TextStyle(
                                      color: Constant.notificationTextColor,
                                      fontSize: 16,
                                      fontFamily: Constant.jostRegular),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image(
                                  image: AssetImage(isTimerLayoutOpen
                                      ? Constant.notificationDownArrow
                                      : Constant.rightArrow),
                                  width: 16,
                                  height: 16,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 350),
                        child: Visibility(
                          visible: isTimerLayoutOpen,
                          child: Container(
                            child: NotificationTimer(),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Constant.locationServiceGreen,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Constant.medication,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Daily, 2:30 PM',
                                style: TextStyle(
                                    color: Constant.notificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image(
                                image: AssetImage(Constant.rightArrow),
                                width: 16,
                                height: 16,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                        color: Constant.locationServiceGreen,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Constant.exercise,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'off',
                                style: TextStyle(
                                    color: Constant.notificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image(
                                image: AssetImage(Constant.rightArrow),
                                width: 16,
                                height: 16,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                        color: Constant.locationServiceGreen,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          openCustomNotificationDialog(context);
                        },
                        child: Text(
                          Constant.addCustomNotification,
                          style: TextStyle(
                              color: Constant.addCustomNotificationTextColor,
                              fontSize: 16,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                                  width: 1, color: Constant.chatBubbleGreen),
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
            ],
          ),
        ),
      ),
    );
  }

  void openTimerLayout() {
    setState(() {
      if (isTimerLayoutOpen) {
        isTimerLayoutOpen = false;
      } else {
        isTimerLayoutOpen = true;
      }
    });
  }

  static void openCustomNotificationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: WillPopScope(
            onWillPop: () async => false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 450,
              ),
              child: Container(
                width: 300,
                height: 420,
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
                          // controller: textEditingController,
                          onChanged: (String value) {
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
                              //     _selectedDateTime = dateTime;
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
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
