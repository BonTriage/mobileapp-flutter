import 'package:flutter/material.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
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
        isShowSecondBottomButton: true,
        secondBottomButtonText: widget.isAlreadyLoggedIn
            ? Constant.exitAndLoseProgress
            : Constant.saveAndFinishLater,
        secondBottomButtonFunction: () {
          if (widget.isAlreadyLoggedIn) {
            Navigator.pushReplacementNamed(context, Constant.homeRouter);
          } else {
            deleteUserAllWelComeBoardData();
          }
        },
        isShowCloseButton: false,
      ),
    );
  }

  void deleteUserAllWelComeBoardData() async {
    await SignUpOnBoardProviders.db.deleteAllTableData();
    Navigator.pop(context);
  }
}
