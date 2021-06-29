import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsCompassScreenBloc.dart';
import 'package:mobile/models/CompassTutorialModel.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsCompareCompassModel.dart';
import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompareCompassScreen extends StatefulWidget {
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Future<DateTime> Function(CupertinoDatePickerMode, Function, DateTime)
      openDatePickerCallback;

  const CompareCompassScreen(
      {Key key,
      this.openActionSheetCallback,
      this.showApiLoaderCallback,
      this.navigateToOtherScreenCallback,
      this.openDatePickerCallback})
      : super(key: key);

  @override
  _CompareCompassScreenState createState() => _CompareCompassScreenState();
}

class _CompareCompassScreenState extends State<CompareCompassScreen>
    with AutomaticKeepAliveClientMixin {
  bool darkMode = false;
  double numberOfFeatures = 4;
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

  CompassTutorialModel _compassTutorialModelMonthly;
  CompassTutorialModel _compassTutorialModelFirstLogged;

  DateTime firstLoggedSignUpData = DateTime.now();

  CurrentUserHeadacheModel currentUserHeadacheModel;

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
            ' in ${Utils.getMonthName(firstLoggedSignUpData.month)} ${firstLoggedSignUpData.year}. Tap the Compass axes to view $monthName $currentYear.',
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

    _compassTutorialModelMonthly = CompassTutorialModel();
    _compassTutorialModelFirstLogged = CompassTutorialModel();

    _compassTutorialModelFirstLogged.isFromOnBoard = true;

    ticks = [2, 4, 6, 8, 10];

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
    _removeDataFromSharedPreference();
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
        selectedHeadacheName);

    _compassTutorialModelMonthly.currentDateTime = _dateTime;
  }

  @override
  void didUpdateWidget(covariant CompareCompassScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget of compare compass');
    _getUserCurrentHeadacheData();
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          'We noticed you didn’t log any  headache yet. So please add any headache to see your Compass data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.3,
                              fontSize: 14,
                              fontFamily: Constant.jostRegular,
                              color: Constant.chatBubbleGreen)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {
                            if (currentUserHeadacheModel != null &&
                                currentUserHeadacheModel.isOnGoing) {
                              _navigateToAddHeadacheScreen();
                            } else {
                              _navigateUserToHeadacheLogScreen();
                            }
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
              } else if (snapshot.data is RecordsCompareCompassModel) {
                _compassTutorialModelMonthly.currentDateTime = _dateTime;
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
                            Utils.showCompassTutorialDialog(context, 0,
                                compassTutorialModel:
                                    _getCompassTutorialModelObj());
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
                                  Utils.showCompassTutorialDialog(context, 0,
                                      compassTutorialModel:
                                          _getCompassTutorialModelObj());
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
                                  Utils.showCompassTutorialDialog(context, 3,
                                      compassTutorialModel:
                                          _getCompassTutorialModelObj());
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
                                    Utils.showCompassTutorialDialog(context, 1,
                                        compassTutorialModel:
                                            _getCompassTutorialModelObj());
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
                                            child: Consumer<CompareCompassInfo>(
                                              builder: (context, data, child) {
                                                int compassValue = data.getCompassValue();
                                                return RadarChart.light(
                                                  ticks: ticks,
                                                  features: features,
                                                  data: compassAxesData,
                                                  outlineColor: Constant
                                                      .chatBubbleGreen
                                                      .withOpacity(0.5),
                                                  reverseAxis: false,
                                                  compassValue: compassValue,
                                                );
                                              },
                                            ),
                                          ),
                                          Center(
                                            child: Consumer<CompareCompassInfo>(
                                              builder: (context, data, child) {
                                                bool isMonthTapSelected = data.isMonthTapSelected();
                                                return Container(
                                                  width: 38,
                                                  height: 38,
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
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Utils.showCompassTutorialDialog(context, 2,
                                        compassTutorialModel:
                                            _getCompassTutorialModelObj());
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
                                  Utils.showCompassTutorialDialog(context, 4,
                                      compassTutorialModel:
                                          _getCompassTutorialModelObj());
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
                      Consumer<CompareCompassInfo>(
                        builder: (context, data, child) {
                          bool isMonthTapSelected = data.isMonthTapSelected();
                          return GestureDetector(
                            onTap: () {
                              data.updateCompareCompassInfo(2, true);
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
                          );
                        }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<CompareCompassInfo>(
                        builder: (context, data, child) {
                          bool isMonthTapSelected = data.isMonthTapSelected();
                          return GestureDetector(
                            onTap: () {
                              data.updateCompareCompassInfo(3, false);
                            },
                            child: Container(
                              height: 35,
                              color: (!isMonthTapSelected)
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
                          );
                        },
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
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
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
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
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
    var resultFromActionSheet = await widget.openDatePickerCallback(
        CupertinoDatePickerMode.date,
        _getDateTimeCallbackFunction(0),
        _dateTime);

    if (resultFromActionSheet != null && resultFromActionSheet is DateTime)
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
      _compassTutorialModelMonthly.currentMonthFrequency =
          userFrequency.total.round();
      userMonthlyFrequencyValue = (userFrequency.value * baseMaxValue).round();
      if (userMonthlyFrequencyValue > 10) {
        userMonthlyFrequencyValue = 10;
      } else {
        userMonthlyFrequencyValue = userMonthlyFrequencyValue;
      }
    } else {
      userMonthlyFrequencyValue = 0;
      _compassTutorialModelMonthly.currentMonthFrequency = 0;
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

      _compassTutorialModelMonthly.currentMonthDuration =
          (userDuration.total).round();
    } else {
      userMonthlyDurationValue = 0;
      _compassTutorialModelMonthly.currentMonthDuration = 0;
    }
    var userIntensity = recordsCompareCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
      // userMonthlyIntensityValue = userIntensity.value ~/ (userIntensity.max / baseMaxValue);
      _compassTutorialModelMonthly.currentMonthIntensity =
          userIntensity.value.round();
      userMonthlyIntensityValue =
          (userIntensity.value * baseMaxValue) ~/ userIntensity.max;
    } else {
      _compassTutorialModelMonthly.currentMonthIntensity = 0;
      userMonthlyIntensityValue = 0;
    }
    var userDisability = recordsCompareCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
      // userMonthlyDisabilityValue = userDisability.value ~/ (userDisability.max / baseMaxValue);
      _compassTutorialModelMonthly.currentMonthDisability =
          userDisability.value.round();
      userMonthlyDisabilityValue =
          (userDisability.value * baseMaxValue) ~/ userDisability.max;
      if (userMonthlyDisabilityValue > 10) {
        userMonthlyDisabilityValue = 10;
      } else {
        userMonthlyDisabilityValue = userMonthlyDisabilityValue;
      }
    } else {
      _compassTutorialModelMonthly.currentMonthDisability = 0;
      userMonthlyDisabilityValue = 0;
    }

    _setPreviousMonthAxesData(recordsCompassAxesResultModel);

    int userOvertimeFrequencyValue,
        userOverTimeDurationValue,
        userOverTimeIntensityValue,
        userOverTimeDisabilityValue;

    int userOvertimeNormalisedFrequencyValue,
        userOverTimeNormalisedDurationValue,
        userOverTimeNormalisedDisabilityValue;

    List<Axes> recordsOverTimeCompassAxesListData =
        recordsCompassAxesResultModel.signUpCompassAxesResultModel.signUpAxes;
    print(
        'CompareCompassDateFirstLogged???${recordsCompassAxesResultModel.signUpCompassAxesResultModel.calendarEntryAt}');
    firstLoggedSignUpData = DateTime.parse(recordsCompassAxesResultModel
            .signUpCompassAxesResultModel.calendarEntryAt ??
        DateTime.now().toIso8601String());

    _compassTutorialModelFirstLogged.currentDateTime = firstLoggedSignUpData;

    var userOverTimeFrequency = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.frequency,
        orElse: () => null);
    if (userOverTimeFrequency != null) {
      // userOvertimeFrequencyValue = userOverTimeFrequency.value ~/(userOverTimeFrequency.max / baseMaxValue);
      _compassTutorialModelFirstLogged.currentMonthFrequency =
          (userOverTimeFrequency.max - userOverTimeFrequency.value).round();
      userOvertimeNormalisedFrequencyValue =
          (userOverTimeFrequency.max - userOverTimeFrequency.value).round() ~/
              (userOverTimeFrequency.max / baseMaxValue);
      userOvertimeFrequencyValue =
          (userOverTimeFrequency.max - userOverTimeFrequency.value).round();
      /*if (userOvertimeFrequencyValue > 10) {
        userOvertimeFrequencyValue = 10;
      } else {
        userOvertimeFrequencyValue = userOvertimeFrequencyValue;
      }*/
    } else {
      _compassTutorialModelFirstLogged.currentMonthFrequency = 0;
      userOvertimeNormalisedFrequencyValue = 0;
      userOvertimeFrequencyValue = 0;
    }
    var userOvertimeDuration = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userOvertimeDuration != null) {
      // userOverTimeDurationValue = userOvertimeDuration.value ~/(userOvertimeDuration.max / baseMaxValue);
      userOverTimeNormalisedDurationValue =
          userOvertimeDuration.value ~/ (userOvertimeDuration.max / 10);
      userOverTimeDurationValue = userOvertimeDuration.value.round();
      /*if (userOverTimeDurationValue > 10) {
        userOverTimeDurationValue = 10;
      } else {
        userOverTimeDurationValue = userOverTimeDurationValue;
      }*/
      _compassTutorialModelFirstLogged.currentMonthDuration = userOvertimeDuration.value.round();
          //(userOvertimeDuration.value / userOvertimeDuration.max).round();
    } else {
      userOverTimeNormalisedDurationValue = 0;
      userOverTimeDurationValue = 0;
      _compassTutorialModelFirstLogged.currentMonthDuration = 0;
    }
    var userOverTimeIntensity = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userOverTimeIntensity != null) {
      //  userOverTimeIntensityValue = userOverTimeIntensity.value ~/(userOverTimeIntensity.max / baseMaxValue);
      _compassTutorialModelFirstLogged.currentMonthIntensity =
          userOverTimeIntensity.value.round();
      userOverTimeIntensityValue = (userOverTimeIntensity.value).round();
    } else {
      userOverTimeIntensityValue = 0;
      _compassTutorialModelFirstLogged.currentMonthIntensity = 0;
    }
    var userOverTimeDisability = recordsOverTimeCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userOverTimeDisability != null) {
      // userOverTimeDisabilityValue = userOverTimeDisability.value ~/(userOverTimeDisability.max / baseMaxValue);
      _compassTutorialModelFirstLogged.currentMonthDisability =
          userOverTimeDisability.value.round();
      userOverTimeDisabilityValue =
          (userOverTimeDisability.value * baseMaxValue) ~/
              userOverTimeDisability.max;
      userOverTimeNormalisedDisabilityValue = userOverTimeDisability.value ~/
          (userOverTimeDisability.max / baseMaxValue);
      userOverTimeDisabilityValue = userOverTimeDisability.value.round();
    } else {
      _compassTutorialModelFirstLogged.currentMonthDisability = 0;
      userOverTimeDisabilityValue = 0;
      userOverTimeNormalisedDisabilityValue = 0;
    }

    compassAxesData = [
      [
        userOverTimeIntensityValue,
        userOverTimeNormalisedDurationValue ?? 0,
        userOverTimeNormalisedDisabilityValue,
        userOvertimeNormalisedFrequencyValue
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
          userFrequencyValue.value /*/ userFrequencyValue.max*/ * 100.0;

      if (frequencyScore > 100) frequencyScore = 100;
    } else {
      frequencyScore = 0;
    }

    if (userDurationValue.value != null) {
      durationScore =
          userDurationValue.value /*/ userDurationValue.max*/ * 100.0;
      if (durationScore > 100) durationScore = 100;
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
      frequencyScore = (31 - userOverTimeFrequency.value) /
          userOverTimeFrequency.max *
          100.0;
    } else {
      frequencyScore = 0;
    }
    if (userOvertimeDuration != null) {
      durationScore =
          userOvertimeDuration.value / userOvertimeDuration.max * 100.0;
    } else {
      durationScore = 0;
    }

    print(
        'intensityScore???$intensityScore???disabilityScore???$disabilityScore???frequencyScore???$frequencyScore???durationScore???$durationScore');

    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    userFirstLoggedCompassScoreData = userTotalScore.round();
    print('userTotalScore???$userFirstLoggedCompassScoreData');
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

  void _setPreviousMonthAxesData(
      RecordsCompareCompassModel recordsCompassAxesResultModel) {
    int userDisabilityValue,
        userFrequencyValue,
        userDurationValue,
        userIntensityValue;

    int baseMaxValue = 10;
    List<Axes> previousMonthCompassAxesListData = recordsCompassAxesResultModel
        .recordsCompareCompassAxesResultModel.previousAxes;
    print(recordsCompassAxesResultModel);
    var userFrequency = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.frequency,
        orElse: () => null);
    if (userFrequency != null) {
      _compassTutorialModelMonthly.previousMonthFrequency =
          userFrequency.total.round();
      userFrequencyValue =
          userFrequency.value ~/ (userFrequency.max / baseMaxValue);
    } else {
      _compassTutorialModelMonthly.previousMonthFrequency = 0;
      userFrequencyValue = 0;
    }
    var userDuration = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userDuration != null) {
      _compassTutorialModelMonthly.previousMonthDuration =
          (userDuration.total).round();
      userDurationValue =
          userDuration.value ~/ (userDuration.max / baseMaxValue);
    } else {
      _compassTutorialModelMonthly.previousMonthDuration = 0;
      userDurationValue = 0;
    }
    var userIntensity = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
      _compassTutorialModelMonthly.previousMonthIntensity =
          userIntensity.value.round();
      userIntensityValue =
          userIntensity.value ~/ (userIntensity.max / baseMaxValue);
    } else {
      _compassTutorialModelMonthly.previousMonthIntensity = 0;
      userIntensityValue = 0;
    }
    var userDisability = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
      _compassTutorialModelMonthly.previousMonthDisability =
          userDisability.value.round();
      userDisabilityValue =
          userDisability.value ~/ (userDisability.max / baseMaxValue);
    } else {
      _compassTutorialModelMonthly.previousMonthDisability = 0;
      userDisabilityValue = 0;
    }
  }

  CompassTutorialModel _getCompassTutorialModelObj() {
    var compareCompassInfo = Provider.of<CompareCompassInfo>(context);
    bool isMonthTapSelected = compareCompassInfo.isMonthTapSelected();

    if (!isMonthTapSelected) {
      return _compassTutorialModelFirstLogged;
    } else {
      return _compassTutorialModelMonthly;
    }
  }

  void _navigateToAddHeadacheScreen() async {
    DateTime currentDateTime = DateTime.now();
    DateTime endHeadacheDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        currentDateTime.hour,
        currentDateTime.minute,
        0,
        0,
        0);

    currentUserHeadacheModel.selectedEndDate =
        Utils.getDateTimeInUtcFormat(endHeadacheDateTime);

    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    currentUserHeadacheModel = await SignUpOnBoardProviders.db
        .getUserCurrentHeadacheData(userProfileInfoData.userId);

    currentUserHeadacheModel.isOnGoing = false;
    currentUserHeadacheModel.selectedEndDate =
        Utils.getDateTimeInUtcFormat(endHeadacheDateTime);

    await widget.navigateToOtherScreenCallback(
        Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    _getUserCurrentHeadacheData();
  }

  void _navigateUserToHeadacheLogScreen() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if (userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db
          .getUserCurrentHeadacheData(userProfileInfoData.userId);

    if (currentUserHeadacheModel == null) {
      await widget.navigateToOtherScreenCallback(
          Constant.headacheStartedScreenRouter, null);
    } else {
      if (currentUserHeadacheModel.isOnGoing) {
        await widget.navigateToOtherScreenCallback(
            Constant.currentHeadacheProgressScreenRouter, null);
      } else
        await widget.navigateToOtherScreenCallback(
            Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    }
    _getUserCurrentHeadacheData();
  }

  Future<void> _getUserCurrentHeadacheData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int currentPositionOfTabBar =
        sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    if (currentPositionOfTabBar == 1 && userProfileInfoData != null) {
      currentUserHeadacheModel = await SignUpOnBoardProviders.db
          .getUserCurrentHeadacheData(userProfileInfoData.userId);
    }
  }

  void _removeDataFromSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(Constant.updateOverTimeCompassData);
  }
}

class CompareCompassInfo with ChangeNotifier {
  int _compassValue = 2;
  bool _isMonthTapSelected = true;

  int getCompassValue() => _compassValue;
  bool isMonthTapSelected() => _isMonthTapSelected;

  updateCompareCompassInfo(int compassValue, bool isMonthTapSelected) {
    _compassValue = compassValue;
    _isMonthTapSelected = isMonthTapSelected;

    notifyListeners();
  }
}