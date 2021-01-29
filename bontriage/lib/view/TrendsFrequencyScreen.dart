import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'DateTimePicker.dart';

class TrendsFrequencyScreen extends StatefulWidget {
  @override
  _TrendsFrequencyScreenState createState() => _TrendsFrequencyScreenState();
}

class _TrendsFrequencyScreenState extends State<TrendsFrequencyScreen> {
  DateTime _dateTime;
  int currentMonth;
  int currentYear;
  String monthName;
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;
  final Color leftBarColor = const Color(0xff000000);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 90;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;

  int clickedValue;

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

    final barGroup1 = makeGroupData(0, 10);
    final barGroup2 = makeGroupData(1, 16);
    final barGroup3 = makeGroupData(2, 24);


    final items = [
      barGroup1,
      barGroup2,
      barGroup3,

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
                Visibility(
                  visible: false,
                  child: Container(
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
                  minY: 0,
maxY: 30,
                  groupsSpace: 10,
                  axisTitleData: FlAxisTitleData(
                      show: true,
                      leftTitle: AxisTitle(
                          showTitle: true,
                          titleText: 'No. Headache Days per Month',
                          textStyle: TextStyle(
                              color: Color(0xffCAD7BF),
                              fontFamily: 'JostRegular',
                              fontSize: 12))),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: setToolTipColor(),
                        tooltipPadding:EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                        tooltipRoundedRadius: 20,
                        tooltipBottomMargin: 10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String weekDay = 'Jan';
                          return BarTooltipItem(
                              weekDay + '\n' + (rod.y.toInt()).toString()+' Days', TextStyle(color: Colors.black,fontFamily: 'JostRegular',
                              fontSize: 12 ));
                        },
                        fitInsideHorizontally: true,
                        fitInsideVertically: true),
                    touchCallback: (response) {
                      if (response.spot != null) {
                        if (response.spot.spot != null) {
                          if (response.spot.spot.y != null) {
                            setState(() {
                              clickedValue = response.spot.spot.y.toInt();
                            });
                          }
                        }
                      }
                    },
                    handleBuiltInTouches: true,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: const Color(0x800E4C47)),
                      top: BorderSide(color: Colors.transparent),
                      bottom: BorderSide(color: const Color(0x800E4C47)),
                      right: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                     checkToShowHorizontalLine: (value) => value % 5 == 0,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return FlLine(
                            color: const Color(0x800E4C47), strokeWidth: 1);
                      }else{
                        return FlLine(
                            color: const Color(0x800E4C47), strokeWidth: 1);
                      }

                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color: Color(0xffCAD7BF),
                          fontFamily: 'JostRegular',
                          fontSize: 11),
                      margin: 2,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Jan';
                          case 1:
                            return 'Feb';
                          case 2:
                            return 'Mar';
                          case 3:
                            return 'Fr';
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
                          fontSize: 11),
                      margin: 10,
                      reservedSize: 10,
                       getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value == 5) {
                          return '5';
                        } else if (value == 10) {
                          return '10';
                        } else if (value == 15) {
                          return '15';
                        } else if (value == 20) {
                          return '20';
                        } else if (value == 25) {
                          return '25';
                        } else if (value == 30) {
                          return '30';
                        }else {
                          return '';
                        }
                      },
                    ),
                  ),
                  barGroups: showingBarGroups,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Constant.barTutorialsTapColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12)),
                  ),
                  child: Image(
                    image: AssetImage(Constant.barQuestionMark),
                    width: 15,
                    height: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: setBarChartColor(y1),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5)),
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

  Color setToolTipColor() {
     return Constant.migraineColor;
  }
//3315662,4d7483,658c9f,82aac0,99c1db
  List<Color> setBarChartColor(double barChartValue) {
      return [Color(0xff476c7a) ,Color(0xff4d7483),Color(0xff658c9f),Color(0xff82aac0),Color(0xff99c1db)];
  }
}
