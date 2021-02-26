import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsCompassScreenBloc.dart';
import 'package:mobile/models/CompassTutorialModel.dart';
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
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;

  const OverTimeCompassScreen(
      {Key key,
      this.openActionSheetCallback,
      this.showApiLoaderCallback,
      this.navigateToOtherScreenCallback})
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

  int userCurrentMonthScoreData;
  int userPreviousMonthScoreData = 0;
  String headacheDownOrUp = '';
  String increaseOrDecrease = '';

  CompassTutorialModel _compassTutorialModel;

  List<TextSpan> _getBubbleTextSpans() {
    List<TextSpan> list = [];
    list.add(TextSpan(
        text: 'Your Headache Score for $monthName was ',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));
    list.add(TextSpan(
        text: userCurrentMonthScoreData.toString(),
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.addCustomNotificationTextColor)));
    list.add(TextSpan(
        text: ' $headacheDownOrUp from ',
        style: TextStyle(
            height: 1.3,
            fontSize: 14,
            fontFamily: Constant.jostRegular,
            color: Constant.chatBubbleGreen)));
    list.add(TextSpan(
        text: userPreviousMonthScoreData.toString(),
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
        text: '$increaseOrDecrease in Frequency.',
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

    _compassTutorialModel = CompassTutorialModel();

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
    _compassTutorialModel.currentDateTime = _dateTime;
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
              if (snapshot.data == Constant.noHeadacheData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 150,),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Utils.showCompassTutorialDialog(context, 0, compassTutorialModel: _compassTutorialModel);
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
                                      color: Constant.chatBubbleGreen,
                                      width: 1)),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Utils.showCompassTutorialDialog(context, 0, compassTutorialModel: _compassTutorialModel);
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
                                    Utils.showCompassTutorialDialog(context, 3, compassTutorialModel: _compassTutorialModel);
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
                                      Utils.showCompassTutorialDialog(
                                          context, 1, compassTutorialModel: _compassTutorialModel);
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
                                                      reverseAxis: false,
                                                      compassValue: 1,
                                                    )
                                                  : RadarChart.light(
                                                      ticks: ticks,
                                                      features: features,
                                                      data: compassAxesData,
                                                      outlineColor: Constant
                                                          .chatBubbleGreen
                                                          .withOpacity(0.5),
                                                      reverseAxis: false,
                                                      compassValue: 1,
                                                    ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                child: Center(
                                                  child: Text(
                                                    userCurrentMonthScoreData !=
                                                            null
                                                        ? userCurrentMonthScoreData.toString()
                                                        : '0',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff0E1712),
                                                        fontSize: 14,
                                                        fontFamily: Constant
                                                            .jostMedium),
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
                                      Utils.showCompassTutorialDialog(
                                          context, 2, compassTutorialModel: _compassTutorialModel);
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
                                    Utils.showCompassTutorialDialog(context, 4, compassTutorialModel: _compassTutorialModel);
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
              }
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
    List<Axes> currentMonthCompassAxesListData = recordsOverTimeCompassModel
        .recordsCompareCompassAxesResultModel.currentAxes;
    print(recordsOverTimeCompassModel);
    var userFrequency = currentMonthCompassAxesListData.firstWhere(
        (frequencyElement) => frequencyElement.name == Constant.frequency,
        orElse: () => null);
    if (userFrequency != null) {
     // userFrequencyValue = userFrequency.value ~/ (userFrequency.max / baseMaxValue);
      _compassTutorialModel.currentMonthFrequency = userFrequency.total.round();
      userFrequencyValue = (userFrequency.value * baseMaxValue).round();
      if(userFrequencyValue > 10){
        userFrequencyValue = 10;
      }else{
        userFrequencyValue = userFrequencyValue;
      }
    } else {
      userFrequencyValue = 0;
      _compassTutorialModel.currentMonthFrequency = 0;
    }
    var userDuration = currentMonthCompassAxesListData.firstWhere(
        (durationElement) => durationElement.name == Constant.duration,
        orElse: () => null);
    if (userDuration != null) {
    // userDurationValue = userDuration.value ~/ (userDuration.max / baseMaxValue);
      userDurationValue = (userDuration.value *baseMaxValue).round() ;
      if(userDurationValue > 10){
        userDurationValue = 10;
      }else{
        userDurationValue = userDurationValue;

      }
      _compassTutorialModel.currentMonthDuration = (userDuration.total).round();

    } else {
      userDurationValue = 0;
      _compassTutorialModel.currentMonthDuration = 0;
    }
    var userIntensity = currentMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
     // userIntensityValue = userIntensity.value ~/ (userIntensity.max / baseMaxValue);
      _compassTutorialModel.currentMonthIntensity = userIntensity.value.round();
      userIntensityValue = (userIntensity.value * baseMaxValue) ~/ userIntensity.max;
    } else {
      userIntensityValue = 0;
      _compassTutorialModel.currentMonthIntensity = 0;
    }
    var userDisability = currentMonthCompassAxesListData.firstWhere(
        (disabilityElement) => disabilityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
     // userDisabilityValue =  userDisability.value ~/ (userDisability.max / baseMaxValue);
      _compassTutorialModel.currentMonthDisability = userDisability.value.round();
      userDisabilityValue =  (userDisability.value * baseMaxValue)~/ userDisability.max;
      if(userDisabilityValue >10){
        userDisabilityValue = 10;
      }else{
        userDisabilityValue = userDisabilityValue;
      }
    } else {
      userDisabilityValue = 0;
    }

    compassAxesData = [
      [
        userIntensityValue,
        userDurationValue,
        userDisabilityValue,
        userFrequencyValue
      ]
    ];

    if (currentMonthCompassAxesListData.length > 0) {
      setCurrentMonthCompassDataScore(
          userIntensity, userDisability, userFrequency, userDuration);
    } else {
      userCurrentMonthScoreData = 0;
    }

    setPreviousMonthAxesData(recordsOverTimeCompassModel);
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
      _recordsCompassScreenBloc.initNetworkStreamController();
      print('show api loader 12');
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
        print('show api loader 5');
        widget.showApiLoaderCallback(
            _recordsCompassScreenBloc.networkDataStream, () {
          _recordsCompassScreenBloc.enterSomeDummyDataToStreamController();
          requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
              selectedHeadacheName);
        });
      });
    }
  }

  void setCurrentMonthCompassDataScore(
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
      durationScore =
          userDurationValue.value / userDurationValue.max * 100.0;
    } else {
      durationScore = 0;
    }

    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    userCurrentMonthScoreData = userTotalScore.round();
    print(userCurrentMonthScoreData);
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

  void navigateToHeadacheStartScreen() async {
    await widget.navigateToOtherScreenCallback(
        Constant.headacheStartedScreenRouter, null);
  }

  void setPreviousMonthAxesData(
      RecordsOverTimeCompassModel recordsOverTimeCompassModel) {
    int userDisabilityValue,
        userFrequencyValue,
        userDurationValue,
        userIntensityValue;

    int baseMaxValue = 10;
    List<Axes> previousMonthCompassAxesListData = recordsOverTimeCompassModel
        .recordsCompareCompassAxesResultModel.previousAxes;
    print(recordsOverTimeCompassModel);
    var userFrequency = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.frequency,
        orElse: () => null);
    if (userFrequency != null) {
      _compassTutorialModel.previousMonthFrequency = userFrequency.total.round();
      userFrequencyValue =
          userFrequency.value ~/ (userFrequency.max / baseMaxValue);
    } else {
      userFrequencyValue = 0;
    }
    var userDuration = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userDuration != null) {
      _compassTutorialModel.previousMonthDuration = (userDuration.total).round();
      userDurationValue =
          userDuration.value ~/ (userDuration.max / baseMaxValue);
    } else {
      userDurationValue = 0;
    }
    var userIntensity = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
      _compassTutorialModel.previousMonthIntensity = userIntensity.value.round();
      userIntensityValue =
          userIntensity.value ~/ (userIntensity.max / baseMaxValue);
    } else {
      userIntensityValue = 0;
    }
    var userDisability = previousMonthCompassAxesListData.firstWhere(
        (intensityElement) => intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
      _compassTutorialModel.previousMonthDisability = userDisability.value.round();
      userDisabilityValue =
          userDisability.value ~/ (userDisability.max / baseMaxValue);
    } else {
      userDisabilityValue = 0;
    }
    if (previousMonthCompassAxesListData.length > 0) {
      setPreviousMonthCompassDataScore(
          userIntensity, userDisability, userFrequency, userDuration);
    } else {
      userPreviousMonthScoreData = 0;
    }
  }

  void setPreviousMonthCompassDataScore(
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
      durationScore =
          userDurationValue.value / userDurationValue.max * 100.0;
    } else {
      durationScore = 0;
    }

    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    userPreviousMonthScoreData = userTotalScore.round();
    print(userPreviousMonthScoreData);

    if (userPreviousMonthScoreData > userCurrentMonthScoreData) {
      headacheDownOrUp = 'down';
      increaseOrDecrease = 'decrease';
    } else {
      headacheDownOrUp = 'up';
      increaseOrDecrease = 'increase';
    }
  }
}
