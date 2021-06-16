import 'dart:async';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/blocs/CalendarScreenBloc.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ConsecutiveSelectedDateWidget.dart';
import 'DateWidget.dart';
import 'package:flutter/foundation.dart';

class MeScreen extends StatefulWidget {
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Function(Stream, Function) showApiLoaderCallback;
  final Function(GlobalKey, GlobalKey) getButtonsGlobalKeyCallback;

  const MeScreen(
      {Key key, this.navigateToOtherScreenCallback, this.showApiLoaderCallback, this.getButtonsGlobalKeyCallback})
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
  int currentMonth;
  int currentYear;
  String monthName;
  String firstDayOfTheCurrentWeek;
  String lastDayOfTheCurrentWeek;
  CalendarScreenBloc _calendarScreenBloc;
  UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel;

  GlobalKey _logDayGlobalKey = GlobalKey();
  GlobalKey _addHeadacheGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _getUserProfileDetails();

    _calendarScreenBloc = CalendarScreenBloc();
    userLogHeadacheDataCalendarModel = UserLogHeadacheDataCalendarModel();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 350), reverseDuration: Duration(milliseconds: 0), vsync: this);

    _dateTime = DateTime.now();
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    monthName = Utils.getMonthName(currentMonth);

    var currentWeekDate = _dateTime.subtract(new Duration(days: _dateTime.weekday));
    debugPrint('CurrentWeekDate????$currentWeekDate');
    firstDayOfTheCurrentWeek = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentWeekDate.month, currentWeekDate.year, currentWeekDate.day);

    var currentWeekLastDate = currentWeekDate.add(Duration(days: 6));
    lastDayOfTheCurrentWeek = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentWeekLastDate.month, currentWeekLastDate.year, currentWeekLastDate.day);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.showApiLoaderCallback(_calendarScreenBloc.networkDataStream, () {
        _calendarScreenBloc.enterSomeDummyDataToStreamController();
        debugPrint('called service 2');
        requestService(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
      });
    });
    debugPrint('called service 1');
    requestService(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);

    textSpanList = [
      TextSpan(
        text:
            'When you\'re on the home screen of the app, you’ll be able to log your day by pressing the ',
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
        text: ' button and log your headache by clicking the ',
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

    _saveRecordTabBarPosition();
  }

  @override
  void didUpdateWidget(covariant MeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('in did update widget of me screen');
    _getCurrentIndexOfTabBar();
    _updateMeScreenData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('me screen build func');
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
                        _navigateToOtherScreen();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Consumer<CurrentUserHeadacheInfo>(
                            builder: (context, data, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    _getNotificationText(data.getCurrentUserHeadacheModel()),
                                    style: TextStyle(
                                        color: Constant.bubbleChatTextView,
                                        fontFamily: Constant.jostRegular,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    _getNotificationBottomText(data.getCurrentUserHeadacheModel()),
                                    style: TextStyle(
                                        color: Constant.bubbleChatTextView,
                                        fontFamily: Constant.jostMedium,
                                        fontSize: 14),
                                  ),
                                ],
                              );
                            },
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
                    Consumer<OnBoardAssessIncompleteInfo>(
                      builder: (context, data, child) {
                        return SizedBox(
                          height: data.isOnBoardAssessmentInComplete() ? 0 : 70,
                        );
                      },
                    ),
                    StreamBuilder<dynamic>(
                        stream: _calendarScreenBloc.calendarDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            userLogHeadacheDataCalendarModel = snapshot.data;
                            setUserWeekData(userLogHeadacheDataCalendarModel);
                            widget.getButtonsGlobalKeyCallback(_logDayGlobalKey, _addHeadacheGlobalKey);
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
                                          widget.navigateToOtherScreenCallback(TabNavigatorRoutes.calenderRoute,
                                              null);
                                          Utils.saveDataInSharedPreference(Constant.isSeeMoreClicked, 'true');
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
                          Consumer<UserNameInfo>(
                            builder: (context, data, child) {
                              return Text(
                                'Hey ${data.getUserName()}!',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: Constant.jostMedium,
                                    color: Constant.chatBubbleGreen),
                              );
                            },
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
                                key: _logDayGlobalKey,
                                onPressed: () async {
                                 await widget.navigateToOtherScreenCallback(
                                      Constant.logDayScreenRouter, null);
                                 _updateMeScreenData();
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
                          key: _addHeadacheGlobalKey,
                          onPressed: () {
                            var currentUserHeadacheInfo = Provider.of<CurrentUserHeadacheInfo>(context, listen: false);
                            if(currentUserHeadacheInfo.getCurrentUserHeadacheModel() != null && currentUserHeadacheInfo.getCurrentUserHeadacheModel().isOnGoing) {
                              _navigateToAddHeadacheScreen(currentUserHeadacheInfo.getCurrentUserHeadacheModel());
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
                              child: Consumer<CurrentUserHeadacheInfo>(
                                builder: (context, data, child) {
                                  return Text(
                                    _getHeadacheButtonText(data.getCurrentUserHeadacheModel()),
                                    style: TextStyle(
                                        color: Constant.bubbleChatTextView,
                                        fontSize: 15,
                                        fontFamily: Constant.jostMedium),
                                  );
                                },
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
    _calendarScreenBloc.dispose();
    super.dispose();
  }

  void _checkForProfileIncomplete() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isProfileInComplete = sharedPreferences.getBool(Constant.isProfileInCompleteStatus);

    var onBoardAssessmentInCompleteInfo = Provider.of<OnBoardAssessIncompleteInfo>(context, listen: false);

    if (!onBoardAssessmentInCompleteInfo.isOnBoardAssessmentInComplete() && (isProfileInComplete ?? false)) {

      onBoardAssessmentInCompleteInfo.updateOnBoardAssessmentInComplete(isProfileInComplete);

      if (onBoardAssessmentInCompleteInfo.isOnBoardAssessmentInComplete()) {
        _animationController.forward();
      }
    } else {
      onBoardAssessmentInCompleteInfo.updateOnBoardAssessmentInComplete(false);
      _animationController.reverse();
    }
  }

  void _navigateUserToHeadacheLogScreen() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if (userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db
          .getUserCurrentHeadacheData(userProfileInfoData.userId);

    if (currentUserHeadacheModel == null) {
      await widget.navigateToOtherScreenCallback(Constant.headacheStartedScreenRouter, null);
    }
    else {
      if(currentUserHeadacheModel.isOnGoing) {
        await widget.navigateToOtherScreenCallback(Constant.currentHeadacheProgressScreenRouter, null);
      } else
        await widget.navigateToOtherScreenCallback(Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    }
    _getUserCurrentHeadacheData();
    _updateMeScreenData();
  }

  void requestService(
      String firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek) async {
    var currentUserHeadacheInfo = Provider.of<CurrentUserHeadacheInfo>(context, listen: false);
    if(currentUserHeadacheInfo.getCurrentUserHeadacheModel() == null) {
      await _calendarScreenBloc.fetchUserOnGoingHeadache();
      var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

      if(userProfileInfoData != null) {
        await _getUserCurrentHeadacheData();
      }

      if(currentUserHeadacheInfo.getCurrentUserHeadacheModel() != null) {
        var onBoardAssessmentInCompleteInfo = Provider.of<OnBoardAssessIncompleteInfo>(context, listen: false);
        onBoardAssessmentInCompleteInfo.updateOnBoardAssessmentInComplete(true);
        _animationController.forward();
      }
    }
    await _calendarScreenBloc.fetchCalendarTriggersData(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
  }

  void setUserWeekData(
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel) {
    List<CurrentWeekConsData> currentWeekConsData = [];
    currentWeekListData = [];
    var _firstDayOfTheWeek =
        _dateTime.subtract(new Duration(days: _dateTime.weekday));
    filterSelectedLogAndHeadacheDayList(currentWeekConsData,
        userLogHeadacheDataCalendarModel, _firstDayOfTheWeek);

    for (int i = 0; i < 7; i++) {
      if (currentWeekConsData[i].widgetType == 0 || currentWeekConsData[i].widgetType == 1) {
        var j = i + 1;
        if (j < 7 &&
            (currentWeekConsData[i].widgetType == 0) &&
            (currentWeekConsData[j].widgetType == 0) && _checkForConsecutiveHeadacheId(currentWeekConsData[i], currentWeekConsData[j])) {
          currentWeekListData.add(ConsecutiveSelectedDateWidget(
              weekDateData: _firstDayOfTheWeek,
              calendarType: 0,
              calendarDateViewType: currentWeekConsData[i].widgetType,
              triggersListData: [],
              userMonthTriggersListData: []));
        } else {
          currentWeekListData.add(DateWidget(
              weekDateData: _firstDayOfTheWeek,
              calendarType: 0,
              calendarDateViewType: currentWeekConsData[i].widgetType,
              triggersListData: [],
              userMonthTriggersListData: []));
        }
      } else {
        currentWeekListData.add(DateWidget(
            weekDateData: _firstDayOfTheWeek,
            calendarType: 0,
            calendarDateViewType: currentWeekConsData[i].widgetType,
            triggersListData: [],
            userMonthTriggersListData: []));
      }

      _firstDayOfTheWeek = DateTime(_firstDayOfTheWeek.year,
          _firstDayOfTheWeek.month, _firstDayOfTheWeek.day + 1);
    }
  }

  // 0- Headache Data
  // 1- LogDay Data
  // 2- No Headache and No Log
  void filterSelectedLogAndHeadacheDayList(
      List<CurrentWeekConsData> currentWeekConsDataList,
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel,
      DateTime firstDayOfTheWeek) {
    for (int i = 0; i < 7; i++) {
      var userCalendarData = userLogHeadacheDataCalendarModel
          .addHeadacheListData
          .firstWhere((element) {
        if (int.parse(element.selectedDay) == firstDayOfTheWeek.day) {
          CurrentWeekConsData currentWeekConsData = CurrentWeekConsData();
          currentWeekConsData.widgetType = 0;
          currentWeekConsData.eventIdList = [];

          if(element.headacheListData != null) {
            element.headacheListData.forEach((headacheElement) {
              currentWeekConsData.eventIdList.add(headacheElement.id);
            });
          }
          currentWeekConsDataList.add(currentWeekConsData);
          return true;
        }
        return false;
      }, orElse: () => null);
      if (userCalendarData == null) {
        userLogHeadacheDataCalendarModel.addLogDayListData.firstWhere(
                (element) {
              if (int.parse(element.selectedDay) == firstDayOfTheWeek.day) {
                CurrentWeekConsData currentWeekConsData = CurrentWeekConsData();
                currentWeekConsData.widgetType = 1;
                currentWeekConsData.eventIdList = [];
                currentWeekConsDataList.add(currentWeekConsData);
                return true;
              }
              return false;
            }, orElse: () {
          CurrentWeekConsData currentWeekConsData = CurrentWeekConsData();
          currentWeekConsData.widgetType = 2;
          currentWeekConsData.eventIdList = [];
          currentWeekConsDataList.add(currentWeekConsData);
          return null;
        });
      }
      // currentWeekConsData.add(a);
      firstDayOfTheWeek = DateTime(firstDayOfTheWeek.year,
          firstDayOfTheWeek.month, firstDayOfTheWeek.day + 1);
    }
  }

  bool _checkForConsecutiveHeadacheId(CurrentWeekConsData currentWeekConsData1, CurrentWeekConsData currentWeekConsData2) {
    bool isSatisfied = false;

    for (int i = 0; i < currentWeekConsData1.eventIdList.length; i++) {
      int eventId = currentWeekConsData1.eventIdList[i];

      var eventIdElement = currentWeekConsData2.eventIdList.firstWhere((element) => element == eventId, orElse: () => null);

      if(eventIdElement != null) {
        isSatisfied = true;
        break;
      }
    }

    return isSatisfied;
  }

  void _getUserProfileDetails() async {
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    var userNameInfo = Provider.of<UserNameInfo>(context, listen: false);
    userNameInfo.updateUserName(userProfileInfoData.profileName);
  }

  Future<void> _getUserCurrentHeadacheData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);

    String isViewTrendsClicked = sharedPreferences.getString(Constant.isViewTrendsClicked) ?? Constant.blankString;

    if (isViewTrendsClicked == Constant.trueString) {
      await widget.navigateToOtherScreenCallback(TabNavigatorRoutes.trendsRoute, null);
    }

    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if(currentPositionOfTabBar == 0 && userProfileInfoData != null) {
      CurrentUserHeadacheModel currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);

      var currentUserHeadacheInfo = Provider.of<CurrentUserHeadacheInfo>(context, listen: false);
      currentUserHeadacheInfo.updateCurrentUserHeadacheModel(currentUserHeadacheModel);

      if(currentUserHeadacheInfo.getCurrentUserHeadacheModel() != null && currentUserHeadacheInfo.getCurrentUserHeadacheModel().isOnGoing) {
        var onBoardAssessmentInCompleteInfo = Provider.of<OnBoardAssessIncompleteInfo>(context, listen: false);
        onBoardAssessmentInCompleteInfo.updateOnBoardAssessmentInComplete(true);
        _animationController.forward();
      } else {
        _checkForProfileIncomplete();
      }
    }
  }

  ///This method is used to get text of notification banner
  String _getNotificationText(CurrentUserHeadacheModel currentUserHeadacheModel) {
    if(currentUserHeadacheModel != null && currentUserHeadacheModel.isOnGoing) {
      DateTime startDateTime = DateTime.tryParse(currentUserHeadacheModel.selectedDate);
      if(startDateTime == null) {
        return 'Headache log currently in progress.';
      } else {
        startDateTime = startDateTime;
        return 'Headache log currently in progress. Started on ${startDateTime
            .day} ${Utils.getShortMonthName(startDateTime.month)} at ${Utils
            .getTimeInAmPmFormat(startDateTime.hour, startDateTime.minute)}.';
      }
    }
    return Constant.onBoardingAssessmentIncomplete;
  }

  ///This method is used to get bottom text of notification banner
  String _getNotificationBottomText(CurrentUserHeadacheModel currentUserHeadacheModel) {
    if(currentUserHeadacheModel != null && currentUserHeadacheModel.isOnGoing) {
      return 'Click here to view.';
    }
    return Constant.clickHereToFinish;
  }

  void _navigateToAddHeadacheScreen(CurrentUserHeadacheModel currentUserHeadacheModel) async {
    DateTime currentDateTime = DateTime.now();
    DateTime endHeadacheDateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, currentDateTime.hour, currentDateTime.minute, 0, 0, 0);

    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);

    var currentUserHeadacheInfo = Provider.of<CurrentUserHeadacheInfo>(context, listen: false);
    currentUserHeadacheInfo.updateCurrentUserHeadacheModel(currentUserHeadacheModel);

    currentUserHeadacheModel.isOnGoing = false;
    currentUserHeadacheModel.selectedEndDate = Utils.getDateTimeInUtcFormat(endHeadacheDateTime);

    await widget.navigateToOtherScreenCallback(Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    _getUserCurrentHeadacheData();

    _updateMeScreenData();
  }

  String _getHeadacheButtonText(CurrentUserHeadacheModel currentUserHeadacheModel) {
    if(currentUserHeadacheModel != null && currentUserHeadacheModel.isOnGoing) {
      return Constant.endHeadache;
    }
    return 'Add Headache';
  }

  void _navigateToOtherScreen() async {
    var currentUserHeadacheInfo = Provider.of<CurrentUserHeadacheInfo>(context, listen: false);
    CurrentUserHeadacheModel currentUserHeadacheModel = currentUserHeadacheInfo.getCurrentUserHeadacheModel();

    if(currentUserHeadacheModel != null && currentUserHeadacheModel.isOnGoing) {
      await widget.navigateToOtherScreenCallback(Constant.currentHeadacheProgressScreenRouter, null);
    } else {
      await widget.navigateToOtherScreenCallback(Constant.welcomeStartAssessmentScreenRouter, null);
    }
    _getUserCurrentHeadacheData();
  }

  void _saveRecordTabBarPosition() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(Constant.recordTabNavigatorState, 0);
  }

  void _getCurrentIndexOfTabBar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    if(currentPositionOfTabBar == 0) {
      _getUserCurrentHeadacheData();
      _getUserProfileDetails();
    }
  }

  void _updateMeScreenData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    
    String updateMeScreenData = sharedPreferences.getString(Constant.updateMeScreenData);

    if(currentPositionOfTabBar == 0 && updateMeScreenData == Constant.trueString) {
      sharedPreferences.remove(Constant.updateMeScreenData);
      await _calendarScreenBloc.fetchCalendarTriggersData(firstDayOfTheCurrentWeek, lastDayOfTheCurrentWeek);
    }
  }
}

class OnBoardAssessIncompleteInfo with ChangeNotifier {
  bool _isOnBoardAssessmentInComplete = false;
  bool isOnBoardAssessmentInComplete() => _isOnBoardAssessmentInComplete;

  updateOnBoardAssessmentInComplete(bool isOnBoardAssessmentInComplete) {
    _isOnBoardAssessmentInComplete = isOnBoardAssessmentInComplete;
    notifyListeners();
  }
}

class CurrentUserHeadacheInfo with ChangeNotifier {
   CurrentUserHeadacheModel _currentUserHeadacheModel;

   CurrentUserHeadacheModel getCurrentUserHeadacheModel() => _currentUserHeadacheModel;

   updateCurrentUserHeadacheModel(CurrentUserHeadacheModel currentUserHeadacheModel) {
     _currentUserHeadacheModel = currentUserHeadacheModel;
     notifyListeners();
   }
}

class UserNameInfo with ChangeNotifier {
  String _userName = Constant.blankString;
  String getUserName() => _userName;

  updateUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }
}