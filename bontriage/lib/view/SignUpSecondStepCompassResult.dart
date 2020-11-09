import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChatBubble.dart';

class SignUpSecondStepCompassResult extends StatefulWidget {
  @override
  _SignUpSecondStepCompassResultState createState() =>
      _SignUpSecondStepCompassResultState();
}

class _SignUpSecondStepCompassResultState
    extends State<SignUpSecondStepCompassResult> with TickerProviderStateMixin {
  bool darkMode = false;
  double numberOfFeatures = 4;
  double sliderValue = 1;
  int _buttonPressedValue = 0;
  List<String> _bubbleTextViewList;
  bool isBackButtonHide = false;
  AnimationController _animationController;
  bool isEndOfOnBoard = false;
  bool isVolumeOn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }

  @override
  void didUpdateWidget(SignUpSecondStepCompassResult oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
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
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const ticks = [7, 14, 21, 28, 35];
    if (!isEndOfOnBoard && isVolumeOn)
      TextToSpeechRecognition.speechToText(
          bubbleChatTextView[_buttonPressedValue]);
    var features = [
      "A",
      "B",
      "C",
      "D",
    ];
    var data = [
      [14, 15, 7, 7]
    ];

    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 20, horizontal: Constant.chatBubbleHorizontalPadding),
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
                                        maxHeight: Constant.chatBubbleMaxHeight,
                                      ),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: RichText(
                                          text: TextSpan(
                                            children: _getBubbleTextSpans(),
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
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "Frequency",
                            style: TextStyle(
                                color: Color(0xffafd794),
                                fontSize: 14,
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
                                  fontSize: 14,
                                  fontFamily: Constant.jostMedium),
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
                                                reverseAxis: true,
                                                isPersonalizedHeadacheData:
                                                    false,
                                              )
                                            : RadarChart.light(
                                                ticks: ticks,
                                                features: features,
                                                data: data,
                                                reverseAxis: true,
                                                isPersonalizedHeadacheData:
                                                    false,
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
                            Text(
                              "Disability",
                              style: TextStyle(
                                  color: Color(0xffafd794),
                                  fontSize: 14,
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
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        'Red Wine Headache',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BouncingWidget(
                        duration: Duration(milliseconds: 100),
                        scaleFactor: 1.5,
                        onPressed: () {
                          setState(() {
                            if (_buttonPressedValue <= 2 &&
                                _buttonPressedValue > 1) {
                              _buttonPressedValue--;
                            } else {
                              isBackButtonHide = false;
                              _buttonPressedValue = 0;
                            }
                          });
                        },
                        child: Visibility(
                          visible: isBackButtonHide,
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
                                style: TextStyle(
                                    color: Constant.bubbleChatTextView,
                                    fontSize: 15,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ),
                        ),
                      ),
                      BouncingWidget(
                        duration: Duration(milliseconds: 100),
                        scaleFactor: 1.5,
                        onPressed: () {
                          setState(() {
                            if (_buttonPressedValue >= 0 &&
                                _buttonPressedValue < 2) {
                              _buttonPressedValue++;
                              isBackButtonHide = true;
                            } else {
                              moveToNextScreen();
                            }
                          });
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
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Center(
                    child: Text(
                      Constant.or,
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
          text: 'Red Wine Headache ',
          style: TextStyle(
              height: 1.3,
              fontSize: 13,
              fontFamily: Constant.jostBold,
              color: Constant.bubbleChatTextView)));
      list.add(TextSpan(
          text: 'could potentially be considered by doctors to be a ',
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
    Constant.welcomePersonalizedHeadacheSecondStepFirstTextView,
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
}
