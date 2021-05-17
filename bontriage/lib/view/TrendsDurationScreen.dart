import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/EditGraphViewFilterModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/models/RecordsTrendsMultipleHeadacheDataModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'DateTimePicker.dart';
import 'package:mobile/models/TrendsFilterModel.dart';

class TrendsDurationScreen extends StatefulWidget {
  final EditGraphViewFilterModel editGraphViewFilterModel;
  final Function updateTrendsDataCallback;
  final Future<DateTime> Function (CupertinoDatePickerMode, Function, DateTime) openDatePickerCallback;

  const TrendsDurationScreen(
      {Key key, this.editGraphViewFilterModel, this.updateTrendsDataCallback, this.openDatePickerCallback})
      : super(key: key);

  @override
  _TrendsDurationScreenState createState() => _TrendsDurationScreenState();
}

class _TrendsDurationScreenState extends State<TrendsDurationScreen> {
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

  List<Ity> durationListData = [];
  List<Data> multipleFirstIntensityListData = [];
  List<Data> multipleSecondIntensityListData = [];
  List<BarChartGroupData> items;
  List<TrendsDurationColorModel> firstWeekDurationData = [];
  List<TrendsDurationColorModel> secondWeekDurationData = [];
  List<TrendsDurationColorModel> thirdWeekDurationData = [];
  List<TrendsDurationColorModel> fourthWeekDurationData = [];
  List<TrendsDurationColorModel> fifthWeekDurationData = [];

  List<TrendsDurationColorModel> multipleFirstWeekDurationData = [];
  List<TrendsDurationColorModel> multipleSecondWeekDurationData = [];
  List<TrendsDurationColorModel> multipleThirdWeekDurationData = [];
  List<TrendsDurationColorModel> multipleFourthWeekDurationData = [];
  List<TrendsDurationColorModel> multipleFifthWeekDurationData = [];

  BarChartGroupData barGroup2;
  BarChartGroupData barGroup1;
  BarChartGroupData barGroup3;
  BarChartGroupData barGroup4;
  BarChartGroupData barGroup5;

