import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PrePartThreeOnBoardScreen extends StatefulWidget {
  @override
  _PrePartThreeOnBoardScreenState createState() =>
      _PrePartThreeOnBoardScreenState();
}

class _PrePartThreeOnBoardScreenState extends State<PrePartThreeOnBoardScreen> {
  List<List<TextSpan>> _questionList = [
    [
      TextSpan(
          text: Constant.almostReadyToHelp,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
    TextSpan(
        text: Constant.quickAndEasySection,
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
        nextButtonFunction: () {
          setState(() {
            _currentIndex++;
          });
        },
        bottomButtonText: Constant.continueText,
        bottomButtonFunction: () {
          Navigator.pushReplacementNamed(
              context, Constant.partThreeOnBoardScreenRouter);
          //TODO: Move to Part Three On Board Screen
        },
        bubbleChatTextSpanList:  _questionList[_currentIndex],
        isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
        secondBottomButtonText: Constant.saveAndFinishLater,
        secondBottomButtonFunction: () {
          //TODO: Save & Finish Later button implementation
        },
      ),
    );
  }
}
