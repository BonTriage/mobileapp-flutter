import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpSecondStepCompassBloc.dart';
import 'package:mobile/models/CompassTutorialModel.dart';
import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CustomScrollBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChatBubble.dart';

class SignUpSecondStepCompassResult extends StatefulWidget {
  @override
  _SignUpSecondStepCompassResultState createState() =>
      _SignUpSecondStepCompassResultState();
}

class _SignUpSecondStepCompassResultState
    extends State<SignUpSecondStepCompassResult> with TickerProviderStateMixin {
  SignUpSecondStepCompassBloc _bloc;
  bool darkMode = false;
  double numberOfFeatures = 4;
  double sliderValue = 1;
  int _buttonPressedValue = 0;
  List<String> _bubbleTextViewList;
  bool isBackButtonHide = false;
  AnimationController _animationController;
  bool isEndOfOnBoard = false;
  bool isVolumeOn = false;
  bool _isButtonClicked = false;

  String userHeadacheName = "";
  String _userScoreData = '0';

  static String userHeadacheTextView;

  ScrollController _scrollController;

  int userFrequencyValue;
  int userDurationValue;
  int userIntensityValue;
  int userDisabilityValue;

  CompassTutorialModel _compassTutorialModel;

  var data = [
    [0, 0, 0, 0]
  ];

  @override
  void initState() {
    super.initState();

    _compassTutorialModel = CompassTutorialModel();
    _compassTutorialModel.isFromOnBoard = true;

    _bloc = SignUpSecondStepCompassBloc();
    _scrollController = ScrollController();
    getUserHeadacheName();
    _bubbleTextViewList = [
      Constant.welcomePersonalizedHeadacheFirstTextView,
      Constant.accurateClinicalImpression,
      Constant.moreDetailedHistory,
    ];

    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animationController.forward();
    if (!isEndOfOnBoard && isVolumeOn)
      TextToSpeechRecognition.speechToText(
          bubbleChatTextView[_buttonPressedValue]);
    //Save User Progress
    saveUserProgressInDataBase();
    setVolumeIcon();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Utils.showApiLoaderDialog(context, networkStream: _bloc.networkDataStream, tapToRetryFunction: () {
        _bloc.networkDataSink.add(Constant.loading);
        _bloc.fetchFirstLoggedScoreData();
      });
      _bloc.fetchFirstLoggedScoreData();
    });
  }

  @override
  void didUpdateWidget(SignUpSecondStepCompassResult oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  ///Method to toggle volume on or off
  void _toggleVolume() async {
    setState(() {
      isVolumeOn = !isVolumeOn;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constant.chatBubbleVolumeState, isVolumeOn);
    TextToSpeechRecognition.speechToText("");
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const ticks = [0, 2, 4, 6, 8, 10];
    if (!isEndOfOnBoard && isVolumeOn)
      TextToSpeechRecognition.speechToText(
          bubbleChatTextView[_buttonPressedValue]);
    var features = [
      "A",
      "B",
      "C",
      "D",
    ];

    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }

    try {
      _scrollController.animateTo(1, duration: Duration(milliseconds: 150), curve: Curves.easeIn);
      Future.delayed(Duration(milliseconds: 150), () {
        _scrollController.jumpTo(0);
      });
    } catch(e) {}

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          decoration: Constant.backgroundBoxDecoration,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: Constant.chatBubbleHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Utils.navigateToExitScreen(context);
                        },
                        child: Image(
                          image: AssetImage(Constant.closeIcon),
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(Constant.userAvatar),
                              width: 60.0,
                              height: 60.0,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: _toggleVolume,
                              child: AnimatedCrossFade(
                                duration: Duration(milliseconds: 250),
                                firstChild: Image(
                                  alignment: Alignment.topLeft,
                                  image: AssetImage(Constant.volumeOn),
                                  width: 20,
                                  height: 20,
                                ),
                                secondChild: Image(
                                  alignment: Alignment.topLeft,
                                  image: AssetImage(Constant.volumeOff),
                                  width: 20,
                                  height: 20,
                                ),
                                crossFadeState: isVolumeOn
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 17, top: 25),
                            child: ChatBubble(
                              painter:
                                  ChatBubblePainter(Constant.chatBubbleGreen),
                              child: AnimatedSize(
                                vsync: this,
                                duration: Duration(milliseconds: 300),
                                child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: FadeTransition(
                                      opacity: _animationController,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              Constant.chatBubbleMaxHeight,
                                        ),
                                        child: CustomScrollBar(
                                          controller: _scrollController,
                                          isAlwaysShown: false,
                                          child: SingleChildScrollView(
                                            controller: _scrollController,
                                            physics: BouncingScrollPhysics(),
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: RichText(
                                                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                                text: TextSpan(
                                                  children: _getBubbleTextSpans(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<dynamic>(
                    stream: _bloc.recordsCompassDataStream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        _getCompassAxesFromDatabase(snapshot.data);
                        return Expanded(
                          child: Center(
                            child: Row(
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
                                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                      style: TextStyle(
                                          color: Color(0xffafd794),
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Utils.showCompassTutorialDialog(context, 1, compassTutorialModel: _compassTutorialModel);
                                      },
                                      child: Text(
                                        "Intensity",
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                            color: Color(0xffafd794),
                                            fontSize: 14,
                                            fontFamily: Constant.jostMedium),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: 185,
                                        height: 185,
                                        child: Center(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                child: RadarChart.light(
                                                  ticks: ticks,
                                                  features: features,
                                                  data: data,
                                                  reverseAxis: false,
                                                  compassValue: 0,
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 36,
                                                  height: 36,
                                                  child: Center(
                                                    child: Text(
                                                      _userScoreData,
                                                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                                      style: TextStyle(
                                                          color: Color(0xff0E1712),
                                                          fontSize: 14,
                                                          fontFamily:
                                                          Constant.jostMedium),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffB8FFFF),
                                                    border: Border.all(
                                                        color: Color(0xffB8FFFF),
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
                                        Utils.showCompassTutorialDialog(context, 2, compassTutorialModel: _compassTutorialModel);
                                      },
                                      child: Text(
                                        "Disability",
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                            color: Color(0xffafd794),
                                            fontSize: 14,
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
                                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                      style: TextStyle(
                                          color: Color(0xffafd794),
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Center(
                            child: Row(
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
                                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                      style: TextStyle(
                                          color: Color(0xffafd794),
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Utils.showCompassTutorialDialog(context, 1, compassTutorialModel: _compassTutorialModel);
                                      },
                                      child: Text(
                                        "Intensity",
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                            color: Color(0xffafd794),
                                            fontSize: 14,
                                            fontFamily: Constant.jostMedium),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: 185,
                                        height: 185,
                                        child: Center(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                child: darkMode
                                                    ? RadarChart.dark(
                                                  ticks: ticks,
                                                  features: features,
                                                  data: data,
                                                  reverseAxis: false,
                                                  compassValue: 0,
                                                )
                                                    : RadarChart.light(
                                                  ticks: ticks,
                                                  features: features,
                                                  data: data,
                                                  reverseAxis: false,
                                                  compassValue: 0,
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 36,
                                                  height: 36,
                                                  child: Center(
                                                    child: Text(
                                                      '0',
                                                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                                      style: TextStyle(
                                                          color: Color(0xff0E1712),
                                                          fontSize: 14,
                                                          fontFamily:
                                                          Constant.jostMedium),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffB8FFFF),
                                                    border: Border.all(
                                                        color: Color(0xffB8FFFF),
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
                                        Utils.showCompassTutorialDialog(context, 2, compassTutorialModel: _compassTutorialModel);
                                      },
                                      child: Text(
                                        "Disability",
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                            color: Color(0xffafd794),
                                            fontSize: 14,
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
                                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                      style: TextStyle(
                                          color: Color(0xffafd794),
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constant.headacheCompassColor),
                          height: 11,
                          width: 11,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          userHeadacheName,
                          textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                          style: TextStyle(
                              color: Constant.locationServiceGreen,
                              fontSize: 11,
                              fontFamily: Constant.jostMedium),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          left: (isBackButtonHide)
                              ? 0
                              : (MediaQuery.of(context).size.width - 190),
                          duration: Duration(milliseconds: 250),
                          child: AnimatedOpacity(
                            opacity: (isBackButtonHide) ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 250),
                            child: BouncingWidget(
                              duration: Duration(milliseconds: 100),
                              scaleFactor: 1.5,
                              onPressed: _onBackPressed,
                              child: Container(
                                width: 130,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Color(0xffafd794),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    Constant.back,
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                    style: TextStyle(
                                      color: Constant.bubbleChatTextView,
                                      fontSize: 14,
                                      fontFamily: Constant.jostMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: BouncingWidget(
                            duration: Duration(milliseconds: 100),
                            scaleFactor: 1.5,
                            onPressed: () {
                              if(!_isButtonClicked) {
                                _isButtonClicked = true;
                                TextToSpeechRecognition.stopSpeech();
                                setState(() {
                                  if (_buttonPressedValue >= 0 &&
                                      _buttonPressedValue < 2) {
                                    _buttonPressedValue++;
                                    isBackButtonHide = true;
                                  } else {
                                    moveToNextScreen();
                                  }
                                });
                                Future.delayed(Duration(milliseconds: 350), () {
                                  _isButtonClicked = false;
                                });
                              }
                            },
                            child: Container(
                              width: 130,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Color(0xffafd794),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.next,
                                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                  style: TextStyle(
                                    color: Constant.bubbleChatTextView,
                                    fontSize: 14,
                                    fontFamily: Constant.jostMedium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        Constant.or,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 13,
                            fontFamily: Constant.jostMedium),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        Constant.viewDetailedReport,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            fontFamily: Constant.jostMedium),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _getBubbleTextSpans() {
    List<TextSpan> list = [];
    if (_buttonPressedValue == 0) {
      list.add(TextSpan(
          text: 'Based on what you entered, it looks like your ',
          style: TextStyle(
              height: 1.3,
              fontSize: 15,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView)));
      list.add(TextSpan(
          text: userHeadacheName,
          style: TextStyle(
              height: 1.3,
              fontSize: 13,
              fontFamily: Constant.jostBold,
              color: Constant.bubbleChatTextView)));
      list.add(TextSpan(
          text: ' could potentially be considered by doctors to be a ',
          style: TextStyle(
              height: 1.3,
              fontSize: 15,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView)));
      list.add(TextSpan(
          text: 'Cluster Headache.',
          style: TextStyle(
              height: 1.3,
              fontSize: 13,
              fontFamily: Constant.jostBold,
              color: Constant.bubbleChatTextView)));
      list.add(TextSpan(
          text:
              'We\'ll learn more about this as you log your headache and daily habits in the app.',
          style: TextStyle(
              height: 1.3,
              fontSize: 15,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView)));
    } else {
      list.add(TextSpan(
          text: _bubbleTextViewList[_buttonPressedValue],
          style: TextStyle(
              fontWeight: FontWeight.normal,
              height: 1.3,
              fontSize: 15,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView)));
    }

    return list;
  }

  static List<String> bubbleChatTextView = [
    userHeadacheTextView,
    Constant.accurateClinicalImpression,
    Constant.moreDetailedHistory,
  ];

  void saveUserProgressInDataBase() async {
    UserProgressDataModel userProgressDataModel = UserProgressDataModel();
    int userProgressDataCount = await SignUpOnBoardProviders.db
        .checkUserProgressDataAvailable(
            SignUpOnBoardProviders.TABLE_USER_PROGRESS);
    userProgressDataModel.userId = Constant.userID;
    userProgressDataModel.step = Constant.secondCompassEventStep;
    userProgressDataModel.userScreenPosition = 0;
    userProgressDataModel.questionTag = "";

    if (userProgressDataCount == 0) {
      SignUpOnBoardProviders.db.insertUserProgress(userProgressDataModel);
    } else {
      SignUpOnBoardProviders.db.updateUserProgress(userProgressDataModel);
    }
  }

  void moveToNextScreen() async {
    TextToSpeechRecognition.speechToText("");
    isEndOfOnBoard = true;
    Navigator.pushReplacementNamed(
        context, Constant.partTwoOnBoardMoveOnScreenRouter);
  }

  void setVolumeIcon() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isVolume = sharedPreferences.getBool(Constant.chatBubbleVolumeState);
    setState(() {
      if (isVolume == null || isVolume) {
        isVolumeOn = true;
      } else {
        isVolumeOn = false;
      }
    });
  }

  Future<bool> _onBackPressed() async {
    if(!_isButtonClicked) {
      _isButtonClicked = true;
      if (_buttonPressedValue == 0) {
        Future.delayed(Duration(milliseconds: 350), () {
          _isButtonClicked = false;
        });
        return true;
      } else {
        setState(() {
          if (_buttonPressedValue <= 2 && _buttonPressedValue > 1) {
            _buttonPressedValue--;
          } else {
            isBackButtonHide = false;
            _buttonPressedValue = 0;
          }
        });
        Future.delayed(Duration(milliseconds: 350), () {
          _isButtonClicked = false;
        });
        return false;
      }
    } else {
      return false;
    }
  }

  void getUserHeadacheName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userHeadacheName = sharedPreferences.get(Constant.userHeadacheName);
    userHeadacheTextView =
        'Based on what you entered, it looks like your $userHeadacheName could potentially be considered by doctors to be a Cluster Headache.We\'ll learn more about this as you log your headache and daily habits in the app';
  }

  void _getCompassAxesFromDatabase(RecordsCompassAxesResultModel recordsCompassAxesResultModel) async {
    _compassTutorialModel.currentDateTime = DateTime.tryParse(recordsCompassAxesResultModel.calendarEntryAt);
    int baseMaxValue = 10;

    var userFrequencyNormalisedValue;
    var userDurationNormalisedValue;
    var userDisabilityNormalisedValue;

    var userFrequency = recordsCompassAxesResultModel.signUpAxes.firstWhere(
            (intensityElement) =>
        intensityElement.name == 'Frequency',
        orElse: () => null);

    if (userFrequency != null) {
      userFrequencyValue = userFrequency.value.toInt();
      if(userFrequencyValue == 0){
        _compassTutorialModel.currentMonthFrequency = (31 - userFrequencyValue);
        userFrequencyNormalisedValue = (31 - userFrequencyValue) ~/ (31 / baseMaxValue);
        userFrequencyValue = 31 - userFrequencyValue;
      }else {
        _compassTutorialModel.currentMonthFrequency = (31 - userFrequencyValue);
        userFrequencyNormalisedValue = (31 - userFrequencyValue) ~/ (31 / baseMaxValue);
        userFrequencyValue = (31 - userFrequencyValue);
      }
    }
    var userDuration = recordsCompassAxesResultModel.signUpAxes.firstWhere(
            (intensityElement) =>
            intensityElement.name == 'Duration',
        orElse: () => null);
    if (userDuration != null) {
      int userMaxDurationValue;
      userDurationValue = userDuration.value.toInt();
      _compassTutorialModel.currentMonthDuration = userDurationValue;
      if (userDurationValue <= 1) {
        userMaxDurationValue = 1;
      } else if (userDurationValue > 1 && userDurationValue <= 24) {
        userMaxDurationValue = 24;
      } else if (userDurationValue > 24 && userDurationValue <= 72) {
        userMaxDurationValue = 72;
      }
      userDurationNormalisedValue =
          userDurationValue ~/ (userMaxDurationValue / baseMaxValue);
    }
    var userIntensity = recordsCompassAxesResultModel.signUpAxes.firstWhere(
            (intensityElement) =>
        intensityElement.name == 'Intensity',
        orElse: () => null);
    if (userIntensity != null) {
      userIntensityValue = userIntensity.value.toInt();
      _compassTutorialModel.currentMonthIntensity = userIntensityValue;
    }
    var userDisability = recordsCompassAxesResultModel.signUpAxes.firstWhere(
            (intensityElement) =>
        intensityElement.name == 'Disability',
        orElse: () => null);
    if (userDisability != null) {
      userDisabilityValue = userDisability.value.toInt();
      _compassTutorialModel.currentMonthDisability = userDisabilityValue;
      userDisabilityNormalisedValue = userDisabilityValue ~/ (4 / baseMaxValue);
    }
    print('Frequency???${userFrequency.value}Duration???${userDuration.value}Intensity???${userIntensity.value}Disability???${userDisability.value}');
      // Intensity,Duration,Disability,Frequency
      /*  1. 16  last 3 month  1
      2. 32 hour last 3 month
      3. 7 intensity
      4 . 2 disability*/
      data = [
        [
          userIntensityValue,
          userDurationNormalisedValue,
          userDisabilityNormalisedValue,
          userFrequencyNormalisedValue
        ]
      ];
      print('Second Step Compass Data: $data');
      setCompassDataScore(userIntensityValue, userDisabilityValue,
          userFrequencyValue, userDurationValue);
  }

  void setCompassDataScore(int userIntensityValue, int userDisabilityValue,
      int userFrequencyValue, int userDurationValue) {
    int userMaxDurationValue;
    var intensityScore = userIntensityValue / 10 * 100.0;
    var disabilityScore = userDisabilityValue.toInt() / 4 * 100.0;
    var frequencyScore = userFrequencyValue.toInt() / 31 * 100.0;
    if (userDurationValue <= 1) {
      userMaxDurationValue = 1;
    } else if (userDurationValue > 1 && userDurationValue <= 24) {
      userMaxDurationValue = 24;
    } else if (userDurationValue > 24 && userDurationValue <= 72) {
      userMaxDurationValue = 72;
    }
    var durationScore =
        userDurationValue.toInt() / userMaxDurationValue * 100.0;
    print('intensityScore???$intensityScore???disabilityScore???$disabilityScore???frequencyScore???$frequencyScore???durationScore???$durationScore');
    var userTotalScore =
        (intensityScore + disabilityScore + frequencyScore + durationScore) / 4;
    print('userTotalScore???$userTotalScore');
    _userScoreData = userTotalScore.round().toString();
    print('First Step User ScoreData$_userScoreData');
  }
}
