import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/constant.dart';

import 'DateTimePicker.dart';

class OverTimeCompassScreen extends StatefulWidget {
  @override
  _OverTimeCompassScreenState createState() => _OverTimeCompassScreenState();
}

class _OverTimeCompassScreenState extends State<OverTimeCompassScreen> {
  bool darkMode = false;
  double numberOfFeatures = 4;

  @override
  Widget build(BuildContext context) {
    const ticks = [7, 14, 21, 28, 35];

    var features = [
      "A",
      "B",
      "C",
      "D",
    ];
    var data = [
      [14, 15, 7, 7]
    ];

    List<TextSpan> _getBubbleTextSpans() {
      List<TextSpan> list = [];
        list.add(TextSpan(
            text: 'Your Headache Score for December was ',
            style: TextStyle(
                height: 1.3,
                fontSize: 14,
                fontFamily: Constant.jostRegular,
                color: Constant.chatBubbleGreen)));
        list.add(TextSpan(
            text: '62',
            style: TextStyle(
                height: 1.3,
                fontSize: 14,
                fontFamily: Constant.jostRegular,
                color: Constant.addCustomNotificationTextColor)));
        list.add(TextSpan(
            text: ' up from ',
            style: TextStyle(
                height: 1.3,
                fontSize: 14,
                fontFamily: Constant.jostRegular,
                color: Constant.chatBubbleGreen)));
        list.add(TextSpan(
            text: '60',
            style: TextStyle(
                height: 1.3,
                fontSize: 14,
                fontFamily: Constant.jostRegular,
                color: Constant.addCustomNotificationTextColor)));
        list.add(TextSpan(
            text:
            ' last month. This was primarily due to an ',
            style: TextStyle(
                height: 1.3,
                fontSize: 14,
                fontFamily: Constant.jostRegular,
                color: Constant.chatBubbleGreen))
        );
      list.add(TextSpan(
          text:
          'increase in duration.',
          style: TextStyle(
              height: 1.3,
              fontSize: 14,
              fontFamily: Constant.jostRegular,
              color: Constant.addCustomNotificationTextColor))
      );


      return list;
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 30),
              decoration: BoxDecoration(
                color: Constant.compassMyHeadacheTextColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'My headache',
                style: TextStyle(
                    color: Constant.locationServiceGreen,
                    fontSize: 16,
                    fontFamily: Constant.jostRegular),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(left: 65, top: 10),
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Constant.chatBubbleGreen, width: 1)),
                  child: Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.chatBubbleGreen,
                          fontFamily: Constant.jostBold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "Frequency",
                        style: TextStyle(
                            color: Color(0xffafd794),
                            fontSize: 16,
                            fontFamily: Constant.jostMedium),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Intensity",
                          style: TextStyle(
                              color: Color(0xffafd794),
                              fontSize: 16,
                              fontFamily: Constant.jostMedium),
                        ),
                        Center(
                          child: Container(
                            width: 220,
                            height: 220,
                            child: Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    child: darkMode
                                        ? RadarChart.dark(
                                            ticks: ticks,
                                            features: features,
                                            data: data,
                                            reverseAxis: true,
                                            compassValue: 1,
                                          )
                                        : RadarChart.light(
                                            ticks: ticks,
                                            features: features,
                                            data: data,
                                            outlineColor: Constant.chatBubbleGreen
                                                .withOpacity(0.5),
                                            reverseAxis: true,
                                            compassValue: 1,
                                          ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Text(
                                          '60',
                                          style: TextStyle(
                                              color: Color(0xff0E1712),
                                              fontSize: 14,
                                              fontFamily: Constant.jostMedium),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff97c289),
                                        border: Border.all(
                                            color: Color(0xff97c289), width: 1.2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Disability",
                          style: TextStyle(
                              color: Color(0xffafd794),
                              fontSize: 16,
                              fontFamily: Constant.jostMedium),
                        ),
                      ],
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        "Duration",
                        style: TextStyle(
                            color: Color(0xffafd794),
                            fontSize: 16,
                            fontFamily: Constant.jostMedium),
                      ),
                    ),
                  ],
                ),

              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    /* DateTime dateTime =
                        DateTime(_dateTime.year, _dateTime.month - 1);
                        _dateTime = dateTime;
                        _onStartDateSelected(dateTime);*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                      image: AssetImage(Constant.backArrow),
                      width: 17,
                      height: 17,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    _openDatePickerBottomSheet(
                        CupertinoDatePickerMode.date);
                  },
                  child: Text(
                    //  monthName + " " + currentYear.toString(),
                    'December 2020',
                    style: TextStyle(
                        color: Constant.chatBubbleGreen,
                        fontSize: 15,
                        fontFamily: Constant.jostRegular),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    /* DateTime dateTime =
                        DateTime(_dateTime.year, _dateTime.month + 1);
                        Duration duration = dateTime.difference(DateTime.now());
                        if (duration.inSeconds < 0) {
                          _dateTime = dateTime;
                          _onStartDateSelected(dateTime);
                        } else {
                          ///To:Do
                          print("Not Allowed");
                        }*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                      image: AssetImage(Constant.nextArrow),
                      width: 17,
                      height: 17,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.symmetric(vertical:3),
              decoration: BoxDecoration(
                color: Constant.locationServiceGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    children: _getBubbleTextSpans(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
  /// @param cupertinoDatePickerMode: for time and date mode selection
  void _openDatePickerBottomSheet(
      CupertinoDatePickerMode cupertinoDatePickerMode) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
          cupertinoDatePickerMode: cupertinoDatePickerMode,
         // onDateTimeSelected: _getDateTimeCallbackFunction(0),
        ));
  }
}
