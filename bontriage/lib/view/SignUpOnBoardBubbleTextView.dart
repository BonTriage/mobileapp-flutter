import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class SignUpOnBoardBubbleTextView extends StatefulWidget {
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
          text: Constant.answeringTheNext,
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

  int _currentIndex = 0;

  void _onBackPressed() {
    setState(() {
      if (_currentIndex != 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
          isSpannable: true,
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
                context, Constant.signUpOnBoardHeadacheQuestionRouter);
          },
          isShowSecondBottomButton: false),
    );
  }
}
