import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';

import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/blocs/CalendarScreenBloc.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ConsecutiveSelectedDateWidget.dart';
import 'DateWidget.dart';

class MeScreen extends StatefulWidget {
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Function(Stream, Function) showApiLoaderCallback;

  const MeScreen(
      {Key key, this.navigateToOtherScreenCallback, this.showApiLoaderCallback})
      : super(key: key);

  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime;
  List<Widget> currentWeekListData = [];
  List<TextSpan> textSpanList;
  AnimationController _animationController;
  bool _isOnBoardAssessmentInComplete = false;
  int currentMonth;
  int currentYear;
  String monthName;
  String firstDayOfTheCurrentWeek;
  String lastDayOfTheCurrentWeek;
  CalendarScreenBloc _calendarScreenBloc;
  UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel;

  String userName = "";

  @override
  void initState() {
    super.initState();

    getUserProfileDetails();

    _calendarScreenBloc = CalendarScreenBloc();
    userLogHeadacheDataCalendarModel = UserLogHeadacheDataCalendarModel();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    _dateTime = DateTime.now();
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    monthName = Utils.getMonthName(currentMonth);

    var currentWeekDate =
        _dateTime.subtract(new Duration(days: _dateTime.weekday));
    firstDayOfTheCurrentWeek = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, currentWeekDate.day);
    lastDayOfTheCurrentWeek = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, currentWeekDate.day + 6);

    /*widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
      _calendarScreenBloc.enterSomeDummyDataToStreamController();
      requestService(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
    });*/
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /*Utils.showApiLoaderDialog(context,
          networkStream: _calendarScreenBloc.networkDataStream,
          tapToRetryFunction: () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        requestService(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
      });*/
      widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        print('called service 2');
        requestService(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
      });
    });
    print('called service 1');
    requestService(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);

    textSpanList = [
      TextSpan(
        text:
            'When you’re on the home screen of the app, you’ll be able to log your day by pressing the ',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen),
      ),
      TextSpan(
        text: 'Log Day',
        style: TextStyle(
          fontSize: 16,
          fontFamily: Constant.jostMedium,
          height: 1.3,
          color: Constant.chatBubbleGreen,
        ),
      ),
      TextSpan(
        text: ' button and log your headaches by clicking the ',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen),
      ),
      TextSpan(
        text: 'Add Headache',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            height: 1.3,
            color: Constant.chatBubbleGreen),
      ),
      TextSpan(
        text: ' button.',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen),
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkForProfileIncomplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizeTransition(
              sizeFactor: _animationController,
              child: Container(
                color: Constant.addCustomNotificationTextColor,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.navigateToOtherScreenCallback(
                            Constant.welcomeStartAssessmentScreenRouter, null);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            Constant.onBoardingAssessmentIncomplete,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontFamily: Constant.jostRegular,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          Text(
                            Constant.clickHereToFinish,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontFamily: Constant.jostMedium,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: _isOnBoardAssessmentInComplete ? 0 : 70,
                    ),
                    StreamBuilder<dynamic>(
                        stream: _calendarScreenBloc.calendarDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            userLogHeadacheDataCalendarModel = snapshot.data;
                            setUserWeekData(userLogHeadacheDataCalendarModel);
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xCC0E232F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'THIS WEEK:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Constant.chatBubbleGreen,
                                            fontFamily: Constant.jostMedium),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          widget.navigateToOtherScreenCallback(
                                              TabNavigatorRoutes.recordsRoot,
                                              null);
                                        },
                                        child: Text(
                                          'SEE MORE >',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Constant.chatBubbleGreen,
                                              fontFamily: Constant.jostMedium),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        Center(
                                          child: Text(
                                            'Su',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'M',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Tu',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'W',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Th',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'F',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Sa',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant
                                                    .locationServiceGreen,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: currentWeekListData),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              height: 100,
                            );
                          }
                        }),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 65, vertical: 40),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: <Color>[
                                Color(0xff0E4C47),
                                Color(0x910E4C47),
                              ]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constant.chatBubbleGreen,
                            width: 2,
                          )),
                      child: Column(
                        children: [
                          Text(
                            'Hey ''$userName''!',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: Constant.jostMedium,
                                color: Constant.chatBubbleGreen),
                          ),
                          Text(
                              '\nWhat’s been\ngoing on today?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: Constant.jostMedium,
                                  color: Constant.chatBubbleGreen)
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BouncingWidget(
                                onPressed: () {
                                  widget.navigateToOtherScreenCallback(
                                      Constant.logDayScreenRouter, null);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Constant.chatBubbleGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Log Day',
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
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {
                            _navigateUserToHeadacheLogScreen();
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
                                'Add a Headache',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkForProfileIncomplete() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isProfileInComplete =
        sharedPreferences.getBool(Constant.isProfileInCompleteStatus);

    if (isProfileInComplete != null || isProfileInComplete) {
      setState(() {
        _isOnBoardAssessmentInComplete = isProfileInComplete;
        if (_isOnBoardAssessmentInComplete) {
          _animationController.forward();
        }
      });
    }
  }

  void _navigateUserToHeadacheLogScreen() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if (userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db
          .getUserCurrentHeadacheData(userProfileInfoData.userId);

    if (currentUserHeadacheModel == null)
      widget.navigateToOtherScreenCallback(
          Constant.headacheStartedScreenRouter, null);
    else {
      if(currentUserHeadacheModel.isOnGoing) {
        widget.navigateToOtherScreenCallback(
            Constant.currentHeadacheProgressScreenRouter, null);
      } else
        widget.navigateToOtherScreenCallback(Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    }
  }

  void requestService(
      String firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek) async {
    await _calendarScreenBloc.fetchCalendarTriggersData(
        firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
  }

  void setUserWeekData(
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel) {
    List<int> currentWeekConsData = [];
    currentWeekListData = [];
    var _firstDayOfTheWeek =
        _dateTime.subtract(new Duration(days: _dateTime.weekday));
    filterSelectedLogAndHeadacheDayList(currentWeekConsData,
        userLogHeadacheDataCalendarModel, _firstDayOfTheWeek);

    for (int i = 0; i < 7; i++) {
      if (currentWeekConsData[i] == 0 || currentWeekConsData[i] == 1) {
        var j = i + 1;
        if (j < 7 &&
            (currentWeekConsData[i] == 0 || currentWeekConsData[i] == 1) &&
            (currentWeekConsData[j] == 0 || currentWeekConsData[j] == 1)) {
          currentWeekListData.add(ConsecutiveSelectedDateWidget(
              weekDateData: _firstDayOfTheWeek,
              calendarType: 0,
              calendarDateViewType: currentWeekConsData[i],
              triggersListData: [],
              userMonthTriggersListData: []));
        } else {
          currentWeekListData.add(DateWidget(
              weekDateData: _firstDayOfTheWeek,
              calendarType: 0,
              calendarDateViewType: currentWeekConsData[i],
              triggersListData: [],
              userMonthTriggersListData: []));
        }
      } else {
        currentWeekListData.add(DateWidget(
            weekDateData: _firstDayOfTheWeek,
            calendarType: 0,
            calendarDateViewType: currentWeekConsData[i],
            triggersListData: [],
            userMonthTriggersListData: []));
      }

      _firstDayOfTheWeek = DateTime(_firstDayOfTheWeek.year,
          _firstDayOfTheWeek.month, _firstDayOfTheWeek.day + 1);
    }

    print(currentWeekListData);
  }

  // 0- Headache Data
  // 1- LogDay Data
  // 2- No Headache and No Log
  void filterSelectedLogAndHeadacheDayList(
      List<int> currentWeekConsData,
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel,
      DateTime firstDayOfTheWeek) {
    for (int i = 0; i < 7; i++) {
      var userCalendarData = userLogHeadacheDataCalendarModel
          .addHeadacheListData
          .firstWhere((element) {
        if (int.parse(element.selectedDay) == firstDayOfTheWeek.day) {
          currentWeekConsData.add(0);
          return true;
        }
        return false;
      }, orElse: () => null);
      if (userCalendarData == null) {
        userLogHeadacheDataCalendarModel.addLogDayListData.firstWhere(
            (element) {
          if (int.parse(element.selectedDay) == firstDayOfTheWeek.day) {
            currentWeekConsData.add(1);
            return true;
          }
          return false;
        }, orElse: () {
          currentWeekConsData.add(2);
          return null;
        });
      }
      // currentWeekConsData.add(a);
      firstDayOfTheWeek = DateTime(firstDayOfTheWeek.year,
          firstDayOfTheWeek.month, firstDayOfTheWeek.day + 1);
    }
    print(currentWeekConsData);
  }

  void getUserProfileDetails() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    setState(() {
      userName = userProfileInfoData.firstName;
    });

}
}
