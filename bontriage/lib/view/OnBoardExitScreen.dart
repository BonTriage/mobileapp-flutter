import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class OnBoardExitScreen extends StatefulWidget {
  @override
  _OnBoardExitScreenState createState() => _OnBoardExitScreenState();
}

class _OnBoardExitScreenState extends State<OnBoardExitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        bubbleChatTextSpanList: [
          TextSpan(
              text: Constant.untilYouComplete,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  fontFamily: Constant.jostRegular,
                  color: Constant.bubbleChatTextView))
        ],
        isShowNextButton: false,
        bottomButtonText: Constant.continueSurvey,
        bottomButtonFunction: () {
          //TODO: Move to next screen
        },
        isShowSecondBottomButton: true,
        secondBottomButtonText: Constant.saveAndFinishLater,
        secondBottomButtonFunction: () {
          //TODO: Add Another Headache button implementation
        },
      ),
    );
  }
}
