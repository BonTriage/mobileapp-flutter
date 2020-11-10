import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class OnBoardExitScreen extends StatefulWidget {
  final bool isAlreadyLoggedIn;

  const OnBoardExitScreen({Key key, this.isAlreadyLoggedIn = false})
      : super(key: key);

  @override
  _OnBoardExitScreenState createState() => _OnBoardExitScreenState();
}

class _OnBoardExitScreenState extends State<OnBoardExitScreen> {

  //TODO: Generate a separate list for text to speech

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        bubbleChatTextSpanList: [
          TextSpan(
              text: widget.isAlreadyLoggedIn
                  ? Constant.untilYouCompleteInitialAssessment
                  : Constant.untilYouComplete,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  fontFamily: Constant.jostRegular,
                  color: Constant.bubbleChatTextView))
        ],
        isShowNextButton: false,
        bottomButtonText: Constant.continueAssessment,
        bottomButtonFunction: () {
          Utils.navigateToUserOnProfileBoard(context);
        },
        chatText: widget.isAlreadyLoggedIn
            ? Constant.untilYouCompleteInitialAssessment
            : Constant.untilYouComplete,
        isShowSecondBottomButton: true,
        secondBottomButtonText: widget.isAlreadyLoggedIn
            ? Constant.saveAndFinishLater
            : Constant.exitAndLoseProgress,
        secondBottomButtonFunction: () {
          if (widget.isAlreadyLoggedIn) {
            Utils.navigateToHomeScreen(context, true);
          } else {
            deleteUserAllWelComeBoardData();
          }
        },
        isShowCloseButton: false,
      ),
    );
  }

  void deleteUserAllWelComeBoardData() async {
    TextToSpeechRecognition.speechToText("");
    await SignUpOnBoardProviders.db.deleteAllTableData();
    //Navigator.pop(context);
    //SystemNavigator.pop() does not work in Apple in alternative we can use exit(0) but it feels like the app got crashed and Apple may suspend your app because it's against Apple Human Interface guidelines to exit the app programmatically.
    SystemNavigator.pop();
  }
}
