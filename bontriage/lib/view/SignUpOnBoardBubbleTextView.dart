import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/PhotoHero.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

import 'ChatBubbleLeftPointed.dart';

class SignUpOnBoardBubbleTextView extends StatefulWidget {
  @override
  _StateSignUpOnBoardBubbleTextView createState() =>
      _StateSignUpOnBoardBubbleTextView();
}

class _StateSignUpOnBoardBubbleTextView
    extends State<SignUpOnBoardBubbleTextView> {
  List<String> _questionList = [
    Constant.welcomeMigraineMentorTextView,
    Constant.answeringTheNext,
    Constant.letsStarted
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
          isShowNextButton: _currentIndex != (_questionList.length - 1),
          chatText: _questionList[_currentIndex],
          nextButtonFunction: () {
            setState(() {
              _currentIndex++;
            });
          },
          bottomButtonText: Constant.startAssessment,
          bottomButtonFunction: () {
            Navigator.pushReplacementNamed(context,
                Constant.signUpOnBoardHeadacheQuestionRouter);
          },
          isShowSecondBottomButton: false
      ),
    );
  }
}
