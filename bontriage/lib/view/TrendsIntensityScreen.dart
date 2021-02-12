import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/EditGraphViewFilterModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'DateTimePicker.dart';

class TrendsIntensityScreen extends StatefulWidget {
  final EditGraphViewFilterModel editGraphViewFilterModel;

  const TrendsIntensityScreen({Key key, this.editGraphViewFilterModel})
      : super(key: key);

  @override
  _TrendsIntensityScreenState createState() => _TrendsIntensityScreenState();
}

class _TrendsIntensityScreenState extends State<TrendsIntensityScreen>  with AutomaticKeepAliveClientMixin {
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

  int clickedValue;
  bool isClicked = false;
  List<Ity> intensityListData = [];
  BarChartGroupData barGroup5;
  List<BarChartGroupData> items;
  List<double> firstWeekIntensityData = [];
  List<double> secondWeekIntensityData = [];
  List<double> thirdWeekIntensityData = [];
  List<double> fourthWeekIntensityData = [];
  List<double> fifthWeekIntensityData = [];

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
    setIntensityValuesData();

  }

  @override
  void didUpdateWidget(covariant TrendsIntensityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('in did update widget of trends intensity screen');
    setIntensityValuesData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),

            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              child: Container(
                width: totalDaysInCurrentMonth <= 28 ? 340 : 420,
                child: BarChart(
                  BarChartData(
                    maxY: 10,
                    minY: 0,
                    groupsSpace: 10,
                    axisTitleData: FlAxisTitleData(
                        show: true,
                        leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Maximum Intensity',
                            textStyle: TextStyle(
                                color: Color(0xffCAD7BF),
                                fontFamily: 'JostRegular',
                                fontSize: 12))),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: setToolTipColor(),
                          tooltipPadding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                          tooltipRoundedRadius: 20,
                          tooltipBottomMargin: 10,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String weekDay = 'Jan 20';
                            return BarTooltipItem(
                                weekDay +
                                    '\n' +
                                    (rod.y.toInt()).toString() +
                                    '/10 Int.',
                                TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'JostRegular',
                                    fontSize: 12));
                          },
                          fitInsideHorizontally: true,
                          fitInsideVertically: true),
                      touchCallback: (response) {
                        if (response.spot != null) {
                          if (response.spot.spot != null) {
                            if (response.spot.spot.y != null) {
                              setState(() {
                                clickedValue = response.spot.spot.y.toInt();
                                if (response.touchInput is FlLongPressEnd ||
                                    response.touchInput is FlPanEnd) {
                                  isClicked = true;
                                }
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
                      checkToShowHorizontalLine: (value) => value % 2 == 0,
                      getDrawingHorizontalLine: (value) {
                        if (value == 0) {
                          return FlLine(
                              color: const Color(0x800E4C47), strokeWidth: 1);
                        }
                        return FlLine(
                          color: const Color(0x800E4C47),
                          strokeWidth: 0.8,
                        );
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
                              return 'Week 1';
                            case 1:
                              return 'Week 2';
                            case 2:
                              return 'Week 3';
                            case 3:
                              return 'Week 4';
                            case 4:
                              if (totalDaysInCurrentMonth > 28) {
                                return 'Week 5';
                              }
                              return '';
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
                            fontSize: 10),
                        margin: 10,
                        reservedSize: 11,
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
                    barGroups: showingBarGroups,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: getDotText(),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: getDotsWidget()
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
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
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3,
      double y4, double y5, double y6, double y7) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: setBarChartColor(y1),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y2,
        colors: setBarChartColor(y2),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y3,
        colors: setBarChartColor(y3),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y4,
        colors: setBarChartColor(y4),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y5,
        colors: setBarChartColor(y5),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y6,
        colors: setBarChartColor(y6),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y7,
        colors: setBarChartColor(y7),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
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
    if (clickedValue != null) {
      if (clickedValue > 1 && clickedValue <= 3) {
        return Constant.mildTriggerColor;
      } else if (clickedValue >= 4 && clickedValue <= 7) {
        return Constant.moderateTriggerColor;
      } else
        return Constant.severeTriggerColor;
    }
    return Colors.transparent;
  }

  List<Color> setBarChartColor(double barChartValue) {
    if (barChartValue > 1 && barChartValue <= 3) {
      return [Constant.mildTriggerColor];
    } else if (barChartValue >= 4 && barChartValue <= 7) {
      return [Constant.moderateTriggerColor];
    } else
      return [Constant.severeTriggerColor];
  }

  void setAllWeekIntensityData(int i, double intensityData) {
    if (i <= 7) {
      firstWeekIntensityData.add(intensityData);
    }
    if (i > 7 && i <= 14) {
      secondWeekIntensityData.add(intensityData);
    }
    if (i > 14 && i <= 21) {
      thirdWeekIntensityData.add(intensityData);
    }
    if (i > 21 && i <= 28) {
      fourthWeekIntensityData.add(intensityData);
    }
    if (i > 28) {
      fifthWeekIntensityData.add(intensityData);
    }
  }

  void setIntensityValuesData() {
    intensityListData = widget.editGraphViewFilterModel.recordsTrendsDataModel.headache.severity;
    firstWeekIntensityData = [];
    secondWeekIntensityData = [];
    thirdWeekIntensityData = [];
    fourthWeekIntensityData = [];
    fifthWeekIntensityData = [];

    for (int i = 1; i <= totalDaysInCurrentMonth; i++) {
      String date;
      String month;
      if (i < 10) {
        date = '0$i';
      } else {
        date = i.toString();
      }
      if (currentMonth < 10) {
        month = '0$currentMonth';
      } else {
        month = currentMonth.toString();
      }
      DateTime dateTime =
          DateTime.parse('$currentYear-$month-$date 00:00:00.000Z');
      var intensityData = intensityListData.firstWhere(
          (element) => element.date.isAtSameMomentAs(dateTime),
          orElse: () => null);
      if (intensityData != null) {
        setAllWeekIntensityData(i, intensityData.value.toDouble());
      } else {
        setAllWeekIntensityData(i, 0);
      }
    }

    print(
        'AllIntensityListData $firstWeekIntensityData $secondWeekIntensityData $thirdWeekIntensityData $fourthWeekIntensityData');

    final barGroup1 = makeGroupData(
        0,
        firstWeekIntensityData[0],
        firstWeekIntensityData[1],
        firstWeekIntensityData[2],
        firstWeekIntensityData[3],
        firstWeekIntensityData[4],
        firstWeekIntensityData[5],
        firstWeekIntensityData[6]);
    final barGroup2 = makeGroupData(
        1,
        secondWeekIntensityData[0],
        secondWeekIntensityData[1],
        secondWeekIntensityData[2],
        secondWeekIntensityData[3],
        secondWeekIntensityData[4],
        secondWeekIntensityData[5],
        secondWeekIntensityData[6]);
    final barGroup3 = makeGroupData(
        2,
        thirdWeekIntensityData[0],
        thirdWeekIntensityData[1],
        thirdWeekIntensityData[2],
        thirdWeekIntensityData[3],
        thirdWeekIntensityData[4],
        thirdWeekIntensityData[5],
        thirdWeekIntensityData[6]);
    final barGroup4 = makeGroupData(
        3,
        fourthWeekIntensityData[0],
        fourthWeekIntensityData[1],
        fourthWeekIntensityData[2],
        fourthWeekIntensityData[3],
        fourthWeekIntensityData[4],
        fourthWeekIntensityData[5],
        fourthWeekIntensityData[6]);

    if (totalDaysInCurrentMonth > 28) {
      barGroup5 = makeGroupData(
          4,
          fifthWeekIntensityData[0],
          fifthWeekIntensityData[1],
          fifthWeekIntensityData[2],
          fifthWeekIntensityData[3],
          fifthWeekIntensityData[4],
          fifthWeekIntensityData[5],
          fifthWeekIntensityData[6]);
    }

    if (totalDaysInCurrentMonth > 28) {
      items = [barGroup1, barGroup2, barGroup3, barGroup4, barGroup5];
    } else {
      items = [barGroup1, barGroup2, barGroup3, barGroup4];
    }

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }
  List<Widget> _getDots(int type) {
    List<Widget> dotsList;

    switch(type) {
      case 0:
        dotsList = List.generate(31, (index) => Expanded(
          child: Container(
            height: 10,
            child: Center(
              child: Icon(
                true ? Icons.circle : Icons.brightness_1_outlined,
                size: 8,
                color: Constant.locationServiceGreen,
              ),
            ),
          ),
        ));
        break;
      case 1:
        dotsList = List.generate(31, (index) => Expanded(
          child: Container(
            height: 10,
            child: Center(
              child: Icon(
                false ? Icons.circle : Icons.brightness_1_outlined,
                size: 8,
                color: Constant.locationServiceGreen,
              ),
            ),
          ),
        ));
        break;
      default:
        dotsList = List.generate(31, (index) => Expanded(
          child: Container(
            height: 10,
            child: Center(
              child: Icon(
                true ? Icons.circle : Icons.brightness_1_outlined,
                size: 8,
                color: Constant.locationServiceGreen,
              ),
            ),
          ),
        ));
    }

    return dotsList;
  }

  @override
  bool get wantKeepAlive => true;

 List<Widget> getDotText() {
  List<Widget> widgetListData = [];
 for(int i= 0; i<3; i++){
   widgetListData.add( Text(
     'Exercise',
     style: TextStyle(
         color: Constant.locationServiceGreen,
         fontSize: 12,
         fontFamily: Constant.jostRegular
     ),
   ),
   );
   widgetListData.add(SizedBox(height: 2,));
 }
  return widgetListData;
 }

 List<Widget> getDotsWidget() {
   List<Widget> widgetListData = [];
   for(int i = 0; i< 3; i++){
     widgetListData.add(Padding(
       padding: const EdgeInsets.only(left: 5, right: 10),
       child: Row(
         children: _getDots(i),
       ),
     ));
   }
   return widgetListData;
 }
}
