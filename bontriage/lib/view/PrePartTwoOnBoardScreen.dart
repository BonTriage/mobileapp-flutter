import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpOnBoardFirstStepBloc.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';

class PrePartTwoOnBoardScreen extends StatefulWidget {
  @override
  _PrePartTwoOnBoardScreenState createState() =>
      _PrePartTwoOnBoardScreenState();
}

class _PrePartTwoOnBoardScreenState extends State<PrePartTwoOnBoardScreen> {
  SignUpBoardFirstStepBloc signUpBoardFirstStepBloc;
  SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signUpBoardFirstStepBloc = SignUpBoardFirstStepBloc();
    signUpOnBoardSelectedAnswersModel = SignUpOnBoardSelectedAnswersModel();
    Utils.saveUserProgress(0, Constant.prePartTwoEventStep);
    getFirstStepUserDataFromLocalDatabase();
  }

  List<List<TextSpan>> _questionList = [
    [
      TextSpan(
          text: Constant.nextWeAreGoing,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ],
    [
      TextSpan(
          text: Constant.answeringTheNext,
          style: TextStyle(
              height: 1.3,
              fontSize: 16,
              fontFamily: Constant.jostRegular,
              color: Constant.bubbleChatTextView))
    ]
  ];

  List<String> bubbleChatTextView = [
    Constant.nextWeAreGoing,
    Constant.answeringTheNext,
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardInformationScreen(
        isShowNextButton: _currentIndex != (_questionList.length - 1),
        bubbleChatTextSpanList: _questionList[_currentIndex],
        chatText: bubbleChatTextView[_currentIndex],
        nextButtonFunction: () {
          setState(() {
            _currentIndex++;
          });
        },
        bottomButtonText: Constant.continueText,
        bottomButtonFunction: () {
          Navigator.pushReplacementNamed(
              context, Constant.partTwoOnBoardScreenRouter,
              arguments: "clinical_impression_short2");
        },
        isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
        secondBottomButtonText: Constant.saveAndFinishLater,
        secondBottomButtonFunction: () {
          Navigator.pushReplacementNamed(context, Constant.homeRouter);
        },
        closeButtonFunction: () {
          Utils.navigateToUserOnProfileBoard(context);
        },
      ),
    );
  }

  void getFirstStepUserDataFromLocalDatabase() async {
    var signUpOnBoardSelectedAnswersListModel = await SignUpOnBoardProviders.db
        .getAllSelectedAnswers(Constant.firstEventStep);
    signUpOnBoardSelectedAnswersModel.selectedAnswers =
        signUpOnBoardSelectedAnswersListModel;
    signUpBoardFirstStepBloc
        .sendSignUpFirstStepData(signUpOnBoardSelectedAnswersModel);
  }
}
