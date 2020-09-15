import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PrePartTwoOnBoardScreen extends StatefulWidget {
  @override
  _PrePartTwoOnBoardScreenState createState() =>
      _PrePartTwoOnBoardScreenState();
}

class _PrePartTwoOnBoardScreenState extends State<PrePartTwoOnBoardScreen> {
  List<List<TextSpan>> _questionList = [
    [
      TextSpan(
          text: Constant.nextWeAreGoing,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
      TextSpan(
          text: Constant.answeringTheNext,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ]
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        isShowNextButton: _currentIndex != (_questionList.length - 1),
        bubbleChatTextSpanList: _questionList[_currentIndex],
        nextButtonFunction: () {
          setState(() {
            _currentIndex++;
          });
        },
        bottomButtonText: Constant.continueText,
        bottomButtonFunction: () {
          Navigator.pushReplacementNamed(
              context, Constant.partTwoOnBoardScreenRouter);
        },
        isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
        secondBottomButtonText: Constant.saveAndFinishLater,
        secondBottomButtonFunction: () {
          //TODO: Save & Finish Later Button implementation
        },
      ),
    );
  }
}
