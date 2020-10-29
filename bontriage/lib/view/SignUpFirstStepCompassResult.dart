import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/SecondStepCompassResultTutorials.dart';

import 'ChatBubble.dart';

class SignUpFirstStepCompassResult extends StatefulWidget {
  @override
  _SignUpFirstStepCompassResultState createState() =>
      _SignUpFirstStepCompassResultState();
}

class _SignUpFirstStepCompassResultState
    extends State<SignUpFirstStepCompassResult> with TickerProviderStateMixin {
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
      Constant.welcomePersonalizedHeadacheSecondTextView,
      Constant.welcomePersonalizedHeadacheThirdTextView,
      Constant.welcomePersonalizedHeadacheFourthTextView,
      Constant.welcomePersonalizedHeadacheFifthTextView
    ];

    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animationController.forward();
    if (!isEndOfOnBoard && isVolumeOn)
      TextToSpeechRecognition.speechToText(
          _bubbleTextViewList[_buttonPressedValue]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SignUpFirstStepCompassResult oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  ///Method to toggle volume on or off
  void _toggleVolume() {
    isVolumeOn = !isVolumeOn;
    setState(() {
      TextToSpeechRecognition.pauseSpeechToText(isVolumeOn, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    const ticks = [7, 14, 21, 28, 35];
    if (!isEndOfOnBoard && isVolumeOn)
      TextToSpeechRecognition.speechToText(
          _bubbleTextViewList[_buttonPressedValue]);
    var features = [
      "A",
      "B",
      "C",
      "D",
    ];
    var data = [
      [9, 15, 7, 7]
    ];

    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage(Constant.closeIcon),
                    width: 26,
                    height: 26,
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
                        GestureDetector(
                          onTap: _toggleVolume,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
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
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 17, top: 25),
                        child: ChatBubble(
                          painter: ChatBubblePainter(Constant.chatBubbleGreen),
                          child: AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            vsync: this,
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
                                    child: Text(
                                      _bubbleTextViewList[_buttonPressedValue],
                                      style: TextStyle(
                                          height: 1.3,
                                          fontSize: 15,
                                          color: Constant.bubbleChatTextView,
                                          fontFamily: Constant.jostRegular),
                                    ),
                                  ),
                                ),
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
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: 3,
                        child: GestureDetector(
                          onTap: () {
                            _showTutorialDialog(3);
                          },
                          child: Text(
                            "Frequency",
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
                              _showTutorialDialog(1);
                            },
                            child: Text(
                              "Intensity",
                              style: TextStyle(
                                  color: Color(0xffafd794),
                                  fontSize: 14,
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
                                              data: data,
                                              reverseAxis: true,
                                              isPersonalizedHeadacheData: false,
                                            )
                                          : RadarChart.light(
                                              ticks: ticks,
                                              features: features,
                                              data: data,
                                              reverseAxis: true,
                                              isPersonalizedHeadacheData: false,
                                            ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        child: Center(
                                          child: Text(
                                            '70',
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
                              _showTutorialDialog(2);
                            },
                            child: Text(
                              "Disability",
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
                            _showTutorialDialog(4);
                          },
                          child: Text(
                            "Duration",
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
              ),
              SizedBox(
                height: 50,
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
                          if (_buttonPressedValue <= 4 &&
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
                              _buttonPressedValue < 4) {
                            _buttonPressedValue++;
                            isBackButtonHide = true;
                          } else {
                            isEndOfOnBoard = true;
                            TextToSpeechRecognition.pauseSpeechToText(true, "");
                            Navigator.pushReplacementNamed(context,
                                Constant.onBoardCreateAccountScreenRouter);
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTutorialDialog(int indexValue) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: SecondStepCompassResultTutorials(tutorialsIndex: indexValue),
        );
      },
    );
  }
}
