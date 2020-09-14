import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

import '../util/constant.dart';

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
          Navigator.pushReplacementNamed(context, Constant.partOneOnBoardScreenTwo);
        },
        isShowSecondBottomButton: false,
      ),
    );
  }
}