  double axesMaxValue = 60;

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
    setDurationValuesData();
  }

  @override
  void didUpdateWidget(covariant TrendsDurationScreen oldWidget) {
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
    setDurationValuesData();
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: totalDaysInCurrentMonth <= 28 ? 350 : 420,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BarChart(
                  BarChartData(
                    maxY:
                        axesMaxValue + ((axesMaxValue / 10).ceil()).toDouble(),
                    minY: 0,
                    groupsSpace: 10,
                    axisTitleData: FlAxisTitleData(
                        show: true,
                        leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Headache Duration (Hours)',
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
                            String weekDay =
                                '${Utils.getShortMonthName(_dateTime.month)} ${(groupIndex * 7) + rodIndex + 1}';
                            return BarTooltipItem(
                                weekDay +
                                    '\n' +
                                    (rod.y.toInt()).toString() +
                                    ' hours',
                                TextStyle(
                                    color:  setToolTipTextColor(),
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
                      checkToShowHorizontalLine: (value) => value % (axesMaxValue / 10).ceil() == 0,
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
                        interval: (((axesMaxValue == 0? 60:axesMaxValue) / 10).ceil()).toDouble(),
                        reservedSize: 11,
                        getTitles: (value) {
                          return setLeftAxisTitlesValue(value);
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

  BarChartGroupData makeGroupData(int x, TrendsDurationColorModel y1, TrendsDurationColorModel y2, TrendsDurationColorModel y3,
      TrendsDurationColorModel y4, TrendsDurationColorModel y5, TrendsDurationColorModel y6, TrendsDurationColorModel y7) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [
      BarChartRodData(
        y: y1.durationValue,
        colors: setBarChartColor(y1.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y2.durationValue,
        colors: setBarChartColor(y2.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y3.durationValue,
        colors: setBarChartColor(y3.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y4.durationValue,
        colors: setBarChartColor(y4.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y5.durationValue,
        colors: setBarChartColor(y5.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y6.durationValue,
        colors: setBarChartColor(y6.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
      BarChartRodData(
        y: y7.durationValue,
        colors: setBarChartColor(y7.durationColorIntensity),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3), topRight: Radius.circular(3)),
      ),
    ]);
  }

  /// @param cupertinoDatePickerMode: for time and date mode selection
  void _openDatePickerBottomSheet(
      CupertinoDatePickerMode cupertinoDatePickerMode) async{
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
    if(clickedValue != null){
      if(clickedValue > 0){
        return Constant.migraineColor;
      }else return Colors.transparent;
    }else return Colors.transparent;
  }

  setToolTipTextColor() {
    if (clickedValue != null) {
      if (clickedValue == 0) {
        return Colors.transparent;
      } else
        return Colors.black;
    }
  }

  List<Color> setBarChartColor(int barChartValue) {
    if(barChartValue == 2) {
      return [Constant.migraineColor];
    }else if(barChartValue == 1){
      return [Constant.lightDurationColor];
    }else  return [Constant.transparentColor];
  }

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
      widgetListData.add(SizedBox(
        height: 14,
      ));
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

  void setDurationValuesData() {
    if (widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected ==
        Constant.viewSingleHeadache) {
      durationListData = widget
          .editGraphViewFilterModel.recordsTrendsDataModel.headache.duration;
      firstWeekDurationData = [];
      secondWeekDurationData = [];
      thirdWeekDurationData = [];
      fourthWeekDurationData = [];
      fifthWeekDurationData = [];
      List durationValueDate = [];
      int remainingHeadacheDurationValue = 0;

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
        var durationData = durationListData.firstWhere(
            (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (durationData != null) {
          durationValueDate.add(durationData.value);
          if (durationData.value > 24) {
            remainingHeadacheDurationValue = (durationData.value - 24).round();
          } else {
            remainingHeadacheDurationValue = 0;
          }
          setAllWeekDurationData(i, durationData.value.toDouble(),Constant.highBarColorIntensity);
        } else if (remainingHeadacheDurationValue > 0) {
          if (remainingHeadacheDurationValue <= 24) {
            setAllWeekDurationData(
                i, remainingHeadacheDurationValue.toDouble(),Constant.mediumBarIntensity);
            remainingHeadacheDurationValue = 0;
          } else {
            setAllWeekDurationData(i, 24,Constant.mediumBarIntensity);
            remainingHeadacheDurationValue =
                remainingHeadacheDurationValue - 24;
          }
        }else{
          setAllWeekDurationData(i, 0,Constant.lowBarColorIntensity);
        }
      }
      try {
        if (durationValueDate.length > 0) {
          axesMaxValue = durationValueDate
              .reduce((curr, next) => curr > next ? curr : next);
          print('Maximum ListData Value $axesMaxValue');
        }
      } catch (Exception) {
        print('Maximum ListData Value $Exception');
      }

      print(
          'AllIntensityListData $firstWeekDurationData $secondWeekDurationData $thirdWeekDurationData $fourthWeekDurationData');

      barGroup1 = makeGroupData(
          0,
          firstWeekDurationData[0],
          firstWeekDurationData[1],
          firstWeekDurationData[2],
          firstWeekDurationData[3],
          firstWeekDurationData[4],
          firstWeekDurationData[5],
          firstWeekDurationData[6]);
      barGroup2 = makeGroupData(
          1,
          secondWeekDurationData[0],
          secondWeekDurationData[1],
          secondWeekDurationData[2],
          secondWeekDurationData[3],
          secondWeekDurationData[4],
          secondWeekDurationData[5],
          secondWeekDurationData[6]);
      barGroup3 = makeGroupData(
          2,
          thirdWeekDurationData[0],
          thirdWeekDurationData[1],
          thirdWeekDurationData[2],
          thirdWeekDurationData[3],
          thirdWeekDurationData[4],
          thirdWeekDurationData[5],
          thirdWeekDurationData[6]);
      barGroup4 = makeGroupData(
          3,
          fourthWeekDurationData[0],
          fourthWeekDurationData[1],
          fourthWeekDurationData[2],
          fourthWeekDurationData[3],
          fourthWeekDurationData[4],
          fourthWeekDurationData[5],
          fourthWeekDurationData[6]);

      if (totalDaysInCurrentMonth > 28) {
        if(totalDaysInCurrentMonth == 29) {
          barGroup5 = makeGroupData(
            4,
            fifthWeekDurationData[0],
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
          );
        } else if (totalDaysInCurrentMonth == 30) {
          barGroup5 = makeGroupData(
            4,
            fifthWeekDurationData[0],
            fifthWeekDurationData[1],
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
          );
        } else {
          barGroup5 = makeGroupData(
            4,
            fifthWeekDurationData[0],
            fifthWeekDurationData[1],
            fifthWeekDurationData[2],
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
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
    }else {
      multipleFirstIntensityListData = widget
          .editGraphViewFilterModel
          .recordsTrendsDataModel
          .recordsTrendsMultipleHeadacheDataModel
          .headacheFirst
          .duration;

      multipleSecondIntensityListData = widget
          .editGraphViewFilterModel
          .recordsTrendsDataModel
          .recordsTrendsMultipleHeadacheDataModel
          .headacheSecond
          .duration;

      firstWeekDurationData = [];
      secondWeekDurationData = [];
      thirdWeekDurationData = [];
      fourthWeekDurationData = [];
      fifthWeekDurationData = [];

      multipleFirstWeekDurationData = [];
      multipleSecondWeekDurationData = [];
      multipleThirdWeekDurationData = [];
      multipleFourthWeekDurationData = [];
      multipleFifthWeekDurationData = [];

      List durationValueDate = [];
      int remainingHeadacheDurationValue = 0;

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
        var firstDurationData = multipleFirstIntensityListData.firstWhere(
                (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (firstDurationData != null) {
          durationValueDate.add(firstDurationData.value);
          if (firstDurationData.value > 24) {
            remainingHeadacheDurationValue = (firstDurationData.value - 24).round();
          } else {
            remainingHeadacheDurationValue = 0;
          }
          setAllWeekDurationData(i, firstDurationData.value.toDouble(),Constant.highBarColorIntensity);
        } else if (remainingHeadacheDurationValue > 0) {
          if (remainingHeadacheDurationValue <= 24) {
            setAllWeekDurationData(
                i, remainingHeadacheDurationValue.toDouble(),Constant.mediumBarIntensity);
            remainingHeadacheDurationValue = 0;
          } else {
            setAllWeekDurationData(i, 24,Constant.mediumBarIntensity);
            remainingHeadacheDurationValue =
                remainingHeadacheDurationValue - 24;
          }
        }else{
          setAllWeekDurationData(i, 0,Constant.lowBarColorIntensity);
        }
        var secondDurationData = multipleSecondIntensityListData.firstWhere(
                (element) => element.date.isAtSameMomentAs(dateTime),
            orElse: () => null);
        if (secondDurationData != null) {
          durationValueDate.add(secondDurationData.value);
          if (secondDurationData.value > 24) {
            remainingHeadacheDurationValue = (secondDurationData.value - 24).round();
          } else {
            remainingHeadacheDurationValue = 0;
          }
          setAllMultipleWeekDurationData(i, secondDurationData.value.toDouble(),Constant.highBarColorIntensity);
        } else if (remainingHeadacheDurationValue > 0) {
          if (remainingHeadacheDurationValue <= 24) {
            setAllMultipleWeekDurationData(
                i, remainingHeadacheDurationValue.toDouble(),Constant.mediumBarIntensity);
            remainingHeadacheDurationValue = 0;
          } else {
            setAllMultipleWeekDurationData(i, 24,Constant.mediumBarIntensity);
            remainingHeadacheDurationValue =
                remainingHeadacheDurationValue - 24;
          }
        }else{
          setAllMultipleWeekDurationData(i, 0,Constant.lowBarColorIntensity);
        }
      }

      try {
        if (durationValueDate.length > 0) {
          axesMaxValue = durationValueDate
              .reduce((curr, next) => curr > next ? curr : next);
          print('Maximum ListData Value $axesMaxValue');
        }
      } catch (Exception) {
        print('Maximum ListData Value $Exception');
      }
      print(
          'AllIntensityListData $firstWeekDurationData $secondWeekDurationData $thirdWeekDurationData $fourthWeekDurationData');

      print(
          'AllIntensityListData $multipleFirstWeekDurationData $multipleSecondWeekDurationData $multipleThirdWeekDurationData $multipleFourthWeekDurationData');

      barGroup1 = makeMultipleGroupData(
          0,
          firstWeekDurationData[0],
          firstWeekDurationData[1],
          firstWeekDurationData[2],
          firstWeekDurationData[3],
          firstWeekDurationData[4],
          firstWeekDurationData[5],
          firstWeekDurationData[6],
          multipleFirstWeekDurationData[0],
          multipleFirstWeekDurationData[1],
          multipleFirstWeekDurationData[2],
          multipleFirstWeekDurationData[3],
          multipleFirstWeekDurationData[4],
          multipleFirstWeekDurationData[5],
          multipleFirstWeekDurationData[6]);
      barGroup2 = makeMultipleGroupData(
          1,
          secondWeekDurationData[0],
          secondWeekDurationData[1],
          secondWeekDurationData[2],
          secondWeekDurationData[3],
          secondWeekDurationData[4],
          secondWeekDurationData[5],
          secondWeekDurationData[6],
          multipleSecondWeekDurationData[0],
          multipleSecondWeekDurationData[1],
          multipleSecondWeekDurationData[2],
          multipleSecondWeekDurationData[3],
          multipleSecondWeekDurationData[4],
          multipleSecondWeekDurationData[5],
          multipleSecondWeekDurationData[6]);
      barGroup3 = makeMultipleGroupData(
          2,
          thirdWeekDurationData[0],
          thirdWeekDurationData[1],
          thirdWeekDurationData[2],
          thirdWeekDurationData[3],
          thirdWeekDurationData[4],
          thirdWeekDurationData[5],
          thirdWeekDurationData[6],
          multipleThirdWeekDurationData[0],
          multipleThirdWeekDurationData[1],
          multipleThirdWeekDurationData[2],
          multipleThirdWeekDurationData[3],
          multipleThirdWeekDurationData[4],
          multipleThirdWeekDurationData[5],
          multipleThirdWeekDurationData[6]);
      barGroup4 = makeMultipleGroupData(
          3,
          fourthWeekDurationData[0],
          fourthWeekDurationData[1],
          fourthWeekDurationData[2],
          fourthWeekDurationData[3],
          fourthWeekDurationData[4],
          fourthWeekDurationData[5],
          fourthWeekDurationData[6],
          multipleFourthWeekDurationData[0],
          multipleFourthWeekDurationData[1],
          multipleFourthWeekDurationData[2],
          multipleFourthWeekDurationData[3],
          multipleFourthWeekDurationData[4],
          multipleFourthWeekDurationData[5],
          multipleFourthWeekDurationData[6]);

      if (totalDaysInCurrentMonth > 28) {
        if(totalDaysInCurrentMonth == 29) {
          barGroup5 = makeMultipleGroupData(
            4,
            multipleFifthWeekDurationData[0],
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
          );
        } else if (totalDaysInCurrentMonth == 30) {
          barGroup5 = makeMultipleGroupData(
            4,
            fifthWeekDurationData[0],
            fifthWeekDurationData[1],
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
          );
        } else {
          barGroup5 = makeMultipleGroupData(
            4,
            fifthWeekDurationData[0],
            fifthWeekDurationData[1],
            fifthWeekDurationData[2],
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
            TrendsDurationColorModel(durationValue: 0,durationColorIntensity:Constant.lowBarColorIntensity),
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
  }

  void setAllWeekDurationData(int i, double durationData, int durationColorIntensity) {
    if (i <= 7) {
      firstWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 7 && i <= 14) {
      secondWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 14 && i <= 21) {
      thirdWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 21 && i <= 28) {
      fourthWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 28) {
      fifthWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
  }


  void setAllMultipleWeekDurationData(int i , double durationData , int durationColorIntensity){
    if (i <= 7) {
      multipleFirstWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 7 && i <= 14) {
      multipleSecondWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 14 && i <= 21) {
      multipleThirdWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 21 && i <= 28) {
      multipleFourthWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }
    if (i > 28) {
      multipleFifthWeekDurationData.add(TrendsDurationColorModel(durationValue: durationData,durationColorIntensity: durationColorIntensity));
    }

  }

  BarChartGroupData makeMultipleGroupData(
      int x,
      TrendsDurationColorModel firstMultipleHeadache1,
      TrendsDurationColorModel firstMultipleHeadache2,
      TrendsDurationColorModel firstMultipleHeadache3,
      TrendsDurationColorModel firstMultipleHeadache4,
      TrendsDurationColorModel firstMultipleHeadache5,
      TrendsDurationColorModel firstMultipleHeadache6,
      TrendsDurationColorModel firstMultipleHeadache7,
      TrendsDurationColorModel secondMultipleHeadache1,
      TrendsDurationColorModel secondMultipleHeadache2,
      TrendsDurationColorModel secondMultipleHeadache3,
      TrendsDurationColorModel secondMultipleHeadache4,
      TrendsDurationColorModel secondMultipleHeadache5,
      TrendsDurationColorModel secondMultipleHeadache6,
      TrendsDurationColorModel secondMultipleHeadache7) {
    return BarChartGroupData(barsSpace: 2.5, x: x, barRods: [
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache1.durationValue, secondMultipleHeadache1.durationValue),
        rodStackItems: setRodStack(firstMultipleHeadache1.durationValue, secondMultipleHeadache1.durationValue),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache2.durationValue, secondMultipleHeadache2.durationValue),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache2.durationValue, secondMultipleHeadache2.durationValue),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache3.durationValue, secondMultipleHeadache3.durationValue),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache3.durationValue, secondMultipleHeadache3.durationValue)
        ,
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache4.durationValue, secondMultipleHeadache4.durationValue),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache4.durationValue, secondMultipleHeadache4.durationValue),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache5.durationValue, secondMultipleHeadache5.durationValue),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache5.durationValue, secondMultipleHeadache5.durationValue),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache6.durationValue, secondMultipleHeadache6.durationValue),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache6.durationValue, secondMultipleHeadache6.durationValue),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      BarChartRodData(
        y: setAxisValue(firstMultipleHeadache7.durationValue, secondMultipleHeadache7.durationValue),
        colors: [Colors.transparent],
        rodStackItems: setRodStack(firstMultipleHeadache7.durationValue, secondMultipleHeadache7.durationValue),
        width: width,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
    ]);
  }

  List<BarChartRodStackItem> setRodStack(
      double firstMultipleHeadache1, double secondMultipleHeadache1) {
    var maxValue, minValue = 0.0;
    if (firstMultipleHeadache1 >= secondMultipleHeadache1) {
      maxValue = firstMultipleHeadache1;
      minValue = secondMultipleHeadache1;
      return [
        BarChartRodStackItem(0, secondMultipleHeadache1, Constant.migraineColor),
        BarChartRodStackItem(secondMultipleHeadache1, firstMultipleHeadache1, Constant.otherHeadacheColor),
      ];
    } else {
      minValue = firstMultipleHeadache1;
      maxValue = secondMultipleHeadache1;
      return [
        BarChartRodStackItem(0, firstMultipleHeadache1, Constant.otherHeadacheColor),
        BarChartRodStackItem(firstMultipleHeadache1, secondMultipleHeadache1, Constant.migraineColor),
      ];
    }
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

  String setLeftAxisTitlesValue(double value) {
    if (value % (axesMaxValue / 10).ceil() == 0) {
      return '${value.toInt()}';
    } else
      return '0';
  }

  Color setHeadacheColor() {
    if(firstWeekDurationData.length > 0  && multipleFirstWeekDurationData.length> 0) {
      if (firstWeekDurationData[0].durationValue >= multipleFirstWeekDurationData[0].durationValue) {
        headacheColorChanged = true;
        return Constant.otherHeadacheColor;
      } else{
        headacheColorChanged = false;
        return Constant.migraineColor;
      }

    }else return Colors.transparent;
  }
}
class TrendsDurationColorModel {
  double durationValue;
  int durationColorIntensity;
  TrendsDurationColorModel({this.durationValue,this.durationColorIntensity});
}
