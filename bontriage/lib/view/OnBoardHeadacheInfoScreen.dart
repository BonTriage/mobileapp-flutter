import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class OnBoardHeadacheInfoScreen extends StatefulWidget {
  @override
  _OnBoardHeadacheInfoScreenState createState() => _OnBoardHeadacheInfoScreenState();
}

class _OnBoardHeadacheInfoScreenState extends State<OnBoardHeadacheInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        chatText: Constant.letsBeginBySeeing,
        isShowNextButton: true,
        nextButtonFunction: () {
          //TODO: Continue part one on-board
        },
        isShowSecondBottomButton: false,
      ),
    );
  }
}
