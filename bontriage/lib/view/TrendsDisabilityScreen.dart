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

class TrendsDisabilityScreen extends StatefulWidget {
  final EditGraphViewFilterModel editGraphViewFilterModel;
  final Function updateTrendsDataCallback;

  const TrendsDisabilityScreen({Key key, this.editGraphViewFilterModel, this.updateTrendsDataCallback})
      : super(key: key);

  @override
  _TrendsDisabilityScreenState createState() => _TrendsDisabilityScreenState();
}

class _TrendsDisabilityScreenState extends State<TrendsDisabilityScreen> with AutomaticKeepAliveClientMixin {
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
  List<Ity> disabilityListData = [];
  List<Data> multipleFirstDisabilityListData = [];
  List<Data> multipleSecondDisabilityListData = [];
  List<BarChartGroupData> items;


  List<double> multipleFirstWeekDisabilityData = [];
  List<double> multipleSecondWeekDisabilityData = [];
  List<double> multipleThirdWeekDisabilityData = [];
  List<double> multipleFourthWeekDisabilityData = [];
  List<double> multipleFifthWeekDisabilityData = [];

  BarChartGroupData barGroup2;
  BarChartGroupData barGroup1;
  BarChartGroupData barGroup3;
  BarChartGroupData barGroup4;
  BarChartGroupData barGroup5;
  List<double> firstWeekDisabilityData = [];
  List<double> secondWeekDisabilityData = [];
  List<double> thirdWeekDisabilityData = [];
  List<double> fourthWeekDisabilityData = [];
  List<double> fifthWeekDisabilityData = [];

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

