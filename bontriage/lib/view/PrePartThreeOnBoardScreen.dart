import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.saveUserProgress(0, Constant.prePartThreeEventStep);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: OnBoardInformationScreen(
          isShowNextButton: _currentIndex != (_questionList.length - 1),
          nextButtonFunction: () {
            setState(() {
              _currentIndex++;
            });
          },
          bottomButtonText: Constant.continueText,
          chatText: bubbleChatTextView[_currentIndex],
          bottomButtonFunction: () {
           moveToNextScreen();
          },
          bubbleChatTextSpanList: _questionList[_currentIndex],
          isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
          secondBottomButtonText: Constant.saveAndFinishLater,
          secondBottomButtonFunction: () {
            Utils.navigateToHomeScreen(context, true);

          },
          closeButtonFunction: () {
            Utils.navigateToExitScreen(context);
          },
        ),
      ),
    );
  }

  static List<String> bubbleChatTextView = [
    Constant.almostReadyToHelp,
    Constant.quickAndEasySection,
  ];

  void moveToNextScreen() async {
    TextToSpeechRecognition.speechToText("");
    Navigator.pushReplacementNamed(
        context, Constant.partThreeOnBoardScreenRouter);
  }

  Future<bool> _onBackPressed() async {
    if(_currentIndex == 0) {
      return true;
    } else {
      setState(() {
        _currentIndex--;
      });
      return false;
    }
  }
}
