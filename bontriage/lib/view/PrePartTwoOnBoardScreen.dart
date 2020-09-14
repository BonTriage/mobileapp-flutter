import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PrePartTwoOnBoardScreen extends StatefulWidget {
  @override
  _PrePartTwoOnBoardScreenState createState() => _PrePartTwoOnBoardScreenState();
}

class _PrePartTwoOnBoardScreenState extends State<PrePartTwoOnBoardScreen> {
  List<String> _questionList = [
    Constant.nextWeAreGoing,
    Constant.answeringTheNext
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
        bottomButtonText: Constant.continueText,
        bottomButtonFunction: () {
          //TODO: Move to next screen
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
