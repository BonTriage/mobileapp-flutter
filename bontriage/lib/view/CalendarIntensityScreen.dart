import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/CalendarScreenBloc.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MigraineDaysVsHeadacheDaysDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DateTimePicker.dart';

class CalendarIntensityScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;
  final StreamSink<dynamic> refreshCalendarDataSink;
  final Stream<dynamic> refreshCalendarDataStream;
  final Future<DateTime> Function (CupertinoDatePickerMode, Function, DateTime) openDatePickerCallback;

  const CalendarIntensityScreen({Key key, this.showApiLoaderCallback,this.navigateToOtherScreenCallback, this.refreshCalendarDataStream, this.refreshCalendarDataSink, this.openDatePickerCallback}): super(key: key);

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
      _showApiLoaderDialog();
    });
    _removeDataFromSharedPreference();
    _callApiService();

    widget.refreshCalendarDataStream.listen((event) {
      if(event is bool && event) {
        _removeDataFromSharedPreference();
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

        _callApiService();
      }
    });
  }

  @override
  void didUpdateWidget(CalendarIntensityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('did update widget of calendar intensity screen');
    _updateCalendarData();
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
                  StreamBuilder<dynamic>(
                      stream: _calendarScreenBloc.calendarDataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          setCurrentMonthData(
                              snapshot.data, currentMonth, currentYear);
                          return Column(
                            children: [
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
                                    behavior: HitTestBehavior.translucent,
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
                                      //widget.openDatePickerCallback(CupertinoDatePickerMode.date, _getDateTimeCallbackFunction(0), _dateTime);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Text(
                                      monthName + " " + currentYear.toString(),
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
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      DateTime dateTime =
                                      DateTime(_dateTime.year, _dateTime.month + 1);
                                      Duration duration = dateTime.difference(DateTime.now());
                                      if (duration.inSeconds < 0) {
                                        _dateTime = dateTime;
                                        _onStartDateSelected(dateTime);
                                      } else {
                                        ///To:Do
                                        print("Not Allowed");
                                        Utils.showValidationErrorDialog(context, Constant.beyondDateErrorMessage);
                                      }
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
                              Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    Center(
                                      child: Text(
                                        'Su',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Constant.locationServiceGreen,
                                            fontFamily: Constant.jostMedium),
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
                                child: GridView.count(
                                    crossAxisCount: 7,
                                    padding: EdgeInsets.all(4.0),
                                    childAspectRatio: 8.0 / 9.0,
                                    children: currentMonthData.map((e) {
                                      return e;
                                    }).toList()),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Container();
                        } else {
                          /*return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApiLoaderScreen(),
                  ],
                  );*/
                          return Column(
                            children: [
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
                                    behavior: HitTestBehavior.translucent,
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
                                      //widget.openDatePickerCallback(CupertinoDatePickerMode.date, _getDateTimeCallbackFunction(0), _dateTime);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Text(
                                      monthName + " " + currentYear.toString(),
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
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      DateTime dateTime =
                                      DateTime(_dateTime.year, _dateTime.month + 1);
                                      Duration duration = dateTime.difference(DateTime.now());
                                      if (duration.inSeconds < 0) {
                                        _dateTime = dateTime;
                                        _onStartDateSelected(dateTime);
                                      } else {
                                        ///To:Do
                                        print("Not Allowed");
                                        Utils.showValidationErrorDialog(context, Constant.beyondDateErrorMessage);
                                      }
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
                              Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    Center(
                                      child: Text(
                                        'Su',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Constant.locationServiceGreen,
                                            fontFamily: Constant.jostMedium),
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
                              Container(height: 290,),
                            ],
                          );
                        }
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 10),
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
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
                                  fontSize: 14,
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
                                  fontSize: 14,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
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
                                  fontSize: 14,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _showMigraineDaysVsHeadacheDaysDialog();
                              },
                              child: Container(
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
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.0),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostRegular),
                                  ),
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
                    fontSize: 13,
                    color: Constant.locationServiceGreen,
                    fontFamily: Constant.jostRegular),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                        SizedBox(
                          width: 44,
                        ),
                        Text(
                          'Headache intensity between',
                          style: TextStyle(
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostRegular),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '1 - 3',
                          style: TextStyle(
                              fontSize: 14,
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
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          'Headache intensity between',
                          style: TextStyle(
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostRegular),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '4 - 7',
                          style: TextStyle(
                              fontSize: 14,
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
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Headache intensity between',
                          style: TextStyle(
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostRegular),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '8 - 10',
                          style: TextStyle(
                              fontSize: 14,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  void requestService(
      String firstDayOfTheCurrentMonth, String lastDayOfTheCurrentMonth) async {
    print('call calender intensity service');
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
        userMonthTriggersListData: [],
        navigateToOtherScreenCallback: (routeName, data) async{
          dynamic isDataUpdated = await widget.navigateToOtherScreenCallback(routeName, data);
          if(isDataUpdated != null && isDataUpdated is bool && isDataUpdated) {
            widget.refreshCalendarDataSink.add(true);
          }
          return isDataUpdated;
        });
    currentMonthData =
        calendarUtil.drawMonthCalendar(yy: currentYear, mm: currentMonth);
  }

  /// @param cupertinoDatePickerMode: for time and date mode selection
  void _openDatePickerBottomSheet(
      CupertinoDatePickerMode cupertinoDatePickerMode) async {
    /*showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
              cupertinoDatePickerMode: cupertinoDatePickerMode,
              onDateTimeSelected: _getDateTimeCallbackFunction(0),
            ));*/
    var resultFromActionSheet = await widget.openDatePickerCallback(CupertinoDatePickerMode.date, _getDateTimeCallbackFunction(0), _dateTime);

    if(resultFromActionSheet != null && resultFromActionSheet is DateTime)
      _onStartDateSelected(resultFromActionSheet);
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
    //setState(() {
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
      _calendarScreenBloc.initNetworkStreamController();
      print('show api loader 9');
      Utils.showApiLoaderDialog(context,
          networkStream: _calendarScreenBloc.networkDataStream,
          tapToRetryFunction: () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        _callApiService();
      });
      _callApiService();
    //});
  }

  @override
  bool get wantKeepAlive => true;

  void _showMigraineDaysVsHeadacheDaysDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: MigraineDaysVsHeadacheDaysDialog(),
        );
      },
    );
  }

  void _callApiService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    int recordTabBarPosition = 0;

    try {
      recordTabBarPosition = sharedPreferences.getInt(Constant.recordTabNavigatorState);
    } catch (e) {
      print(e);
    }

    if(currentPositionOfTabBar == 1 && recordTabBarPosition == 0) {
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
    }
  }

  void _showApiLoaderDialog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String isViewTrendsClicked = sharedPreferences.getString(Constant.isViewTrendsClicked) ?? Constant.blankString;

    if (isViewTrendsClicked.isEmpty) {
      _calendarScreenBloc.initNetworkStreamController();
      print('show api loader 4');
      widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        _callApiService();
      });
    }
  }

  void _updateCalendarData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String isSeeMoreClicked = sharedPreferences.getString(Constant.isSeeMoreClicked) ?? Constant.blankString;
    String isTrendsClicked = sharedPreferences.getString(Constant.isViewTrendsClicked) ?? Constant.blankString;
    String updateCalendarIntensityData = sharedPreferences.getString(Constant.updateCalendarIntensityData) ?? Constant.blankString;

    if(isSeeMoreClicked.isEmpty && isTrendsClicked.isEmpty && updateCalendarIntensityData == Constant.trueString) {
      Future.delayed(Duration(seconds: 4), () {
        sharedPreferences.remove(Constant.updateCalendarIntensityData);
        currentMonth = _dateTime.month;
        currentYear = _dateTime.year;
        monthName = Utils.getMonthName(currentMonth);
        totalDaysInCurrentMonth =
            Utils.daysInCurrentMonth(currentMonth, currentYear);
        firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
            currentMonth, currentYear, 1);
        lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
            currentMonth, currentYear, totalDaysInCurrentMonth);

        int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
        int recordTabBarPosition = sharedPreferences.getInt(Constant.recordTabNavigatorState);

        if(currentPositionOfTabBar == 1 && recordTabBarPosition == 0) {
          _calendarScreenBloc.initNetworkStreamController();
          print('show api loader 10');
          widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
            _calendarScreenBloc.enterSomeDummyDataToStreamController();
            requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
          });
        }
        _callApiService();
      });
    }
  }

  void _removeDataFromSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(Constant.updateCalendarIntensityData);
  }
}
