import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class NotificationTimer extends StatefulWidget {
  @override
  _NotificationTimerState createState() => _NotificationTimerState();
}

class _NotificationTimerState extends State<NotificationTimer> {
  bool isDailySelected = false;
  bool isWeekDaysSelected = false;
  bool isOffSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Constant.chatBubbleGreen, width: 1),
                      color: isDailySelected
                          ? Constant.backgroundTransparentColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isWeekDaysSelected = false;
                            if (isDailySelected) {
                              isDailySelected = false;
                            } else {
                              isDailySelected = true;
                            }
                          });
                        },
                        child: Text(
                          'daily',
                          style: TextStyle(
                              color: Constant.chatBubbleGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Constant.chatBubbleGreen, width: 1),
                      color: isWeekDaysSelected
                          ? Constant.backgroundTransparentColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isDailySelected = false;
                            if (isWeekDaysSelected) {
                              isWeekDaysSelected = false;
                            } else {
                              isWeekDaysSelected = true;
                            }
                          });
                        },
                        child: Text(
                          'WeekDays',
                          style: TextStyle(
                              color: Constant.chatBubbleGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                  color: isOffSelected
                      ? Constant.backgroundTransparentColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isWeekDaysSelected = false;
                        isDailySelected = false;
                        if (isOffSelected) {
                          isOffSelected = false;
                        } else {
                          isOffSelected = true;
                        }
                      });
                    },
                    child: Text(
                      'off',
                      style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: Constant.jostRegular),
                    ),
                  ),
                ),
              ),
            ],
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
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isWeekDaysSelected = false;
                  isDailySelected = false;
                  isOffSelected = false;
                });
              },
              child: Text(
                Constant.delete,
                style: TextStyle(
                    color: Constant.addCustomNotificationTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constant.jostRegular),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
