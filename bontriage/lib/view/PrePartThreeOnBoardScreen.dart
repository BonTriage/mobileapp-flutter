import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PrePartThreeOnBoardScreen extends StatefulWidget {
  @override
  _PrePartThreeOnBoardScreenState createState() => _PrePartThreeOnBoardScreenState();
}

class _PrePartThreeOnBoardScreenState extends State<PrePartThreeOnBoardScreen> {
  List<String> _questionList = [
    Constant.almostReadyToHelp,
    Constant.quickAndEasySection
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
          //TODO: Move to Part Three On Board Screen
        },
        chatText: _questionList[_currentIndex],
        isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
        secondBottomButtonText: Constant.saveAndFinishLater,
        secondBottomButtonFunction: () {
          //TODO: Save & Finish Later button implementation
        },
      ),
    );
  }
}
