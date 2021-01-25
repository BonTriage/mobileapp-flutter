import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

import 'DateTimePicker.dart';

class CompareCompassScreen extends StatefulWidget {
  final Future<dynamic> Function(String) openActionSheetCallback;

  const CompareCompassScreen({Key key, this.openActionSheetCallback}) : super(key: key);

  @override
  _CompareCompassScreenState createState() => _CompareCompassScreenState();
}

class _CompareCompassScreenState extends State<CompareCompassScreen> {
  bool darkMode = false;
  double numberOfFeatures = 4;
  bool isMonthTapSelected = true;
  bool isFirstLoggedSelected = false;
  int compassValue = 2;
  DateTime _dateTime;
  int currentMonth;
  int currentYear;
  String monthName;
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;


  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    monthName = Utils.getMonthName(currentMonth);
    totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(currentMonth, currentYear);
    firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, 1);
    lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, totalDaysInCurrentMonth);
  }

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
      [4, 6, 6, 19],
      [7, 10, 10, 21]
    ];

    List<TextSpan> _getBubbleTextSpans() {
      List<TextSpan> list = [];
      list.add(TextSpan(
          text: 'Your first logged Headache score was ',
          style: TextStyle(
              height: 1,
              fontSize: 14,
              fontFamily: Constant.jostRegular,
              color: Constant.chatBubbleGreen)));
      list.add(TextSpan(
          text: '63',
          style: TextStyle(
              height: 1,
              fontSize: 14,
              fontFamily: Constant.jostRegular,
              color: Constant.addCustomNotificationTextColor)));
      list.add(TextSpan(
          text: ' in may 2019. Tap the Compass to view December 2020  ',
          style: TextStyle(
              height: 1,
              fontSize: 14,
              fontFamily: Constant.jostRegular,
              color: Constant.chatBubbleGreen)));
      return list;
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _openHeadacheTypeActionSheet();
              },
              child: Container(
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
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Utils.showCompassTutorialDialog(context, 0);
                  },
                  child: Container(
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 3,
                      child: GestureDetector(
                        onTap: () {
                          Utils.showCompassTutorialDialog(context, 3);
                        },
                        child: Text(
                          "Frequency",
                          style: TextStyle(
                              color: Color(0xffafd794),
                              fontSize: 16,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Utils.showCompassTutorialDialog(context, 1);
                          },
                          child: Text(
                            "Intensity",
                            style: TextStyle(
                                color: Color(0xffafd794),
                                fontSize: 16,
                                fontFamily: Constant.jostMedium),
                          ),
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
                                            compassValue: compassValue,
                                          )
                                        : RadarChart.light(
                                            ticks: ticks,
                                            features: features,
                                            data: data,
                                            outlineColor: Constant
                                                .chatBubbleGreen
                                                .withOpacity(0.5),
                                            reverseAxis: true,
                                            compassValue: compassValue,
                                          ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Text(
                                          isMonthTapSelected?'57':'60',
                                          style: TextStyle(
                                              color:  isMonthTapSelected?Colors.white:Colors.black,
                                              fontSize: 14,
                                              fontFamily: Constant.jostMedium),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isMonthTapSelected?Constant
                                            .compareCompassHeadacheValueColor:Constant.compareCompassMonthSelectedColor,
                                        border: Border.all(
                                            color: isMonthTapSelected?Constant
                                                .compareCompassHeadacheValueColor:Constant.compareCompassMonthSelectedColor,
                                            width: 1.2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Utils.showCompassTutorialDialog(context, 2);
                          },
                          child: Text(
                            "Disability",
                            style: TextStyle(
                                color: Color(0xffafd794),
                                fontSize: 16,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ],
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () {
                          Utils.showCompassTutorialDialog(context, 4);
                        },
                        child: Text(
                          "Duration",
                          style: TextStyle(
                              color: Color(0xffafd794),
                              fontSize: 16,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isMonthTapSelected = true;
                  isFirstLoggedSelected = false;
                  compassValue = 2;
                });
              },
              child: Container(
                height: 35,
                color: isMonthTapSelected
                    ? Constant.locationServiceGreen.withOpacity(0.1)
                    : Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            color: Constant.compareCompassHeadacheValueColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '$monthName $currentYear',
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 14,
                                fontFamily: Constant.jostRegular),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _openDatePickerBottomSheet(
                              CupertinoDatePickerMode.date);
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(
                              color: Constant.addCustomNotificationTextColor,
                              fontSize: 14,
                              fontFamily: Constant.jostRegular),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isFirstLoggedSelected = true;
                  isMonthTapSelected = false;
                  compassValue = 3;
                });
              },
              child: Container(
                height: 35,
                color: isFirstLoggedSelected
                    ? Constant.locationServiceGreen.withOpacity(0.1)
                    : Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            color: Color(0xffB8FFFF),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'First logged Score',
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 14,
                                fontFamily: Constant.jostRegular),
                          )
                        ],
                      ),
                      Text(
                        'Change',
                        style: TextStyle(
                            color: Constant.addCustomNotificationTextColor,
                            fontSize: 14,
                            fontFamily: Constant.jostRegular),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.symmetric(vertical: 0),
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
               onDateTimeSelected: _getDateTimeCallbackFunction(0),
            ));
  }

  Function _getDateTimeCallbackFunction(int whichPickerClicked) {
    switch (whichPickerClicked) {
      case 0:
        return _onStartDateSelected;
      default:
        return null;
    }
  }

  void _onStartDateSelected(DateTime dateTime) {
    setState(() {
      totalDaysInCurrentMonth =
          Utils.daysInCurrentMonth(dateTime.month, dateTime.year);
      firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
          dateTime.month, dateTime.year, 1);
      lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
          dateTime.month, dateTime.year, totalDaysInCurrentMonth);
      monthName = Utils.getMonthName(dateTime.month);
      currentYear = dateTime.year;
      currentMonth = dateTime.month;
      _dateTime = dateTime;
/*      _calendarScreenBloc.initNetworkStreamController();
      Utils.showApiLoaderDialog(context,
          networkStream: _calendarScreenBloc.networkDataStream,
          tapToRetryFunction: () {
            _calendarScreenBloc.enterSomeDummyDataToStreamController();
            requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
          });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);*/
    });
  }

  void _openHeadacheTypeActionSheet() async {
    var resultFromActionSheet = await widget.openActionSheetCallback(Constant.compassHeadacheTypeActionSheet);
    print(resultFromActionSheet);
  }
}
