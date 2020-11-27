import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/CalendarScreenBloc.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

import 'DateTimePicker.dart';
import 'NetworkErrorScreen.dart';

class CalendarIntensityScreen extends StatefulWidget {
  @override
  _CalendarIntensityScreenState createState() =>
      _CalendarIntensityScreenState();
}

class _CalendarIntensityScreenState extends State<CalendarIntensityScreen>
    with AutomaticKeepAliveClientMixin {
  List<Widget> currentMonthData = [];
  CalendarScreenBloc _calendarScreenBloc;
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
    _calendarScreenBloc = CalendarScreenBloc();
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Utils.showApiLoaderDialog(context,
          networkStream: _calendarScreenBloc.networkDataStream,
          tapToRetryFunction: () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
      });
    });
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
  }

  @override
  void didUpdateWidget(CalendarIntensityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    monthName = Utils.getMonthName(currentMonth);
    totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(currentMonth, currentYear);
    firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, 1);
    lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, totalDaysInCurrentMonth);
    _calendarScreenBloc.initNetworkStreamController();
   /* Utils.showApiLoaderDialog(context,
        networkStream: _calendarScreenBloc.networkDataStream,
        tapToRetryFunction: () {
      _calendarScreenBloc.enterSomeDummyDataToStreamController();
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
    });*/
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Constant.locationServiceGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          DateTime dateTime =
                          DateTime(_dateTime.year, _dateTime.month - 1);
                          _dateTime = dateTime;
                          _onStartDateSelected(dateTime);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image(
                            image: AssetImage(Constant.backArrow),
                            width: 13,
                            height: 13,
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
                          monthName + " " + currentYear.toString(),
                          style: TextStyle(
                              color: Constant.chatBubbleGreen,
                              fontSize: 13,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          DateTime dateTime =
                          DateTime(_dateTime.year, _dateTime.month + 1);
                          Duration duration = dateTime.difference(DateTime.now());
                          _dateTime = dateTime;
                          if (duration.inSeconds < 0) {
                            _onStartDateSelected(dateTime);
                          } else {
                            ///To:Do
                            print("Not Allowed");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image(
                            image: AssetImage(Constant.nextArrow),
                            width: 13,
                            height: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Center(
                            child: Text(
                              'Su',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostMedium),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'M',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Tu',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Center(
                          child: Text(
                            'W',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Th',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Center(
                          child: Text(
                            'F',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Sa',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Container(
                    height: 290,
                    child: StreamBuilder<dynamic>(
                        stream: _calendarScreenBloc.calendarDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            setCurrentMonthData(
                                snapshot.data, currentMonth, currentYear);
                            return GridView.count(
                                crossAxisCount: 7,
                                padding: EdgeInsets.all(4.0),
                                childAspectRatio: 8.0 / 9.0,
                                children: currentMonthData.map((e) {
                                  return e;
                                }).toList());
                          } else if (snapshot.hasError) {
                            Utils.closeApiLoaderDialog(context);
                            return NetworkErrorScreen(
                              errorMessage: snapshot.error.toString(),
                              tapToRetryFunction: () {
                                Utils.showApiLoaderDialog(context);
                                requestService(firstDayOfTheCurrentMonth,
                                    lastDayOfTheCurrentMonth);
                              },
                            );
                          } else {
                            /*return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ApiLoaderScreen(),
                    ],
                  );*/
                            return Container();
                          }
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Constant.backgroundTransparentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constant.chatBubbleGreen,
                                      width: 1.3)),
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Headache-free day',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Constant.chatBubbleGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constant.chatBubbleGreen)),
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Headache day',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Constant.migraineColor,
                                shape: BoxShape.circle,
                              ),
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Migraine day',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Constant.backgroundTransparentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constant.chatBubbleGreen,
                                      width: 1.3)),
                              child: Center(
                                child: Text(
                                  'i',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Constant.locationServiceGreen,
                                      fontFamily: Constant.jostRegular),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                Constant.calculatedSeverityCalendarTextView,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    color: Constant.locationServiceGreen,
                    fontFamily: Constant.jostRegular),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.mildTriggerColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 8,
                        width: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Mild',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Headache score between',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '1 - 3',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.moderateTriggerColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 8,
                        width: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Moderate',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Headache score between',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '4 - 7',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.severeTriggerColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 8,
                        width: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Severe',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        'Headache score',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '8 to 10',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void requestService(
      String firstDayOfTheCurrentMonth, String lastDayOfTheCurrentMonth) async {
    await _calendarScreenBloc.fetchCalendarTriggersData(
        firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
  }

  void setCurrentMonthData(
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel,
      int currentMonth,
      int currentYear) {
    var calendarUtil = CalendarUtil(
        calenderType: 2,
        userLogHeadacheDataCalendarModel: userLogHeadacheDataCalendarModel,
        userMonthTriggersListData: []);
    currentMonthData =
        calendarUtil.drawMonthCalendar(yy: currentYear, mm: currentMonth);
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
      _calendarScreenBloc.initNetworkStreamController();
      Utils.showApiLoaderDialog(context,
          networkStream: _calendarScreenBloc.networkDataStream,
          tapToRetryFunction: () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
      });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