    setDisabilityValuesData();
  }
  @override
  void didUpdateWidget(covariant TrendsDisabilityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

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
    setDisabilityValuesData();
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
              scrollDirection: Axis.horizontal,
              child: Container(
                width: totalDaysInCurrentMonth <= 28 ? 350:420,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BarChart(
                  BarChartData(
                    maxY: 4,
                    minY: 0,
                    groupsSpace: 10,
                    axisTitleData: FlAxisTitleData(
                        show: true,
                        leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Maximum Disability',
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
                            String weekDay = '${Utils.getShortMonthName(_dateTime.month)} ${(groupIndex * 7) + rodIndex + 1}';
                            return BarTooltipItem(
                                weekDay +
                                    '\n' +
                                    (rod.y.toInt()).toString() +
                                    '/4 Dis.',
                                TextStyle(
                                    color: Colors.black,
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
                      // checkToShowHorizontalLine: (value) => value % 2 == 0,
                      getDrawingHorizontalLine: (value) {
                        if (value == 0) {
                          return FlLine(
                              color: const Color(0x800E4C47), strokeWidth: 1);
                        } else {
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
                            fontSize: 10),
                        margin: 10,
                        reservedSize: 10,
                        /* getTitles: (value) {
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
                        },*/
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
           /* Column(
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
            ),*/
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
        if (clickedValue == 1) {
          return Constant.mildTriggerColor;
        } else if (clickedValue > 1 && clickedValue <= 3) {
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
    if (barChartValue == 1) {
      return [Constant.mildTriggerColor];
    } else if (barChartValue > 1 && barChartValue <= 3) {
      return [Constant.moderateTriggerColor];
    } else
      return [Constant.severeTriggerColor];
  }

  void setAllWeekDisabilityData(int i, double intensityData) {
    if (i <= 7) {
      firstWeekDisabilityData.add(intensityData);
    }
    if (i > 7 && i <= 14) {
      secondWeekDisabilityData.add(intensityData);
    }
    if (i > 14 && i <= 21) {
      thirdWeekDisabilityData.add(intensityData);
    }
    if (i > 21 && i <= 28) {
      fourthWeekDisabilityData.add(intensityData);
    }
    if (i > 28) {
      fifthWeekDisabilityData.add(intensityData);
    }
  }

  void setDisabilityValuesData() {
    if (widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected ==
        Constant.viewSingleHeadache) {
      disabilityListData = widget.editGraphViewFilterModel.recordsTrendsDataModel.headache.disability;

      firstWeekDisabilityData = [];
      secondWeekDisabilityData = [];
      thirdWeekDisabilityData = [];
      fourthWeekDisabilityData = [];
      fifthWeekDisabilityData = [];

      for (int i = 1; i <= totalDaysInCurrentMonth; i++) {
        String date;
        String month;
        if (i < 10) {
          date = '0$i';
        } else {
          date = i.toString();
        }
        if(currentMonth <10){
          month = '0$currentMonth';
        }else{
          month = currentMonth.toString();
        }

        DateTime dateTime =
        DateTime.parse('$currentYear-$month-$date 00:00:00.000Z');
        var disabilityData = disabilityListData.firstWhere(
                (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (disabilityData != null) {
          setAllWeekDisabilityData(i, disabilityData.value.toDouble());
        } else {
          setAllWeekDisabilityData(i, 0);
        }
      }

      print('AllDisabilityListData $firstWeekDisabilityData $secondWeekDisabilityData $thirdWeekDisabilityData $fourthWeekDisabilityData');

       barGroup1 = makeGroupData(
          0,
          firstWeekDisabilityData[0],
          firstWeekDisabilityData[1],
          firstWeekDisabilityData[2],
          firstWeekDisabilityData[3],
          firstWeekDisabilityData[4],
          firstWeekDisabilityData[5],
          firstWeekDisabilityData[6]);
       barGroup2 = makeGroupData(
          1,
          secondWeekDisabilityData[0],
          secondWeekDisabilityData[1],
          secondWeekDisabilityData[2],
          secondWeekDisabilityData[3],
          secondWeekDisabilityData[4],
          secondWeekDisabilityData[5],
          secondWeekDisabilityData[6]);
       barGroup3 = makeGroupData(
          2,
          thirdWeekDisabilityData[0],
          thirdWeekDisabilityData[1],
          thirdWeekDisabilityData[2],
          thirdWeekDisabilityData[3],
          thirdWeekDisabilityData[4],
          thirdWeekDisabilityData[5],
          thirdWeekDisabilityData[6]);
       barGroup4 = makeGroupData(
          3,
          fourthWeekDisabilityData[0],
          fourthWeekDisabilityData[1],
          fourthWeekDisabilityData[2],
          fourthWeekDisabilityData[3],
          fourthWeekDisabilityData[4],
          fourthWeekDisabilityData[5],
          fourthWeekDisabilityData[6]);

      if (totalDaysInCurrentMonth > 28) {
        if(totalDaysInCurrentMonth == 29) {
          barGroup5 = makeGroupData(
            4,
            fifthWeekDisabilityData[0],
            0,
            0,
            0,
            0,
            0,
            0,
          );
        } else if (totalDaysInCurrentMonth == 30) {
          barGroup5 = makeGroupData(
            4,
            fifthWeekDisabilityData[0],
            fifthWeekDisabilityData[1],
            0,
            0,
            0,
            0,
            0,
          );
        } else {
          barGroup5 = makeGroupData(
            4,
            fifthWeekDisabilityData[0],
            fifthWeekDisabilityData[1],
            fifthWeekDisabilityData[2],
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

    }else{
      multipleFirstDisabilityListData = widget
          .editGraphViewFilterModel
          .recordsTrendsDataModel
          .recordsTrendsMultipleHeadacheDataModel
          .headacheFirst
          .disability;
      multipleSecondDisabilityListData = widget
          .editGraphViewFilterModel
          .recordsTrendsDataModel
          .recordsTrendsMultipleHeadacheDataModel
          .headacheSecond
          .disability;

      firstWeekDisabilityData = [];
      secondWeekDisabilityData= [];
      thirdWeekDisabilityData= [];
      fourthWeekDisabilityData = [];
      fifthWeekDisabilityData = [];

      multipleFirstWeekDisabilityData = [];
      multipleSecondWeekDisabilityData = [];
      multipleThirdWeekDisabilityData = [];
      multipleFourthWeekDisabilityData = [];
      multipleFifthWeekDisabilityData = [];

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
        var firstIntensityData = multipleFirstDisabilityListData.firstWhere(
                (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (firstIntensityData != null) {
          setAllWeekDisabilityData(i, firstIntensityData.value.toDouble());
        } else {
          setAllWeekDisabilityData(i, 0);
        }
        var secondIntensityData = multipleSecondDisabilityListData.firstWhere(
                (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (secondIntensityData != null) {
          setAllMultipleWeekDisabilityData(
              i, secondIntensityData.value.toDouble());
        } else {
          setAllMultipleWeekDisabilityData(i, 0);
        }
      }
      print(
          'AllDisabilityListData $firstWeekDisabilityData $secondWeekDisabilityData $thirdWeekDisabilityData $fourthWeekDisabilityData');

      print(
          'AllMultipleDisabilityListData $multipleFirstWeekDisabilityData $multipleSecondWeekDisabilityData $multipleThirdWeekDisabilityData $multipleFourthWeekDisabilityData');

      barGroup1 = makeMultipleGroupData(
          0,
          firstWeekDisabilityData[0],
          firstWeekDisabilityData[1],
          firstWeekDisabilityData[2],
          firstWeekDisabilityData[3],
          firstWeekDisabilityData[4],
          firstWeekDisabilityData[5],
          firstWeekDisabilityData[6],
          multipleFirstWeekDisabilityData[0],
          multipleFirstWeekDisabilityData[1],
          multipleFirstWeekDisabilityData[2],
          multipleFirstWeekDisabilityData[3],
          multipleFirstWeekDisabilityData[4],
          multipleFirstWeekDisabilityData[5],
          multipleFirstWeekDisabilityData[6]);
      barGroup2 = makeMultipleGroupData(
          1,
          secondWeekDisabilityData[0],
          secondWeekDisabilityData[1],
          secondWeekDisabilityData[2],
          secondWeekDisabilityData[3],
          secondWeekDisabilityData[4],
          secondWeekDisabilityData[5],
          secondWeekDisabilityData[6],
          multipleSecondWeekDisabilityData[0],
          multipleSecondWeekDisabilityData[1],
          multipleSecondWeekDisabilityData[2],
          multipleSecondWeekDisabilityData[3],
          multipleSecondWeekDisabilityData[4],
          multipleSecondWeekDisabilityData[5],
          multipleSecondWeekDisabilityData[6]);
      barGroup3 = makeMultipleGroupData(
          2,
          thirdWeekDisabilityData[0],
          thirdWeekDisabilityData[1],
          thirdWeekDisabilityData[2],
          thirdWeekDisabilityData[3],
          thirdWeekDisabilityData[4],
          thirdWeekDisabilityData[5],
          thirdWeekDisabilityData[6],
          multipleThirdWeekDisabilityData[0],
          multipleThirdWeekDisabilityData[1],
          multipleThirdWeekDisabilityData[2],
          multipleThirdWeekDisabilityData[3],
          multipleThirdWeekDisabilityData[4],
          multipleThirdWeekDisabilityData[5],
          multipleThirdWeekDisabilityData[6]);
      barGroup4 = makeMultipleGroupData(
          3,
          fourthWeekDisabilityData[0],
          fourthWeekDisabilityData[1],
          fourthWeekDisabilityData[2],
          fourthWeekDisabilityData[3],
          fourthWeekDisabilityData[4],
          fourthWeekDisabilityData[5],
          fourthWeekDisabilityData[6],
          multipleFourthWeekDisabilityData[0],
          multipleFourthWeekDisabilityData[1],
          multipleFourthWeekDisabilityData[2],
          multipleFourthWeekDisabilityData[3],
          multipleFourthWeekDisabilityData[4],
          multipleFourthWeekDisabilityData[5],
          multipleFourthWeekDisabilityData[6]);

      if (totalDaysInCurrentMonth > 28) {
        if(totalDaysInCurrentMonth == 29) {
          barGroup5 = makeMultipleGroupData(
            4,
            fifthWeekDisabilityData[0],
            0,
            0,
            0,
            0,
            0,
            0,
            multipleFifthWeekDisabilityData[0],
            0,
            0,
            0,
            0,
            0,
            0,
          );
        } else if (totalDaysInCurrentMonth == 30) {
          barGroup5 = makeMultipleGroupData(
            4,
            fifthWeekDisabilityData[0],
            fifthWeekDisabilityData[1],
            0,
            0,
            0,
            0,
            0,
            multipleFifthWeekDisabilityData[0],
            multipleFifthWeekDisabilityData[1],
            0,
            0,
            0,
            0,
            0,
          );
        } else {
          barGroup5 = makeMultipleGroupData(
            4,
            fifthWeekDisabilityData[0],
            fifthWeekDisabilityData[1],
            fifthWeekDisabilityData[2],
            0,
            0,
            0,
            0,
            multipleFifthWeekDisabilityData[0],
            multipleFifthWeekDisabilityData[1],
            multipleFifthWeekDisabilityData[2],
            0,
            0,
            0,
            0,
          );
        }
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
              fontFamily: Constant.jostRegular),
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
      widgetListData.add(SizedBox(height: 14,));
    }
    return widgetListData;
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

  void setAllMultipleWeekDisabilityData(int i, double intensityData) {
    if (i <= 7) {
      multipleFirstWeekDisabilityData.add(intensityData);
    }
    if (i > 7 && i <= 14) {
      multipleSecondWeekDisabilityData.add(intensityData);
    }
    if (i > 14 && i <= 21) {
      multipleThirdWeekDisabilityData.add(intensityData);
    }
    if (i > 21 && i <= 28) {
      multipleFourthWeekDisabilityData.add(intensityData);
    }
    if (i > 28) {
      multipleFifthWeekDisabilityData.add(intensityData);
    }
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
  setToolTipTextColor() {
    if(widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected == Constant.viewSingleHeadache){
      return Colors.white;
    }else{
      return Colors.black;
    }
  }

  Color setHeadacheColor() {
    if(firstWeekDisabilityData.length > 0  && multipleFirstWeekDisabilityData.length> 0) {
      if (firstWeekDisabilityData[0] >= multipleFirstWeekDisabilityData[0]) {
        headacheColorChanged = true;
        return Constant.otherHeadacheColor;
      } else{
        headacheColorChanged = false;
        return Constant.migraineColor;
      }

    }else return Colors.transparent;
  }
}
