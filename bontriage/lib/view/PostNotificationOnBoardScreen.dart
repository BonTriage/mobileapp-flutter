import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PostNotificationOnBoardScreen extends StatefulWidget {
  @override
  _PostNotificationOnBoardScreenState createState() =>
      _PostNotificationOnBoardScreenState();
}

class _PostNotificationOnBoardScreenState
    extends State<PostNotificationOnBoardScreen> {
  List<List<TextSpan>> _questionList = [
    [
      TextSpan(
          text: Constant.almostReadyToHelp,
          style: TextStyle(
              height: 1.3,
              fontSize: 12,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
      TextSpan(
          text: Constant.quickAndEasySection,
          style: TextStyle(
              height: 1.3,
              fontSize: 12,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ]
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        isShowNextButton: true,
        nextButtonFunction: () {
          if (_currentIndex == _questionList.length - 1) {
            //TODO: Move to next screen
            print('Move to Next Screen');
          } else {
            setState(() {
              _currentIndex++;
            });
          }
        },
        bubbleChatTextSpanList: _questionList[_currentIndex],
        isShowSecondBottomButton: false,
      ),
    );
  }
}
