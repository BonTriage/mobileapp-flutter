import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _locationServicesSwitchState = false;

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
                padding: EdgeInsets.fromLTRB(
                    0, 20, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:  Text(
                        'Cancel',
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 14,
                            fontFamily: Constant.jostMedium),
                      ),
                      /*child: Icon(
                        Icons.close,
                        color: Constant.locationServiceGreen,
                        size: 22,
                      ),*/
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
                        Row(
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
                    Text(
                      Constant.addCustomNotification,
                      style: TextStyle(
                          color: Constant.addCustomNotificationTextColor,
                          fontSize: 16,
                          fontFamily: Constant.jostRegular),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
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
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}