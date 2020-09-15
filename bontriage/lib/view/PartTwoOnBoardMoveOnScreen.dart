import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PartTwoOnBoardMoveOnScreen extends StatefulWidget {
  @override
  _PartTwoOnBoardMoveOnScreenState createState() => _PartTwoOnBoardMoveOnScreenState();
}

class _PartTwoOnBoardMoveOnScreenState extends State<PartTwoOnBoardMoveOnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        bubbleChatTextSpanList: [
          TextSpan(
              text: Constant.experienceTypesOfHeadaches,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 12,
                  fontFamily: Constant.jostRegular,
                  color: Constant.bubbleChatTextView))
        ],
        isShowNextButton: false,
        bottomButtonText: Constant.moveOnForNow,
        bottomButtonFunction: () {
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
