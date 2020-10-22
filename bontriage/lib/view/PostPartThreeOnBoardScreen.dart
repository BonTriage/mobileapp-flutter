import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PostPartThreeOnBoardScreen extends StatefulWidget {
  @override
  _PostPartThreeOnBoardScreenState createState() =>
      _PostPartThreeOnBoardScreenState();
}

class _PostPartThreeOnBoardScreenState
    extends State<PostPartThreeOnBoardScreen> {
  List<List<TextSpan>> _questionList = [
    [
      TextSpan(
          text: Constant.qualityOfOurMentorShip,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
      TextSpan(
          text: Constant.easyToLoseTrack,
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
        bottomButtonText: Constant.setUpNotifications,
        bottomButtonFunction: () {
          Navigator.pushReplacementNamed(
              context, Constant.notificationScreenRouter);
        },
        isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
        secondBottomButtonText: Constant.notNow,
        secondBottomButtonFunction: () {
          Navigator.pushReplacementNamed(context, Constant.homeRouter);
        },
      ),
    );
  }
}
