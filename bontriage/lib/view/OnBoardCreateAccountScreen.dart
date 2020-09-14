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
        chatText: Constant.beforeContinuing,
        isShowNextButton: false,
        bottomButtonText: Constant.createAccount,
        bottomButtonFunction: () {},
        isShowSecondBottomButton: false,
      ),
    );
  }
}
