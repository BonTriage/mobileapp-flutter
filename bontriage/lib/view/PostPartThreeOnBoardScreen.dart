import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PostPartThreeOnBoardScreen extends StatefulWidget {
  @override
  _PostPartThreeOnBoardScreenState createState() => _PostPartThreeOnBoardScreenState();
}

class _PostPartThreeOnBoardScreenState extends State<PostPartThreeOnBoardScreen> {
  List<String> _questionList = [
    Constant.qualityOfOurMentorShip,
    Constant.easyToLoseTrack
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
        bottomButtonText: Constant.setUpNotifications,
        bottomButtonFunction: () {
          //TODO: Move to next screen
        },
        isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
        secondBottomButtonText: Constant.notNow,
        secondBottomButtonFunction: () {
          //TODO: Not Now button Implementation
        },
      ),
    );
  }
}
