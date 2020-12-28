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
  bool _isButtonClicked = false;

  @override
  void initState() {
    super.initState();
    signUpBoardFirstStepBloc = SignUpBoardFirstStepBloc();
    signUpOnBoardSelectedAnswersModel = SignUpOnBoardSelectedAnswersModel();
    Utils.saveUserProgress(0, Constant.prePartTwoEventStep);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFirstStepUserDataFromLocalDatabase();
    });
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: OnBoardInformationScreen(
          isShowNextButton: _currentIndex != (_questionList.length - 1),
          bubbleChatTextSpanList: _questionList[_currentIndex],
          chatText: bubbleChatTextView[_currentIndex],
          nextButtonFunction: () {
            if(!_isButtonClicked) {
              _isButtonClicked = true;
              setState(() {
                _currentIndex++;
              });
              Future.delayed(Duration(milliseconds: 350), () {
                _isButtonClicked = false;
              });
            }
          },
          bottomButtonText: Constant.continueText,
          bottomButtonFunction: () {
            Navigator.pushReplacementNamed(
                context, Constant.partTwoOnBoardScreenRouter,
                arguments: Constant.clinicalImpressionShort1);
          },
          isShowSecondBottomButton: _currentIndex == (_questionList.length - 1),
          secondBottomButtonText: Constant.saveAndFinishLater,
          secondBottomButtonFunction: () {
            Utils.navigateToHomeScreen(context, true);
          },
          closeButtonFunction: () {
            Utils.navigateToExitScreen(context);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    signUpBoardFirstStepBloc.dispose();
    super.dispose();
  }

  /// In this method we are sending First Step Data in to the Server. And if we get successful response from server then
  /// we will delete profile i.e zeroEventStep and FirstStep i.e firstEventStep data from Local Database.
  void getFirstStepUserDataFromLocalDatabase() async {
    var signUpOnBoardSelectedAnswersListModel = await SignUpOnBoardProviders.db
        .getAllSelectedAnswers(Constant.firstEventStep);
    if (signUpOnBoardSelectedAnswersListModel == null) {
      print("Nothing will be happen");
    } else {
      signUpOnBoardSelectedAnswersModel.selectedAnswers =
          signUpOnBoardSelectedAnswersListModel;
      Utils.showApiLoaderDialog(
        context,
        networkStream: signUpBoardFirstStepBloc.sendFirstStepDataStream,
        tapToRetryFunction: () {
          signUpBoardFirstStepBloc.enterSomeDummyDataToStreamController();
          _callSendFirstStepDataApi();
        }
      );
      _callSendFirstStepDataApi();
    }
  }

  void _callSendFirstStepDataApi() async{
    var apiResponse = await signUpBoardFirstStepBloc
        .sendSignUpFirstStepData(signUpOnBoardSelectedAnswersModel);

    if (apiResponse is String) {
      if (apiResponse == Constant.success) {
        await SignUpOnBoardProviders.db
            .deleteOnBoardQuestionnaireProgress(Constant.zeroEventStep);
        await SignUpOnBoardProviders.db
            .deleteOnBoardQuestionnaireProgress(Constant.firstEventStep);
        Utils.closeApiLoaderDialog(context);
      }
    }
  }

  Future<bool> _onBackPressed() async {
    if(!_isButtonClicked) {
      _isButtonClicked = true;
      if (_currentIndex == 0) {
        Future.delayed(Duration(milliseconds: 350), () {
          _isButtonClicked = false;
        });
        return true;
      } else {
        setState(() {
          _currentIndex--;
        });
        Future.delayed(Duration(milliseconds: 350), () {
          _isButtonClicked = false;
        });
        return false;
      }
    } else {
      return false;
    }
  }
}
