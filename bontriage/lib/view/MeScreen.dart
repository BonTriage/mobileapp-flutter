import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ConsecutiveSelectedDateWidget.dart';
import 'DateWidget.dart';

class MeScreen extends StatefulWidget {
  final Future<dynamic> Function(String) navigateToOtherScreenCallback;

  MeScreen({this.navigateToOtherScreenCallback});

  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> with SingleTickerProviderStateMixin {
  DateTime _dateTime;
  List<Widget> currentWeekListData = [];
  List<bool> currentWeekConsData = [];
  List<TextSpan> textSpanList;
  AnimationController _animationController;
  bool _isOnBoardAssessmentInComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      vsync: this
    );

    _dateTime = DateTime.now();

    var _firstDayOfTheWeek =
        _dateTime.subtract(new Duration(days: _dateTime.weekday));

    currentWeekConsData.add(true);
    currentWeekConsData.add(false);
    currentWeekConsData.add(true);
    currentWeekConsData.add(true);
    currentWeekConsData.add(true);
    currentWeekConsData.add(false);
    currentWeekConsData.add(true);

    for (int i = 0; i < 7; i++) {
      if (currentWeekConsData[i]) {
        var j = i + 1;
        if (j < 7 && currentWeekConsData[i] == currentWeekConsData[j]) {
          currentWeekListData.add(ConsecutiveSelectedDateWidget(
              _firstDayOfTheWeek.day.toString(), 0));
        } else {
          currentWeekListData
              .add(DateWidget(_firstDayOfTheWeek.day.toString(), 0));
        }
      } else {
        currentWeekListData
            .add(DateWidget(_firstDayOfTheWeek.day.toString(), 0));
      }

      _firstDayOfTheWeek = DateTime(_firstDayOfTheWeek.year,
          _firstDayOfTheWeek.month, _firstDayOfTheWeek.day + 1);
    }

    print(currentWeekListData);
    print(currentWeekConsData);

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
                      onTap: () {
                        widget.navigateToOtherScreenCallback(Constant.welcomeStartAssessmentScreenRouter);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            Constant.onBoardingAssessmentIncomplete,
                            style: TextStyle(
                              color: Constant.bubbleChatTextView,
                              fontFamily: Constant.jostRegular,
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                            ),
                          ),
                          Text(
                            Constant.clickHereToFinish,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontFamily: Constant.jostMedium,
                                fontSize: 14
                            ),
                          ),
                          SizedBox(height: 10,),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xCC0E232F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      TabNavigatorRoutes.recordsRoot);
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Center(
                                    child: Text(
                                      'Su',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Constant.locationServiceGreen,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'M',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Tu',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'W',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Th',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'F',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Sa',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                              ]),
                              TableRow(children: currentWeekListData),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
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
                            'Good morning!\nWhat’s been\ngoing on today?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: Constant.jostMedium,
                                color: Constant.chatBubbleGreen),
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
                                      Constant.logDayScreenRouter);
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
                                          fontSize: 14,
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
                            padding:
                                EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            decoration: BoxDecoration(
                              color: Constant.chatBubbleGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Add a Headache',
                                style: TextStyle(
                                    color: Constant.bubbleChatTextView,
                                    fontSize: 14,
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

  void _checkForProfileIncomplete() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isProfileInComplete = sharedPreferences.getBool(Constant.isProfileInCompleteStatus);

    if(isProfileInComplete != null || isProfileInComplete) {
      setState(() {
        _isOnBoardAssessmentInComplete = isProfileInComplete;
        if (_isOnBoardAssessmentInComplete) {
          _animationController.forward();
        }
      });
    }
  }

  void _navigateUserToHeadacheLogScreen() async{
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if(userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);

    if(currentUserHeadacheModel == null)
      widget.navigateToOtherScreenCallback(Constant.headacheStartedScreenRouter);
    else
      widget.navigateToOtherScreenCallback(Constant.currentHeadacheProgressScreenRouter);
  }
}
