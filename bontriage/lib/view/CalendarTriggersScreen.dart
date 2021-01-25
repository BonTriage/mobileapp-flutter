import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/CalendarScreenBloc.dart';
import 'package:mobile/models/SelectedTriggersColorsModel.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DateTimePicker.dart';
import 'NetworkErrorScreen.dart';

class CalendarTriggersScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;
  final StreamSink<dynamic> refreshCalendarDataSink;
  final Stream<dynamic> refreshCalendarDataStream;

  const CalendarTriggersScreen({Key key, this.showApiLoaderCallback,this.navigateToOtherScreenCallback, this.refreshCalendarDataSink, this.refreshCalendarDataStream}): super(key: key);

  @override
  _CalendarTriggersScreenState createState() => _CalendarTriggersScreenState();
}

class _CalendarTriggersScreenState extends State<CalendarTriggersScreen>
    with AutomaticKeepAliveClientMixin {
  List<Widget> currentMonthData = [];
  Color lastDeselectedColor;
  CalendarScreenBloc _calendarScreenBloc;
  DateTime _dateTime;
  int currentMonth;
  int currentYear;
  String monthName;
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;

  List<SignUpHeadacheAnswerListModel> userMonthTriggersListModel = [];

  List<SelectedTriggersColorsModel> triggersColorsListData = [
    SelectedTriggersColorsModel(
        triggersColorsValue: Constant.calendarRedTriggerColor,
        isSelected: true),
    SelectedTriggersColorsModel(
        triggersColorsValue: Constant.calendarPurpleTriggersColor,
        isSelected: true),
    SelectedTriggersColorsModel(
        triggersColorsValue: Constant.calendarBlueTriggersColor,
        isSelected: true),
  ];

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
    callAPIService();
    
    widget.refreshCalendarDataStream.listen((event) {
      if(event is bool && event) {
        _calendarScreenBloc.initNetworkStreamController();
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

        widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
          _calendarScreenBloc.enterSomeDummyDataToStreamController();
          requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
        });

        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
      }
    });
  }

  @override
  void didUpdateWidget(CalendarTriggersScreen oldWidget) {
    getCurrentPositionOfTabBar();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
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
                      behavior: HitTestBehavior.translucent,
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
                          width: 17,
                          height: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _openDatePickerBottomSheet(
                            CupertinoDatePickerMode.date);
                      },
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
                              _calendarScreenBloc
                                  .enterSomeDummyDataToStreamController();
                              requestService(firstDayOfTheCurrentMonth,
                                  lastDayOfTheCurrentMonth);
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Constant.backgroundTransparentColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Constant.chatBubbleGreen, width: 1.3)),
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
                            border:
                                Border.all(color: Constant.chatBubbleGreen)),
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
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<dynamic>(
              stream: _calendarScreenBloc.triggersDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    userMonthTriggersListModel.clear();
                  }
                  if (userMonthTriggersListModel.length == 0) {
                    userMonthTriggersListModel.addAll(snapshot.data);
                  }else {
                    userMonthTriggersListModel.clear();
                    userMonthTriggersListModel.addAll(snapshot.data);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: userMonthTriggersListModel.length > 0,
                        child: Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            Constant.sortedCalenderTextView,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostRegular),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 150),
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 15),
                          child: SingleChildScrollView(
                            physics: Utils.getScrollPhysics(),
                            child: Wrap(
                              children: <Widget>[
                                for (var i = 0;
                                    i < userMonthTriggersListModel.length;
                                    i++)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        var foundElements =
                                            userMonthTriggersListModel
                                                .where((e) => e.isSelected);
                                        if (!userMonthTriggersListModel[i]
                                            .isSelected) {
                                          if (foundElements.length < 3) {
                                            var unSelectedColor =
                                                triggersColorsListData.firstWhere(
                                                    (element) =>
                                                        !element.isSelected,
                                                    orElse: () => null);
                                            if (unSelectedColor != null) {
                                              userMonthTriggersListModel[i].color =
                                                  unSelectedColor
                                                      .triggersColorsValue;
                                              userMonthTriggersListModel[i]
                                                  .isSelected = true;
                                              unSelectedColor.isSelected = true;
                                            }
                                            userMonthTriggersListModel[i]
                                                .isSelected = true;
                                          } else {
                                            Utils.showTriggerSelectionDialog(
                                                context);
                                            print(
                                                "PopUp will be show for more then 3 selected color");
                                          }
                                        } else {
                                          var selectedColor =
                                              triggersColorsListData.firstWhere(
                                                  (element) =>
                                                      element.triggersColorsValue ==
                                                      userMonthTriggersListModel[i]
                                                          .color,
                                                  orElse: () => null);
                                          if (selectedColor != null) {
                                            selectedColor.isSelected = false;
                                            userMonthTriggersListModel[i]
                                                .isSelected = false;
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        right: 10,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constant.chatBubbleGreen,
                                              width: 1),
                                          borderRadius: BorderRadius.circular(20),
                                          color: userMonthTriggersListModel[i]
                                                  .isSelected
                                              ? Constant.chatBubbleGreen
                                              : Colors.transparent),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(minHeight: 10),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Visibility(
                                                visible:
                                                    userMonthTriggersListModel[i]
                                                        .isSelected,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Constant
                                                              .bubbleChatTextView,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(20),
                                                      color:
                                                          userMonthTriggersListModel[
                                                                  i]
                                                              .color),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                userMonthTriggersListModel[i]
                                                    .answerData,
                                                style: TextStyle(
                                                    color: userMonthTriggersListModel[
                                                                i]
                                                            .isSelected
                                                        ? Constant
                                                            .bubbleChatTextView
                                                        : Constant
                                                            .locationServiceGreen,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        Constant.jostMedium),
                                              ),
                                            ],
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
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  Color selectedTriggersColor() {
    Color unselectedColor;
    var foundElements = triggersColorsListData.where((e) => e.isSelected);
    if (foundElements == null) {
      unselectedColor = Colors.red;
    } else {
      if (foundElements.length < 3) {
        var unSelectedTriggerColor = triggersColorsListData
            .firstWhere((element) => !element.isSelected, orElse: () => null);

        if (unSelectedTriggerColor == null) {
          unselectedColor = Colors.red;
        } else {
          unselectedColor = unSelectedTriggerColor.triggersColorsValue;
        }
      }
    }
    return unselectedColor;
  }

  void requestService(
      String firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth) async {
    print('call calender trigger service');
    await _calendarScreenBloc.fetchCalendarTriggersData(
        firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
  }

  void setCurrentMonthData(
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel,
      int currentMonth,
      int currentYear) {
    var calendarUtil = CalendarUtil(
        calenderType: 1,
        userLogHeadacheDataCalendarModel: userLogHeadacheDataCalendarModel,
        userMonthTriggersListData: _calendarScreenBloc.userMonthTriggersData,
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
      userMonthTriggersListModel = [];
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

  void getCurrentPositionOfTabBar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String isSeeMoreClicked = sharedPreferences.getString(Constant.isSeeMoreClicked) ?? Constant.blankString;

    if(isSeeMoreClicked.isEmpty) {
      _calendarScreenBloc.initNetworkStreamController();
      currentMonth = _dateTime.month;
      currentYear = _dateTime.year;
      monthName = Utils.getMonthName(currentMonth);
      totalDaysInCurrentMonth = Utils.daysInCurrentMonth(currentMonth, currentYear);
      firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(currentMonth, currentYear, 1);
      lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(currentMonth, currentYear, totalDaysInCurrentMonth);

      int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
      int recordTabBarPosition = sharedPreferences.getInt(Constant.recordTabNavigatorState);

      if (currentPositionOfTabBar == 1 && recordTabBarPosition == 0) {
        _calendarScreenBloc.initNetworkStreamController();

        widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
          _calendarScreenBloc.enterSomeDummyDataToStreamController();
          requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
        });

        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
      }
    } else {
      sharedPreferences.remove(Constant.isSeeMoreClicked);
    }
  }

  void callAPIService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    int recordTabBarPosition = sharedPreferences.getInt(Constant.recordTabNavigatorState);

    if (currentPositionOfTabBar == 1 && recordTabBarPosition == 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

        widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
          _calendarScreenBloc.enterSomeDummyDataToStreamController();
          requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
        });
      });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
    }
  }
}