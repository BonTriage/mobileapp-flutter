import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PartTwoOnBoardMoveOnScreen extends StatefulWidget {
  @override
  _PartTwoOnBoardMoveOnScreenState createState() =>
      _PartTwoOnBoardMoveOnScreenState();
}

class _PartTwoOnBoardMoveOnScreenState
    extends State<PartTwoOnBoardMoveOnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        bubbleChatTextSpanList: [
          TextSpan(
              text: Constant.experienceTypesOfHeadaches,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  fontFamily: Constant.jostRegular,
                  color: Constant.bubbleChatTextView))
        ],
        isShowNextButton: false,
        chatText: Constant.experienceTypesOfHeadaches,
        bottomButtonText: Constant.moveOnForNow,
        bottomButtonFunction: () {
          TextToSpeechRecognition.pauseSpeechToText(true, "");
          Navigator.pushReplacementNamed(
              context, Constant.prePartThreeOnBoardScreenRouter);
          //TODO: Move to next screen
        },
        isShowSecondBottomButton: true,
        secondBottomButtonText: Constant.addAnotherHeadache,
        secondBottomButtonFunction: () {
          //TODO: Add Another Headache button implementation
        },
      ),
    );
  }
}
