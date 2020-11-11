import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DateWidget extends StatelessWidget {
  final String weekDateData;
  final int calendarType;

  DateWidget(this.weekDateData, this.calendarType);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: !isCurrentDate()
                  ? BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color(0xff0E4C47),
                            Color(0xff0E4C47),
                          ]),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constant.chatBubbleGreen,
                        width: 2,
                      ))
                  : BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color(0xff5E8063),
                            Color(0xff5E8063),
                          ]),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xff5E8063),
                        width: 2,
                      )),
              padding: EdgeInsets.all(2),
              child: Center(
                child: Text(
                  weekDateData,
                  style: TextStyle(
                      fontSize: 13,
                      color: isCurrentDate()
                          ? Colors.white
                          : Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular),
                ),
              ),
            ),
            Visibility(
              visible: calendarType == 0 ? false : calendarType == 1,
              child: Container(
                width: 31,
                height: 31,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 3, left: 5.5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Constant.bubbleChatTextView, width: 1),
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffD85B00)),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: calendarType == 0 ? false : calendarType == 1,
              child: Container(
                width: 31,
                height: 31,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 3, right: 5.5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Constant.bubbleChatTextView, width: 1),
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0XFF7E00CB)),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: calendarType == 0 ? false : calendarType == 1,
              child: Container(
                width: 31,
                height: 31,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Constant.bubbleChatTextView, width: 1),
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0XFF00A8CD)),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: calendarType == 0 ? false : calendarType == 2,
              child: Container(
                width: 31,
                height: 31,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 2,
                    ),
                    width: 16,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Constant.moderateTriggerColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isCurrentDate() {
    DateTime now = new DateTime.now();
    return now.day.toString() == weekDateData;
  }
}
