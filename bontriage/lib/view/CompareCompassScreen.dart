import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsCompassScreenBloc.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsCompareCompassModel.dart';
import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DateTimePicker.dart';

class CompareCompassScreen extends StatefulWidget {
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;

  const CompareCompassScreen(
      {Key key,
      this.openActionSheetCallback,
      this.showApiLoaderCallback,
      this.navigateToOtherScreenCallback})
      : super(key: key);

  @override
  _CompareCompassScreenState createState() => _CompareCompassScreenState();
}

class _CompareCompassScreenState extends State<CompareCompassScreen>
    with AutomaticKeepAliveClientMixin {
  bool darkMode = false;
  double numberOfFeatures = 4;
  bool isMonthTapSelected = true;
  bool isFirstLoggedSelected = false;
  int compassValue = 2;
  DateTime _dateTime;
  int currentMonth;

  int currentYear = 2021;
  String monthName = 'Feb';
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;
  RecordsCompassScreenBloc _recordsCompassScreenBloc;

  List<int> ticks;

  List<String> features;

  List<List<int>> compassAxesData;

  String selectedHeadacheName;
  List<HeadacheListDataModel> headacheListModelData;
  int userMonthlyCompassScoreData = 0;
  int userFirstLoggedCompassScoreData = 0;
  String lastSelectedHeadacheName;

  DateTime firstLoggedSignUpData = DateTime.now();

  List<TextSpan> _getBubbleTextSpans() {
    List<TextSpan> list = [];
    list.add(TextSpan(
        text: 'Your first logged Headache score was ',
        style: TextStyle(
            height: 1.2,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));
    list.add(TextSpan(
        text: userFirstLoggedCompassScoreData.toString(),
        style: TextStyle(
            height: 1.2,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.addCustomNotificationTextColor)));
    list.add(TextSpan(
        text:
            ' in ${Utils.getMonthName(firstLoggedSignUpData.month)} ${firstLoggedSignUpData.year}. Tap the Compass to view $monthName $currentYear  ',
        style: TextStyle(
            height: 1.2,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));

    return list;
  }

  @override
  void initState() {
    super.initState();

    ticks = [0, 2, 4, 6, 8, 10];

    features = [
      "A",
      "B",
      "C",
      "D",
    ];
    compassAxesData = [
      [4, 6, 6, 19],
      [7, 10, 10, 21]
    ];
    _recordsCompassScreenBloc = RecordsCompassScreenBloc();
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
    print('init state of compare compass');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.showApiLoaderCallback(_recordsCompassScreenBloc.networkDataStream,
          () {
        _recordsCompassScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
            selectedHeadacheName);
      });
    });
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
        selectedHeadacheName);
  }

  @override
  void didUpdateWidget(covariant CompareCompassScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget of compare compass');
    _updateCompassData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: StreamBuilder<dynamic>(
          stream: _recordsCompassScreenBloc.recordsCompassDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == Constant.noHeadacheData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                        'We noticed you didn’t log any  headache yet. So please\nadd any headache to see your Compass data.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.3,
                            fontSize: 18,
                            fontFamily: Constant.jostRegular,
                            color: Constant.chatBubbleGreen)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {
                            navigateToHeadacheStartScreen();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 7),
                            decoration: BoxDecoration(
                              color: Constant.chatBubbleGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Add Headache',
                                style: TextStyle(
                                    color: Constant.bubbleChatTextView,
                                    fontSize: 15,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                if (selectedHeadacheName == null) {
                  List<HeadacheListDataModel> headacheListModelData =
                      snapshot.data.headacheListDataModel;
                  selectedHeadacheName = headacheListModelData[0].text;
                }
                setCompassAxesData(snapshot.data);
                return Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _openHeadacheTypeActionSheet(
                              snapshot.data.headacheListDataModel);
                        },
                        child: Card(
                          elevation: 4,
                          color: Colors.transparent,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          semanticContainer: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 30),
                            decoration: BoxDecoration(
                              color: Constant.compassMyHeadacheTextColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              selectedHeadacheName != null
                                  ? selectedHeadacheName
                                  : '',
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 16,
                                  fontFamily: Constant.jostRegular),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(children: [
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
                              child: GestureDetector(
                                onTap: () {
                                  Utils.showCompassTutorialDialog(context, 0);
                                },
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
                                            child: RadarChart.light(
                                              ticks: ticks,
                                              features: features,
                                              data: compassAxesData,
                                              outlineColor: Constant
                                                  .chatBubbleGreen
                                                  .withOpacity(0.5),
                                              reverseAxis: false,
                                              compassValue: compassValue,
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              child: Center(
                                                child: Text(
                                                  isMonthTapSelected
                                                      ? userMonthlyCompassScoreData
                                                          .toString()
                                                      : userFirstLoggedCompassScoreData
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: isMonthTapSelected
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          Constant.jostMedium),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isMonthTapSelected
                                                    ? Constant
                                                        .compareCompassHeadacheValueColor
                                                    : Constant
                                                        .compareCompassMonthSelectedColor,
                                                border: Border.all(
                                                    color: isMonthTapSelected
                                                        ? Constant
                                                            .compareCompassHeadacheValueColor
                                                        : Constant
                                                            .compareCompassMonthSelectedColor,
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
                        )
                      ]),
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
                                      color: Constant
                                          .compareCompassHeadacheValueColor,
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
                                        color: Constant
                                            .addCustomNotificationTextColor,
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
                );
              }
            } else if (snapshot.hasError) {
              return Container();
            } else {
              return Container();
            }
          }),
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
      _recordsCompassScreenBloc.initNetworkStreamController();
      print('show api loader 11');
      Utils.showApiLoaderDialog(context,
          networkStream: _recordsCompassScreenBloc.networkDataStream,
          tapToRetryFunction: () {
        _recordsCompassScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
            selectedHeadacheName);
      });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName);
    });
  }

  void requestService(String firstDayOfTheCurrentMonth,
      String lastDayOfTheCurrentMonth, String selectedHeadacheName) async {
    await _recordsCompassScreenBloc.fetchAllHeadacheListData(
        firstDayOfTheCurrentMonth,
        lastDayOfTheCurrentMonth,
        false,
        selectedHeadacheName);
  }

  void setCompassAxesData(
      RecordsCompareCompassModel recordsCompassAxesResultModel) {
    int userMonthlyDisabilityValue,
        userMonthlyFrequencyValue,
        userMonthlyDurationValue,
        userMonthlyIntensityValue;

    int baseMaxValue = 10;

    List<Axes> recordsCompareCompassAxesListData = recordsCompassAxesResultModel
        .recordsCompareCompassAxesResultModel.currentAxes;
    var userFrequency = recordsCompareCompassAxesListData.firstWhere(
        (frequencyElement) => frequencyElement.name == Constant.frequency,
        orElse: () => null);
    if (userFrequency != null) {
      userMonthlyFrequencyValue = (userFrequency.value * baseMaxValue).round();
      if (userMonthlyFrequencyValue > 10) {
        userMonthlyFrequencyValue = 10;
      } else {
        userMonthlyFrequencyValue = userMonthlyFrequencyValue;
      }
    } else {
      userMonthlyFrequencyValue = 0;
    }
    var userDuration = recordsCompareCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userDuration != null) {
      //userMonthlyDurationValue = userDuration.value ~/ (userDuration.max / baseMaxValue);
      userMonthlyDurationValue = (userDuration.value * baseMaxValue).round();
      if (userMonthlyDurationValue > 10) {
        userMonthlyDurationValue = 10;
      } else {
        userMonthlyDurationValue = userMonthlyDurationValue;
      }
    } else {
      userMonthlyDurationValue = 0;
    }
    var userIntensity = recordsCompareCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
      // userMonthlyIntensityValue = userIntensity.value ~/ (userIntensity.max / baseMaxValue);
      userMonthlyIntensityValue =
          (userIntensity.value * baseMaxValue) ~/ userIntensity.max;
    } else {
      userMonthlyIntensityValue = 0;
    }
    var userDisability = recordsCompareCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
      // userMonthlyDisabilityValue = userDisability.value ~/ (userDisability.max / baseMaxValue);
      userMonthlyDisabilityValue =
          (userDisability.value * baseMaxValue) ~/ userDisability.max;
      if (userMonthlyDisabilityValue > 10) {
        userMonthlyDisabilityValue = 10;
      } else {
        userMonthlyDisabilityValue = userMonthlyDisabilityValue;
      }
    } else {
      userMonthlyDisabilityValue = 0;
    }

    int userOvertimeFrequencyValue,
        userOverTimeDurationValue,
        userOverTimeIntensityValue,
        userOverTimeDisabilityValue;

    List<Axes> recordsOverTimeCompassAxesListData =
        recordsCompassAxesResultModel.signUpCompassAxesResultModel.signUpAxes;
    firstLoggedSignUpData = DateTime.parse(recordsCompassAxesResultModel
            .signUpCompassAxesResultModel.calendarEntryAt)
        .toLocal();

    var userOverTimeFrequency = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.frequency,
        orElse: () => null);
    if (userOverTimeFrequency != null) {
      // userOvertimeFrequencyValue = userOverTimeFrequency.value ~/(userOverTimeFrequency.max / baseMaxValue);
      userOvertimeFrequencyValue =
          (userOverTimeFrequency.value * baseMaxValue).round();
      if (userOvertimeFrequencyValue > 10) {
        userOvertimeFrequencyValue = 10;
      } else {
        userOvertimeFrequencyValue = userOvertimeFrequencyValue;
      }
    } else {
      userOvertimeFrequencyValue = 0;
    }
    var userOvertimeDuration = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userOvertimeDuration != null) {
      // userOverTimeDurationValue = userOvertimeDuration.value ~/(userOvertimeDuration.max / baseMaxValue);
      userOverTimeDurationValue =
          (userOvertimeDuration.value * baseMaxValue).round();
      if (userOverTimeDurationValue > 10) {
        userOverTimeDurationValue = 10;
      } else {
        userOverTimeDurationValue = userOverTimeDurationValue;
      }
    } else {
      userOverTimeDurationValue = 0;
    }
    var userOverTimeIntensity = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userOverTimeIntensity != null) {
      //  userOverTimeIntensityValue = userOverTimeIntensity.value ~/(userOverTimeIntensity.max / baseMaxValue);
      userOverTimeIntensityValue =
          (userOverTimeIntensity.value * baseMaxValue) ~/
              userOverTimeIntensity.max;
    } else {
      userOverTimeIntensityValue = 0;
    }
    var userOverTimeDisability = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userOverTimeDisability != null) {
      // userOverTimeDisabilityValue = userOverTimeDisability.value ~/(userOverTimeDisability.max / baseMaxValue);
      userOverTimeDisabilityValue =
          (userOverTimeDisability.value * baseMaxValue) ~/
              userOverTimeDisability.max;
      if (userOverTimeDisabilityValue > 10) {
        userOverTimeDisabilityValue = 10;
      } else {
        userOverTimeDisabilityValue = userOverTimeDisabilityValue;
      }
    } else {
      userOverTimeDisabilityValue = 0;
    }
    compassAxesData = [
      [
        userOverTimeIntensityValue,
        userOverTimeDurationValue,
        userOverTimeDisabilityValue,
        userOvertimeFrequencyValue
      ],
      [
        userMonthlyIntensityValue,
        userMonthlyDurationValue,
        userMonthlyDisabilityValue,
        userMonthlyFrequencyValue
      ],
    ];

    print('Compare Compass Axes Data?????$compassAxesData');

    if (recordsCompareCompassAxesListData.length > 0) {
      setMonthlyCompassDataScore(
          userIntensity, userDisability, userFrequency, userDuration);
    } else {
      userMonthlyCompassScoreData = 0;
    }
    setFirstLoggedCompassDataScore(userOverTimeIntensity,
        userOverTimeDisability, userOverTimeFrequency, userOvertimeDuration);
  }

  void setMonthlyCompassDataScore(
      Axes userIntensityValue,
      Axes userDisabilityValue,
      Axes userFrequencyValue,
      Axes userDurationValue) {
    var intensityScore, disabilityScore, frequencyScore, durationScore;
    if (userIntensityValue.value != null) {
      intensityScore =
          userIntensityValue.value / userIntensityValue.max * 100.0;
    } else {
      intensityScore = 0;
    }
    if (userDisabilityValue.value != null) {
      disabilityScore =
          userDisabilityValue.value / userDisabilityValue.max * 100.0;
    } else {
      disabilityScore = 0;
    }
    if (userFrequencyValue.value != null) {
      frequencyScore =
          userFrequencyValue.value / userFrequencyValue.max * 100.0;
    } else {
      frequencyScore = 0;
    }

    if (userDurationValue.value != null) {
      durationScore = userDurationValue.value / userDurationValue.max * 100.0;
    } else {
      durationScore = 0;
    }

    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    userMonthlyCompassScoreData = userTotalScore.round();
    print(userMonthlyCompassScoreData);
  }

  void setFirstLoggedCompassDataScore(
      Axes userOverTimeIntensity,
      Axes userOverTimeDisability,
      Axes userOverTimeFrequency,
      Axes userOvertimeDuration) {
    var intensityScore, disabilityScore, frequencyScore, durationScore;
    if (userOverTimeIntensity != null) {
      intensityScore =
          userOverTimeIntensity.value / userOverTimeIntensity.max * 100.0;
    } else {
      intensityScore = 0;
    }
    if (userOverTimeDisability != null) {
      disabilityScore =
          userOverTimeDisability.value / userOverTimeDisability.max * 100.0;
    } else {
      disabilityScore = 0;
    }
    if (userOverTimeFrequency != null) {
      frequencyScore =
          userOverTimeFrequency.value / userOverTimeFrequency.max * 100.0;
    } else {
      frequencyScore = 0;
    }
    if (userOvertimeDuration != null) {
      durationScore =
          userOvertimeDuration.value / userOvertimeDuration.max * 100.0;
    } else {
      durationScore = 0;
    }

    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    userFirstLoggedCompassScoreData = userTotalScore.round();
    print(userFirstLoggedCompassScoreData);
  }

  @override
  bool get wantKeepAlive => true;

  void _openHeadacheTypeActionSheet(
      List<HeadacheListDataModel> headacheListData) async {
    if (lastSelectedHeadacheName != null) {
      var lastSelectedHeadacheNameData = headacheListData.firstWhere(
          (element) => element.text == lastSelectedHeadacheName,
          orElse: () => null);
      if (lastSelectedHeadacheNameData != null) {
        lastSelectedHeadacheNameData.isSelected = true;
      }
    }
    var resultFromActionSheet = await widget.openActionSheetCallback(
        Constant.compassHeadacheTypeActionSheet, headacheListData);
    lastSelectedHeadacheName = resultFromActionSheet;
    headacheListModelData = headacheListData;
    if (resultFromActionSheet != null) {
      selectedHeadacheName = resultFromActionSheet.toString();
      _recordsCompassScreenBloc.initNetworkStreamController();
      print('show api loader 14');
      widget.showApiLoaderCallback(_recordsCompassScreenBloc.networkDataStream,
          () {
        _recordsCompassScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
            selectedHeadacheName);
      });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName);

      print(resultFromActionSheet);
    }
  }

  void _updateCompassData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String isSeeMoreClicked =
        sharedPreferences.getString(Constant.isSeeMoreClicked) ??
            Constant.blankString;
    String isTrendsClicked =
        sharedPreferences.getString(Constant.isViewTrendsClicked) ??
            Constant.blankString;
    String updateCompareCompassData =
        sharedPreferences.getString(Constant.updateCompareCompassData) ??
            Constant.blankString;

    if (isSeeMoreClicked.isEmpty &&
        isTrendsClicked.isEmpty &&
        updateCompareCompassData == Constant.trueString) {
      sharedPreferences.remove(Constant.updateCompareCompassData);
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
      print('show api loader 7');
      _recordsCompassScreenBloc.initNetworkStreamController();
      widget.showApiLoaderCallback(_recordsCompassScreenBloc.networkDataStream,
          () {
        _recordsCompassScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
            selectedHeadacheName);
      });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName);
    }
  }

  void navigateToHeadacheStartScreen() async {
    await widget.navigateToOtherScreenCallback(
        Constant.headacheStartedScreenRouter, null);
  }
}
