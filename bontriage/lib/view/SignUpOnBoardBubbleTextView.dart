import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class SignUpOnBoardBubbleTextView extends StatefulWidget  {
  @override
  _StateSignUpOnBoardBubbleTextView createState() =>
      _StateSignUpOnBoardBubbleTextView();
}

class _StateSignUpOnBoardBubbleTextView
    extends State<SignUpOnBoardBubbleTextView> {
  List<List<TextSpan>> _questionList = [
    [
      TextSpan(
          text: 'Welcome to',
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView)),
      TextSpan(
          text: ' MigraineMentor! ',
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostMedium,
              color: Constant.splashMigraineMentorTextColor)),
      TextSpan(
          text: Constant.welcomeMigraineMentorTextView,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
      TextSpan(
          text: 'MigraineMentor! ',
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostMedium,
              color: Constant.splashMigraineMentorTextColor)),
      TextSpan(
          text: Constant.migraineMentorHelpTextView,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
      TextSpan(
          text: Constant.letsStarted,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ]
  ];

  List<TextSpan> bubbleMigraineMentorTextView = [
    TextSpan(
        text: 'Welcome to',
        style: TextStyle(
            height: 1.3,
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            color: Constant.bubbleChatTextView)),
    TextSpan(
        text: 'MigraineMentor! ',
        style: TextStyle(
            height: 1.3,
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            color: Constant.splashMigraineMentorTextColor)),
    TextSpan(
        text: Constant.welcomeMigraineMentorTextView,
        style: TextStyle(
            height: 1.3,
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            color: Constant.bubbleChatTextView))
  ];

  static List<String> bubbleChatTextView = [
    Constant.welcomeMigraineMentorBubbleTextView,
    Constant.answeringTheNextBubbleTextView,
    Constant.letsStarted
  ];

  int _currentIndex = 0;

  Future<bool> _onBackPressed() async {
    if (_currentIndex == 0) {
      return true;
    } else {
      setState(() {
        _currentIndex--;
      });
      return false;
    }
  }

  @override
  void initState() {
        super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: OnBoardInformationScreen(
          isSpannable: true,
          chatText: bubbleChatTextView[_currentIndex],
          bubbleChatTextSpanList: _questionList[_currentIndex],
          isShowNextButton: _currentIndex != (_questionList.length - 1),
          nextButtonFunction: () {
            setState(() {
              _currentIndex++;
            });
          },
          bottomButtonText: Constant.startAssessment,
          bottomButtonFunction: () {
            Navigator.pushReplacementNamed(
                context, Constant.signUpOnBoardProfileQuestionRouter);
          },
          isShowSecondBottomButton: false,
          closeButtonFunction: () {
            Utils.navigateToExitScreen(context);
          },
        ),
      ),
    );
  }
}
