import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class OnBoardCreateAccount extends StatefulWidget {
  @override
  _OnBoardCreateAccountState createState() => _OnBoardCreateAccountState();
}

class _OnBoardCreateAccountState extends State<OnBoardCreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        bubbleChatTextSpanList: [
          TextSpan(
              text: Constant.beforeContinuing,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  fontFamily: Constant.jostRegular,
                  color: Constant.bubbleChatTextView))
        ],
        isShowNextButton: false,
        bottomButtonText: Constant.createAccount,
        bottomButtonFunction: () {
          Navigator.pushReplacementNamed(
              context, Constant.onBoardingScreenSignUpRouter);
        },
        isShowSecondBottomButton: false,
      ),
    );
  }
}
