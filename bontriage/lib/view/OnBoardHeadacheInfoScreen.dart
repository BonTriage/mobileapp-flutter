import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

import '../util/constant.dart';

class OnBoardHeadacheInfoScreen extends StatefulWidget {
  @override
  _OnBoardHeadacheInfoScreenState createState() =>
      _OnBoardHeadacheInfoScreenState();
}

class _OnBoardHeadacheInfoScreenState extends State<OnBoardHeadacheInfoScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.saveUserProgress(0, Constant.headacheInfoEventStep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        bubbleChatTextSpanList: [
          TextSpan(
              text: Constant.letsBeginBySeeing,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 15,
                  fontFamily: Constant.jostRegular,
                  color: Constant.bubbleChatTextView))
        ],
        isShowNextButton: true,
        chatText: Constant.letsBeginBySeeing,
        nextButtonFunction: () {
          TextToSpeechRecognition.pauseSpeechToText(true,"");
          Navigator.pushReplacementNamed(
              context, Constant.partOneOnBoardScreenTwoRouter);
        },
        isShowSecondBottomButton: false,
        closeButtonFunction: () {
          Navigator.pushReplacementNamed(context, Constant.onBoardExitScreenRouter);
        },
      ),
    );
  }
}
