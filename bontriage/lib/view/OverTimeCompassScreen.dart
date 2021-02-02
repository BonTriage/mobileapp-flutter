import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsCompassScreenBloc.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/NetworkErrorScreen.dart';
import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'DateTimePicker.dart';

class OverTimeCompassScreen extends StatefulWidget {
  final Future<dynamic> Function(String) openActionSheetCallback;

  const OverTimeCompassScreen({Key key, this.openActionSheetCallback}) : super(key: key);
  @override
  _OverTimeCompassScreenState createState() => _OverTimeCompassScreenState();
}

class _OverTimeCompassScreenState extends State<OverTimeCompassScreen> with AutomaticKeepAliveClientMixin {
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
     ticks = [7, 14, 21, 28, 35];

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
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
  }

  @override
  void didUpdateWidget(covariant OverTimeCompassScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _openHeadacheTypeActionSheet();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 30),
                decoration: BoxDecoration(
                  color: Constant.compassMyHeadacheTextColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'My headache',
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
                        onTap: (){
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
                StreamBuilder<Object>(
                    stream: _recordsCompassScreenBloc.recordsCompassDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        setCompassAxesData(snapshot.data);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RotatedBox(
                              quarterTurns: 3,
                              child: GestureDetector(
                                onTap: (){
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
                                  onTap: (){
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
                                                  '60',
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
                                  onTap: (){
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
                                onTap: (){
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
                        );
                      }else if (snapshot.hasError) {
                        Utils.closeApiLoaderDialog(context);
                        return NetworkErrorScreen(
                          errorMessage: snapshot.error.toString(),
                          tapToRetryFunction: () {
                            Utils.showApiLoaderDialog(context);
                            requestService(firstDayOfTheCurrentMonth,
                                lastDayOfTheCurrentMonth);
                          },
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                "Frequency",
                                style: TextStyle(
                                    color: Color(0xffafd794),
                                    fontSize: 16,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Intensity",
                                  style: TextStyle(
                                      color: Color(0xffafd794),
                                      fontSize: 16,
                                      fontFamily: Constant.jostMedium),
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
                                                  '60',
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

                                Text(
                                  "Disability",
                                  style: TextStyle(
                                      color: Color(0xffafd794),
                                      fontSize: 16,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ],
                            ),
                            RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                "Duration",
                                style: TextStyle(
                                    color: Color(0xffafd794),
                                    fontSize: 16,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ],
                        );
                      }
                  }

                ),
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
      ),
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
        builder: (context) =>
            DateTimePicker(
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
            requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
          });
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth);
    });
  }

//http://34.222.200.187:8080/mobileapi/v0/compass/calender?end_date=2021-01-31T18:30:00Z&start_date=2021-01-01T18:30:00Z&user_id=4609&headache_name=Headache1

  void requestService(String firstDayOfTheCurrentMonth,
      String lastDayOfTheCurrentMonth) async {
    await _recordsCompassScreenBloc.fetchOverTimeCompassAxesResult(
        '2021-01-01T18:30:00Z', '2021-01-31T18:30:00Z', 'Headache1');
  }

  void setCompassAxesData(
      RecordsCompassAxesResultModel recordsCompassAxesResultModel) {
    int userDisabilityValue, userFrequencyValue, userDurationValue,
        userIntensityValue;
    List<Axes> compassAxesListData = recordsCompassAxesResultModel.axes;
    print(recordsCompassAxesResultModel);
    var userFrequency = compassAxesListData.firstWhere(
            (intensityElement) =>
        intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userFrequency != null) {
      userFrequencyValue = userFrequency.value.toInt();
    }
    var userDuration = compassAxesListData.firstWhere(
            (intensityElement) =>
        intensityElement.name == Constant.duration,
        orElse: () => null);
    if (userDuration != null) {
      userDurationValue = userDuration.value.toInt();
    }
    var userIntensity = compassAxesListData.firstWhere(
            (intensityElement) =>
        intensityElement.name == Constant.intensity,
        orElse: () => null);
    if (userIntensity != null) {
      userIntensityValue = userIntensity.value.toInt();
    }
    var userDisability = compassAxesListData.firstWhere(
            (intensityElement) =>
        intensityElement.name == Constant.disability,
        orElse: () => null);
    if (userDisability != null) {
      userDisabilityValue = userDisability.value.toInt();
    }

    compassAxesData = [[userIntensityValue,userDurationValue,userDisabilityValue,userFrequencyValue]];

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _openHeadacheTypeActionSheet() async {
    var resultFromActionSheet = await widget.openActionSheetCallback(Constant.compassHeadacheTypeActionSheet);
    print(resultFromActionSheet);
  }

}
