import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/EditGraphViewFilterModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'DateTimePicker.dart';
import 'package:mobile/models/TrendsFilterModel.dart';
import 'package:mobile/models/RecordsTrendsMultipleHeadacheDataModel.dart';

class TrendsIntensityScreen extends StatefulWidget {
  final EditGraphViewFilterModel editGraphViewFilterModel;
  final Function updateTrendsDataCallback;

  const TrendsIntensityScreen(
      {Key key, this.editGraphViewFilterModel, this.updateTrendsDataCallback})
      : super(key: key);

  @override
  _TrendsIntensityScreenState createState() => _TrendsIntensityScreenState();
}

class _TrendsIntensityScreenState extends State<TrendsIntensityScreen>
    with AutomaticKeepAliveClientMixin {
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
  List<Data> multipleFirstIntensityListData = [];
  List<Data> multipleSecondIntensityListData = [];
  List<BarChartGroupData> items;
  List<double> firstWeekIntensityData = [];
  List<double> secondWeekIntensityData = [];
  List<double> thirdWeekIntensityData = [];
  List<double> fourthWeekIntensityData = [];
  List<double> fifthWeekIntensityData = [];

  List<double> multipleFirstWeekIntensityData = [];
  List<double> multipleSecondWeekIntensityData = [];
  List<double> multipleThirdWeekIntensityData = [];
  List<double> multipleFourthWeekIntensityData = [];
  List<double> multipleFifthWeekIntensityData = [];

  BarChartGroupData barGroup2;
  BarChartGroupData barGroup1;
  BarChartGroupData barGroup3;
  BarChartGroupData barGroup4;
  BarChartGroupData barGroup5;

  bool headacheColorChanged = false;

  @override
  void initState() {
    super.initState();

    _dateTime = widget.editGraphViewFilterModel.selectedDateTime;
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
    _dateTime = widget.editGraphViewFilterModel.selectedDateTime;
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
                                fontSize: 10))),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: setToolTipColor(),
                          tooltipPadding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                          tooltipRoundedRadius: 20,
                          tooltipBottomMargin: 10,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String weekDay =
                                '${Utils.getShortMonthName(_dateTime.month)} ${(groupIndex * 7) + rodIndex + 1}';
                            return BarTooltipItem(
                                weekDay +
                                    '\n' +
                                    (rod.y.toInt()).toString() +
                                    '/10 Int.',
                                TextStyle(
                                    color: setToolTipTextColor(),
                                    fontFamily: Constant.jostRegular,
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
                            fontSize: 10),
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
              visible:
                  widget.editGraphViewFilterModel.whichOtherFactorSelected !=
                      Constant.noneRadioButtonText,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: getDotText(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: getDotsWidget()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
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
              height: 15,
            ),
            Visibility(
              visible: widget.editGraphViewFilterModel
                      .headacheTypeRadioButtonSelected ==
                  Constant.viewSingleHeadache,
              child: Row(
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
            ),
            Visibility(
              visible: widget.editGraphViewFilterModel
                      .headacheTypeRadioButtonSelected !=
                  Constant.viewSingleHeadache,
              child: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: setHeadacheColor(),
                            shape: BoxShape.rectangle,
                          ),
                          height: 13,
                          width: 13,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData.length > 0 ? widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData[0].text:'',
                          style: TextStyle(
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostRegular),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: headacheColorChanged ? Constant.migraineColor: Constant.otherHeadacheColor,
                            shape: BoxShape.rectangle,
                          ),
                          height: 13,
                          width: 13,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData.length > 1 ?widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData[1].text:'',
                          style: TextStyle(
                              fontSize: 14,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostRegular),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                      ],
                    ),
                  ],
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

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3,
      double y4, double y5, double y6, double y7) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: setBarChartColor(y1),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: y2,
        colors: setBarChartColor(y2),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: y3,
        colors: setBarChartColor(y3),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: y4,
        colors: setBarChartColor(y4),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: y5,
        colors: setBarChartColor(y5),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: y6,
        colors: setBarChartColor(y6),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: y7,
        colors: setBarChartColor(y7),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
    ]);
  }

  BarChartGroupData makeMultipleGroupData(
      int x,
      double firstMultipleHeadache1,
      double firstMultipleHeadache2,
      double firstMultipleHeadache3,
      double firstMultipleHeadache4,
      double firstMultipleHeadache5,
      double firstMultipleHeadache6,
      double firstMultipleHeadache7,
      double secondMultipleHeadache1,
      double secondMultipleHeadache2,
      double secondMultipleHeadache3,
      double secondMultipleHeadache4,
      double secondMultipleHeadache5,
      double secondMultipleHeadache6,
      double secondMultipleHeadache7) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache1, secondMultipleHeadache1),
        rodStackItems: setRodStack(firstMultipleHeadache1, secondMultipleHeadache1),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache2, secondMultipleHeadache2),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache2, secondMultipleHeadache2),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache3, secondMultipleHeadache3),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache3, secondMultipleHeadache3)
        ,
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache4, secondMultipleHeadache4),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache4, secondMultipleHeadache4),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache5, secondMultipleHeadache5),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache5, secondMultipleHeadache5),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache6, secondMultipleHeadache6),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache6, secondMultipleHeadache6),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache7, secondMultipleHeadache7),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache7, secondMultipleHeadache7),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
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
    _dateTime = dateTime;
    widget.editGraphViewFilterModel.selectedDateTime = _dateTime;
    totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(dateTime.month, dateTime.year);
    firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        dateTime.month, dateTime.year, 1);
    lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
        dateTime.month, dateTime.year, totalDaysInCurrentMonth);
    monthName = Utils.getMonthName(dateTime.month);
    currentYear = dateTime.year;
    currentMonth = dateTime.month;
    widget.updateTrendsDataCallback();
  }

  Color setToolTipColor() {
    if (clickedValue != null) {
      if(widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected == Constant.viewSingleHeadache){
        if (clickedValue > 1 && clickedValue <= 3) {
          return Constant.mildTriggerColor;
        } else if (clickedValue >= 4 && clickedValue <= 7) {
          return Constant.moderateTriggerColor;
        } else
          return Constant.severeTriggerColor;
      }else{
        return Constant.migraineColor;
      }

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

  void setAllMultipleWeekIntensityData(int i, double intensityData) {
    if (i <= 7) {
      multipleFirstWeekIntensityData.add(intensityData);
    }
    if (i > 7 && i <= 14) {
      multipleSecondWeekIntensityData.add(intensityData);
    }
    if (i > 14 && i <= 21) {
      multipleThirdWeekIntensityData.add(intensityData);
    }
    if (i > 21 && i <= 28) {
      multipleFourthWeekIntensityData.add(intensityData);
    }
    if (i > 28) {
      multipleFifthWeekIntensityData.add(intensityData);
    }
  }

  void setIntensityValuesData() {
    if (widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected ==
        Constant.viewSingleHeadache) {
      intensityListData = widget
          .editGraphViewFilterModel.recordsTrendsDataModel.headache.severity;
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

      barGroup1 = makeGroupData(
          0,
          firstWeekIntensityData[0],
          firstWeekIntensityData[1],
          firstWeekIntensityData[2],
          firstWeekIntensityData[3],
          firstWeekIntensityData[4],
          firstWeekIntensityData[5],
          firstWeekIntensityData[6]);
      barGroup2 = makeGroupData(
          1,
          secondWeekIntensityData[0],
          secondWeekIntensityData[1],
          secondWeekIntensityData[2],
          secondWeekIntensityData[3],
          secondWeekIntensityData[4],
          secondWeekIntensityData[5],
          secondWeekIntensityData[6]);
      barGroup3 = makeGroupData(
          2,
          thirdWeekIntensityData[0],
          thirdWeekIntensityData[1],
          thirdWeekIntensityData[2],
          thirdWeekIntensityData[3],
          thirdWeekIntensityData[4],
          thirdWeekIntensityData[5],
          thirdWeekIntensityData[6]);
      barGroup4 = makeGroupData(
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
          0,
          0,
          0,
          0,
        );
      }
      if (totalDaysInCurrentMonth > 28) {
        items = [barGroup1, barGroup2, barGroup3, barGroup4, barGroup5];
      } else {
        items = [barGroup1, barGroup2, barGroup3, barGroup4];
      }

      rawBarGroups = items;
      showingBarGroups = rawBarGroups;
    } else {
      multipleFirstIntensityListData = widget
          .editGraphViewFilterModel
          .recordsTrendsDataModel
          .recordsTrendsMultipleHeadacheDataModel
          .headacheFirst
          .severity;
      multipleSecondIntensityListData = widget
          .editGraphViewFilterModel
          .recordsTrendsDataModel
          .recordsTrendsMultipleHeadacheDataModel
          .headacheSecond
          .severity;

      firstWeekIntensityData = [];
      secondWeekIntensityData = [];
      thirdWeekIntensityData = [];
      fourthWeekIntensityData = [];
      fifthWeekIntensityData = [];

      multipleFirstWeekIntensityData = [];
      multipleSecondWeekIntensityData = [];
      multipleThirdWeekIntensityData = [];
      multipleFourthWeekIntensityData = [];
      multipleFifthWeekIntensityData = [];

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
        var firstIntensityData = multipleFirstIntensityListData.firstWhere(
            (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (firstIntensityData != null) {
          setAllWeekIntensityData(i, firstIntensityData.value.toDouble());
        } else {
          setAllWeekIntensityData(i, 0);
        }
        var secondIntensityData = multipleSecondIntensityListData.firstWhere(
            (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (secondIntensityData != null) {
          setAllMultipleWeekIntensityData(
              i, secondIntensityData.value.toDouble());
        } else {
          setAllMultipleWeekIntensityData(i, 0);
        }
      }
      print(
          'AllIntensityListData $firstWeekIntensityData $secondWeekIntensityData $thirdWeekIntensityData $fourthWeekIntensityData');

      print(
          'AllIntensityListData $multipleFirstWeekIntensityData $multipleSecondWeekIntensityData $multipleThirdWeekIntensityData $multipleFourthWeekIntensityData');

      barGroup1 = makeMultipleGroupData(
          0,
          firstWeekIntensityData[0],
          firstWeekIntensityData[1],
          firstWeekIntensityData[2],
          firstWeekIntensityData[3],
          firstWeekIntensityData[4],
          firstWeekIntensityData[5],
          firstWeekIntensityData[6],
          multipleFirstWeekIntensityData[0],
          multipleFirstWeekIntensityData[1],
          multipleFirstWeekIntensityData[2],
          multipleFirstWeekIntensityData[3],
          multipleFirstWeekIntensityData[4],
          multipleFirstWeekIntensityData[5],
          multipleFirstWeekIntensityData[6]);
      barGroup2 = makeMultipleGroupData(
          1,
          secondWeekIntensityData[0],
          secondWeekIntensityData[1],
          secondWeekIntensityData[2],
          secondWeekIntensityData[3],
          secondWeekIntensityData[4],
          secondWeekIntensityData[5],
          secondWeekIntensityData[6],
          multipleSecondWeekIntensityData[0],
          multipleSecondWeekIntensityData[1],
          multipleSecondWeekIntensityData[2],
          multipleSecondWeekIntensityData[3],
          multipleSecondWeekIntensityData[4],
          multipleSecondWeekIntensityData[5],
          multipleSecondWeekIntensityData[6]);
      barGroup3 = makeMultipleGroupData(
          2,
          thirdWeekIntensityData[0],
          thirdWeekIntensityData[1],
          thirdWeekIntensityData[2],
          thirdWeekIntensityData[3],
          thirdWeekIntensityData[4],
          thirdWeekIntensityData[5],
          thirdWeekIntensityData[6],
          multipleThirdWeekIntensityData[0],
          multipleThirdWeekIntensityData[1],
          multipleThirdWeekIntensityData[2],
          multipleThirdWeekIntensityData[3],
          multipleThirdWeekIntensityData[4],
          multipleThirdWeekIntensityData[5],
          multipleThirdWeekIntensityData[6]);
      barGroup4 = makeMultipleGroupData(
          3,
          fourthWeekIntensityData[0],
          fourthWeekIntensityData[1],
          fourthWeekIntensityData[2],
          fourthWeekIntensityData[3],
          fourthWeekIntensityData[4],
          fourthWeekIntensityData[5],
          fourthWeekIntensityData[6],
          multipleFourthWeekIntensityData[0],
          multipleFourthWeekIntensityData[1],
          multipleFourthWeekIntensityData[2],
          multipleFourthWeekIntensityData[3],
          multipleFourthWeekIntensityData[4],
          multipleFourthWeekIntensityData[5],
          multipleFourthWeekIntensityData[6]);

      if (totalDaysInCurrentMonth > 28) {
        barGroup5 = makeMultipleGroupData(
          4,
          fifthWeekIntensityData[0],
          fifthWeekIntensityData[1],
          fifthWeekIntensityData[2],
          0,
          0,
          0,
          0,
          multipleFifthWeekIntensityData[0],
          multipleFifthWeekIntensityData[1],
          multipleFifthWeekIntensityData[2],
          0,
          0,
          0,
          0,
        );
      }
    }
    if (totalDaysInCurrentMonth > 28) {
      items = [barGroup1, barGroup2, barGroup3, barGroup4, barGroup5];
    } else {
      items = [barGroup1, barGroup2, barGroup3, barGroup4];
    }

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  List<Widget> _getDots(TrendsFilterModel trendsFilterModel) {
    List<Widget> dotsList = [];

    for (int i = 1;
        i <= widget.editGraphViewFilterModel.numberOfDaysInMonth;
        i++) {
      var dotData = trendsFilterModel.occurringDateList
          .firstWhere((element) => element.day == i, orElse: () => null);

      dotsList.add(Expanded(
        child: Container(
          height: 10,
          child: Center(
            child: Icon(
              dotData != null ? Icons.circle : Icons.brightness_1_outlined,
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
    List<TrendsFilterModel> dotTextModelDataList = [];
    if (widget.editGraphViewFilterModel.whichOtherFactorSelected ==
        Constant.loggedBehaviors) {
      dotTextModelDataList = widget
          .editGraphViewFilterModel.trendsFilterListModel.behavioursListData;
    } else if (widget.editGraphViewFilterModel.whichOtherFactorSelected ==
        Constant.loggedPotentialTriggers) {
      dotTextModelDataList = widget
          .editGraphViewFilterModel.trendsFilterListModel.triggersListData;
    } else {
      dotTextModelDataList = widget
          .editGraphViewFilterModel.trendsFilterListModel.medicationListData;
    }
    for (int i = 0; i < dotTextModelDataList.length; i++) {
      if (i > 2) {
        break;
      }
      widgetListData.add(
        Text(
          dotTextModelDataList[i].dotName,
          style: TextStyle(
            color: Constant.locationServiceGreen,
            fontSize: 12,
            fontFamily: Constant.jostRegular,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
      widgetListData.add(SizedBox(
        height: 6,
      ));
    }
    return widgetListData;
  }

  List<Widget> getDotsWidget() {
    List<Widget> widgetListData = [];
    List<TrendsFilterModel> dotTextModelDataList;
    if (widget.editGraphViewFilterModel.whichOtherFactorSelected ==
        Constant.loggedBehaviors) {
      dotTextModelDataList = widget
          .editGraphViewFilterModel.trendsFilterListModel.behavioursListData;
    } else if (widget.editGraphViewFilterModel.whichOtherFactorSelected ==
        Constant.loggedPotentialTriggers) {
      dotTextModelDataList = widget
          .editGraphViewFilterModel.trendsFilterListModel.triggersListData;
    } else {
      dotTextModelDataList = widget
          .editGraphViewFilterModel.trendsFilterListModel.medicationListData;
    }
    for (int i = 0; i < dotTextModelDataList.length; i++) {
      if (i > 2) {
        break;
      }
      widgetListData.add(Padding(
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: Row(
          children: _getDots(dotTextModelDataList[i]),
        ),
      ));
      widgetListData.add(SizedBox(
        height: 14,
      ));
    }
    return widgetListData;
  }

  List<BarChartRodStackItem> setRodStack(
      double firstMultipleHeadache1, double secondMultipleHeadache1) {
    var maxValue, minValue = 0.0;
    if (firstMultipleHeadache1 >= secondMultipleHeadache1) {
      maxValue = firstMultipleHeadache1;
      minValue = secondMultipleHeadache1;
    } else {
      minValue = firstMultipleHeadache1;
      maxValue = secondMultipleHeadache1;
    }
    return [
      BarChartRodStackItem(0, minValue, Constant.otherHeadacheColor),
      BarChartRodStackItem(minValue, maxValue, Constant.migraineColor),
    ];
  }

  double setAxisValue(double firstMultipleHeadache1, double secondMultipleHeadache1) {
    var maxValue;
    if (firstMultipleHeadache1 >= secondMultipleHeadache1) {
    maxValue = firstMultipleHeadache1;
    } else {
    maxValue = secondMultipleHeadache1;
    }
    return maxValue;
  }

 Color setHeadacheColor() {
   if(firstWeekIntensityData.length > 0  && multipleFirstWeekIntensityData.length> 0) {
     if (firstWeekIntensityData[0] >= multipleFirstWeekIntensityData[0]) {
       headacheColorChanged = true;
       return Constant.otherHeadacheColor;
     } else{
       headacheColorChanged = false;
       return Constant.migraineColor;
     }

   }else return Colors.transparent;
 }

  setToolTipTextColor() {
      if(widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected == Constant.viewSingleHeadache){
         return Colors.white;
      }else{
        return Colors.black;
      }
  }
}
