import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'DateTimePicker.dart';

class TrendsIntensityScreen extends StatefulWidget {
  @override
  _TrendsIntensityScreenState createState() => _TrendsIntensityScreenState();
}

class _TrendsIntensityScreenState extends State<TrendsIntensityScreen> {
  DateTime _dateTime;
  int currentMonth;
  int currentYear;
  String monthName;
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;
  final Color leftBarColor = const Color(0xff000000);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;

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

    final barGroup1 = makeGroupData(0, 2, 4, 7, 8, 10, 4, 8);
    final barGroup2 = makeGroupData(1, 4, 9, 5, 6, 5, 8, 9);
    final barGroup3 = makeGroupData(2, 5, 8, 4, 6, 5, 4, 6);
    final barGroup4 = makeGroupData(3, 6, 2, 6, 6, 5, 8, 9);
    /*  final barGroup5 = makeGroupData(4, 0, 6);
    final barGroup6 = makeGroupData(5, 0, 1.5);
    final barGroup7 = makeGroupData(6, 0, 1.5);*/

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      /*  barGroup5,
      barGroup6,
      barGroup7,*/
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Constant.backgroundTransparentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Edit graph view',
                    style: TextStyle(
                        color: Constant.locationServiceGreen,
                        fontSize: 12,
                        fontFamily: Constant.jostRegular),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Constant.backgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12)),
                  ),
                  child: Image(
                    image: AssetImage(Constant.barGraph),
                    width: 15,
                    height: 15,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Constant.backgroundTransparentColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: Image(
                    image: AssetImage(Constant.lineGraph),
                    width: 15,
                    height: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BarChart(

                BarChartData(
                  maxY: 10,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.red,
                        maxContentWidth: 20,
                        tooltipRoundedRadius: 20,
                        fitInsideVertically: true
                        /* getTooltipItem: (_a, _b, _c, _d) => null,*/
                        ),
                    touchCallback: (response) {},
                    handleBuiltInTouches: true,
                    /* touchCallback: (response) {
                          if (response.spot == null) {
                            setState(() {
                             */ /* touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);*/ /*
                            });
                            return;
                          }

                         // touchedGroupIndex = response.spot.touchedBarGroupIndex;

                          */ /*setState(() {
                            if (response.touchInput is FlLongPressEnd ||
                                response.touchInput is FlPanEnd) {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                            } else {
                              showingBarGroups = List.of(rawBarGroups);
                              if (touchedGroupIndex != -1) {
                                double sum = 0;
                                for (BarChartRodData rod
                                    in showingBarGroups[touchedGroupIndex].barRods) {
                                  sum += rod.y;
                                }
                                final avg =
                                    sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                showingBarGroups[touchedGroupIndex] =
                                    showingBarGroups[touchedGroupIndex].copyWith(
                                  barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                    return rod.copyWith(y: avg);
                                  }).toList(),
                                );
                              }
                            }
                          });*/ /*
                        }*/
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: true,
                    show: true,
                    checkToShowHorizontalLine: (value) => value % 3 == 0,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return FlLine(
                            color: const Color(0xff0E4C47), strokeWidth: 3);
                      }
                      return FlLine(
                        color: const Color(0xff0E4C47),
                        strokeWidth: 0.8,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color:Color(0xffCAD7BF),
                          fontFamily: 'JostRegular',
                          fontSize: 14),
                      margin: 2,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Week 1';
                          case 1:
                            return 'Week 2';
                          case 2:
                            return 'Week 3';
                          case 3:
                            return 'Week 4';
                          case 4:
                            return 'Fr';
                          case 5:
                            return 'St';
                          case 6:
                            return 'Sn';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color: Color(0xffCAD7BF),
                          fontFamily: 'JostRegular',
                          fontSize: 14),
                      margin: 10,
                      reservedSize: 14,
                      getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value == 2) {
                          return '2';
                        } else if (value == 4) {
                          return '4';
                        } else if (value == 6) {
                          return '6';
                        } else if (value == 8) {
                          return '8';
                        } else if (value == 10) {
                          return '10';
                        } else {
                          return '';
                        }
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                      show: false,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.3,
                        style: BorderStyle.solid,
                      )),
                  barGroups: showingBarGroups,
                ),
              ),
            ),
            SizedBox(
              height: 20,
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
                    _openDatePickerBottomSheet(CupertinoDatePickerMode.date);
                  },
                  child: Text(
                    '$monthName $currentYear',
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
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Constant.mildTriggerColor,
                    shape: BoxShape.rectangle,
                  ),
                  height: 13,
                  width: 13,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Mild',
                  style: TextStyle(
                      fontSize: 14,
                      color: Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular),
                ),
                SizedBox(
                  width: 14,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Constant.moderateTriggerColor,
                    shape: BoxShape.rectangle,
                  ),
                  height: 13,
                  width: 13,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Moderate',
                  style: TextStyle(
                      fontSize: 14,
                      color: Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular),
                ),
                SizedBox(
                  width: 14,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Constant.severeTriggerColor,
                    shape: BoxShape.rectangle,
                  ),
                  height: 13,
                  width: 13,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Severe',
                  style: TextStyle(
                      fontSize: 14,
                      color: Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y2, double y3,
      double y4, double y5, double y6, double y7, double y8) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [

      BarChartRodData(
        y: y2,
        colors: [Constant.moderateTriggerColor],
        width: width,
      ),
      BarChartRodData(
        y: y3,
        colors: [Constant.mildTriggerColor],
        width: width,
      ),
      BarChartRodData(
        y: y4,
        colors: [Constant.moderateTriggerColor],
        width: width,
      ),
      BarChartRodData(
        y: y5,
        colors: [Constant.severeTriggerColor],
        width: width,
      ),
      BarChartRodData(
        y: y6,
        colors: [Constant.moderateTriggerColor],
        width: width,
      ),
      BarChartRodData(
        y: y7,
        colors: [Constant.mildTriggerColor],
        width: width,
      ),
      BarChartRodData(
        y: y8,
        colors: [Constant.severeTriggerColor],
        width: width,
      ),
    ]);
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
}
