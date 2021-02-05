import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsCompassScreenBloc.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsOverTimeCompassModel.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/NetworkErrorScreen.dart';
import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DateTimePicker.dart';

class OverTimeCompassScreen extends StatefulWidget {
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;

  const OverTimeCompassScreen(
      {Key key, this.openActionSheetCallback, this.showApiLoaderCallback})
      : super(key: key);

  @override
  _OverTimeCompassScreenState createState() => _OverTimeCompassScreenState();
}

class _OverTimeCompassScreenState extends State<OverTimeCompassScreen>
    with AutomaticKeepAliveClientMixin {
  RecordsCompassScreenBloc _recordsCompassScreenBloc;
  bool darkMode = false;
  double numberOfFeatures = 4;
  DateTime _dateTime;
  int currentMonth;
  int currentYear;
  String monthName;
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;

  List<List<int>> compassAxesData;

  List<int> ticks;

  List<String> features;
  String selectedHeadacheName;
  String lastSelectedHeadacheName;

  String userScoreData;

  List<TextSpan> _getBubbleTextSpans() {
    List<TextSpan> list = [];
    list.add(TextSpan(
        text: 'Your Headache Score for December was ',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));
    list.add(TextSpan(
        text: '62',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.addCustomNotificationTextColor)));
    list.add(TextSpan(
        text: ' up from ',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));
    list.add(TextSpan(
        text: '60',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.addCustomNotificationTextColor)));
    list.add(TextSpan(
        text: ' last month. This was primarily due to an ',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));
    list.add(TextSpan(
        text: 'increase in duration.',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.addCustomNotificationTextColor)));

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
      [14, 15, 7, 7]
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
    print('init state of overTime compass');
    _recordsCompassScreenBloc.initNetworkStreamController();
    _showApiLoaderDialog();
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
        selectedHeadacheName);
  }

  @override
  void didUpdateWidget(covariant OverTimeCompassScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
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
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 30),
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
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
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
                                            child: darkMode
                                                ? RadarChart.dark(
                                                    ticks: ticks,
                                                    features: features,
                                                    data: compassAxesData,
                                                    reverseAxis: true,
                                                    compassValue: 1,
                                                  )
                                                : RadarChart.light(
                                                    ticks: ticks,
                                                    features: features,
                                                    data: compassAxesData,
                                                    outlineColor: Constant
                                                        .chatBubbleGreen
                                                        .withOpacity(0.5),
                                                    reverseAxis: true,
                                                    compassValue: 1,
                                                  ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              child: Center(
                                                child: Text(
                                                  userScoreData != null
                                                      ? userScoreData
                                                      : '0',
                                                  style: TextStyle(
                                                      color: Color(0xff0E1712),
                                                      fontSize: 14,
                                                      fontFamily:
                                                          Constant.jostMedium),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff97c289),
                                                border: Border.all(
                                                    color: Color(0xff97c289),
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
                      ],
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
                            _openDatePickerBottomSheet(
                                CupertinoDatePickerMode.date);
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
                            Duration duration =
                                dateTime.difference(DateTime.now());
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.symmetric(vertical: 3),
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
            } else if (snapshot.hasError) {
              Utils.closeApiLoaderDialog(context);
              return NetworkErrorScreen(
                errorMessage: snapshot.error.toString(),
                tapToRetryFunction: () {
                  Utils.showApiLoaderDialog(context);
                  requestService(firstDayOfTheCurrentMonth,
                      lastDayOfTheCurrentMonth, selectedHeadacheName);
                },
              );
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
        true,
        selectedHeadacheName);
  }

  void setCompassAxesData(
      RecordsOverTimeCompassModel recordsOverTimeCompassModel) {
    int userDisabilityValue,
        userFrequencyValue,
        userDurationValue,
        userIntensityValue;
    int baseMaxValue = 10;
    List<Axes> compassAxesListData =
        recordsOverTimeCompassModel.recordsCompareCompassAxesResultModel.axes;
    print(recordsOverTimeCompassModel);
    var userFrequency = compassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.frequency,
        orElse: () => null);
    if (userFrequency != null) {
      userFrequencyValue =
          userFrequency.value.toInt() ~/ (userFrequency.max / baseMaxValue);
    }
    var userDuration = compassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userDuration != null) {
      userDurationValue =
          userDuration.value.toInt() ~/ (userDuration.max / baseMaxValue);
    }
    var userIntensity = compassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
      userIntensityValue =
          userIntensity.value.toInt() ~/ (userIntensity.max / baseMaxValue);
    }
    var userDisability = compassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
      userDisabilityValue = userDisability.value.toInt();
      userDisabilityValue =
          userDisability.value.toInt() ~/ (userDisability.max / baseMaxValue);
    }

    compassAxesData = [
      [
        userIntensityValue,
        userDurationValue,
        userDisabilityValue,
        userFrequencyValue
      ]
    ];
    setCompassDataScore(
        userIntensity, userDisability, userFrequency, userDuration);
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
    if (resultFromActionSheet != null) {
      selectedHeadacheName = resultFromActionSheet.toString();
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName);
      print(resultFromActionSheet);
    }
  }

  void _showApiLoaderDialog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String isViewTrendsClicked =
        sharedPreferences.getString(Constant.isViewTrendsClicked) ??
            Constant.blankString;
    String isSeeMoreClicked =
        sharedPreferences.getString(Constant.isSeeMoreClicked) ??
            Constant.blankString;
    if (isViewTrendsClicked.isEmpty && isSeeMoreClicked.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.showApiLoaderCallback(
            _recordsCompassScreenBloc.networkDataStream, () {
          _recordsCompassScreenBloc.enterSomeDummyDataToStreamController();
          requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
              selectedHeadacheName);
        });
      });
    }
  }

  void setCompassDataScore(Axes userIntensityValue, Axes userDisabilityValue,
      Axes userFrequencyValue, Axes userDurationValue) {
    var intensityScore =
        userIntensityValue.value.toInt() / userIntensityValue.max * 100.0;
    var disabilityScore =
        userDisabilityValue.value.toInt() / userDisabilityValue.max * 100.0;
    var frequencyScore =
        userFrequencyValue.value.toInt() / userFrequencyValue.max * 100.0;
    var durationScore =
        userDurationValue.value.toInt() / userDurationValue.max * 100.0;

    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    userScoreData = userTotalScore.toInt().toString();
    print(userScoreData);
  }

  void _updateCompassData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String isSeeMoreClicked =
        sharedPreferences.getString(Constant.isSeeMoreClicked) ??
            Constant.blankString;
    String isTrendsClicked =
        sharedPreferences.getString(Constant.isViewTrendsClicked) ??
            Constant.blankString;
    String updateOverTimeCompassData =
        sharedPreferences.getString(Constant.updateOverTimeCompassData) ??
            Constant.blankString;
    if (isSeeMoreClicked.isEmpty &&
        isTrendsClicked.isEmpty &&
        updateOverTimeCompassData == Constant.trueString) {
      sharedPreferences.remove(Constant.updateOverTimeCompassData);
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
      print('init state of overTime compass');
      _recordsCompassScreenBloc.initNetworkStreamController();
      _showApiLoaderDialog();
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName);
    }
  }
}
