import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpOnBoardFirstStepBloc.dart';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardFirstStepQuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/view/sign_up_location_services.dart';
import 'package:mobile/view/sign_up_name_screen.dart';

import '../util/constant.dart';
import 'on_board_bottom_buttons.dart';
import 'on_board_chat_bubble.dart';
import 'on_board_select_options.dart';
import 'sign_up_age_screen.dart';

class PartOneOnBoardScreenTwo extends StatefulWidget {
  @override
  _PartOneOnBoardScreenStateTwo createState() =>
      _PartOneOnBoardScreenStateTwo();
}

class _PartOneOnBoardScreenStateTwo extends State<PartOneOnBoardScreenTwo> {
  SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel =
      SignUpOnBoardSelectedAnswersModel();

  int currentScreenPosition = 0;
  SignUpBoardFirstStepBloc signUpBoardFirstStepBloc;
  List<Questions> currentQuestionListData;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  int _currentPageIndex = 0;
  double _progressPercent = 0.66;

  List<SignUpOnBoardFirstStepQuestionsModel> _pageViewWidgetList = [];
  bool isEndOfOnBoard = false;
  bool isButtonClicked = false;

  bool isAlreadyDataFiltered = false;

  void _onBackPressed() {
    isButtonClicked = true;
    setState(() {
      double stepOneProgress = 0.14;

      if (_currentPageIndex != 0) {
        _progressPercent -= stepOneProgress;
        _currentPageIndex--;
        _pageController.animateToPage(_currentPageIndex,
            duration: Duration(milliseconds: 1), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    signUpBoardFirstStepBloc = SignUpBoardFirstStepBloc();
    signUpOnBoardSelectedAnswersModel.eventType = Constant.firstEventStep;
    signUpOnBoardSelectedAnswersModel.selectedAnswers = [];
    getCurrentUserPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
          child: StreamBuilder<dynamic>(
        stream: signUpBoardFirstStepBloc.albumDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!isButtonClicked) {
              addFilteredQuestionListData(snapshot.data);
              isButtonClicked = false;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OnBoardChatBubble(
                  isEndOfOnBoard: isEndOfOnBoard,
                  chatBubbleText:
                      _pageViewWidgetList[_currentPageIndex].questions,
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(
                    child: PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _pageViewWidgetList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _pageViewWidgetList[index].questionsWidget;
                  },
                )),
                OnBoardBottomButtons(
                  progressPercent: _progressPercent,
                  backButtonFunction: _onBackPressed,
                  nextButtonFunction: () {
                    isButtonClicked = true;
                    setState(() {
                      double stepOneProgress = 0.11;

                      if (_progressPercent == 1) {
                             signUpBoardFirstStepBloc
                                            .sendSignUpFirstStepData(
                                                signUpOnBoardSelectedAnswersModel);
                        isEndOfOnBoard = true;
                        TextToSpeechRecognition.pauseSpeechToText(true, "");
                        Navigator.pushReplacementNamed(
                            context,
                            Constant
                                .signUpOnBoardPersonalizedHeadacheResultRouter);
                        //TODO: Move to next screen
                      } else {
                        _currentPageIndex++;

                        if (_currentPageIndex != _pageViewWidgetList.length - 1)
                          _progressPercent += stepOneProgress;
                        else {
                          _progressPercent = 1;
                        }

                        _pageController.animateToPage(_currentPageIndex,
                            duration: Duration(milliseconds: 1),
                            curve: Curves.easeIn);
                      }
                      getCurrentQuestionTag(
                          _currentPageIndex);
                    });
                  },
                  onBoardPart: 1,
                )
              ],
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  backgroundColor: Constant.chatBubbleGreen,
                ),
              ),
            );
          }
        },
      )),
    );
  }

  void getCurrentUserPosition() async {
    UserProgressDataModel userProgressModel =
        await SignUpOnBoardProviders.db.getUserProgress();
    if (userProgressModel != null &&
        userProgressModel.step == Constant.firstEventStep) {
      currentScreenPosition = userProgressModel.userScreenPosition;
      print(userProgressModel);
    }
    requestService();
  }

  void requestService() async {
    List<LocalQuestionnaire> localQuestionnaireData =
        await SignUpOnBoardProviders.db
            .getQuestionnaire(Constant.firstEventStep);
    if (localQuestionnaireData != null && localQuestionnaireData.length > 0) {
      signUpOnBoardSelectedAnswersModel = await signUpBoardFirstStepBloc
          .fetchDataFromLocalDatabase(localQuestionnaireData);
    } else {
      signUpBoardFirstStepBloc.fetchSignUpFirstStepData();
    }
  }

  void getCurrentQuestionTag(int currentPageIndex) async {
    var isDataBaseExists = await SignUpOnBoardProviders.db.isDatabaseExist();
    UserProgressDataModel userProgressDataModel = UserProgressDataModel();

    if (!isDataBaseExists) {
      userProgressDataModel =
          await signUpBoardFirstStepBloc.fetchSignUpFirstStepData();
    } else {
      int userProgressDataCount = await SignUpOnBoardProviders.db
          .checkUserProgressDataAvailable(
              SignUpOnBoardProviders.TABLE_USER_PROGRESS);
      userProgressDataModel.userId = Constant.userID;
      userProgressDataModel.step = Constant.firstEventStep;
      userProgressDataModel.userScreenPosition = currentPageIndex;
      userProgressDataModel.questionTag =
          currentQuestionListData[currentPageIndex].tag;

      if (userProgressDataCount == 0) {
        SignUpOnBoardProviders.db.insertUserProgress(userProgressDataModel);
      } else {
        SignUpOnBoardProviders.db.updateUserProgress(userProgressDataModel);
      }
    }
  }

  void selectedAnswerListData(String currentTag, String selectedUserAnswer) {
    SelectedAnswers selectedAnswers;
    if (signUpOnBoardSelectedAnswersModel.selectedAnswers.length > 0) {
      selectedAnswers = signUpOnBoardSelectedAnswersModel.selectedAnswers
          .firstWhere((model) => model.questionTag == currentTag,
              orElse: () => null);
    }
    if (selectedAnswers != null) {
      selectedAnswers.answer = selectedUserAnswer;
    } else {
      signUpOnBoardSelectedAnswersModel.selectedAnswers.add(
          SelectedAnswers(questionTag: currentTag, answer: selectedUserAnswer));
      print(signUpOnBoardSelectedAnswersModel.selectedAnswers);
    }
    updateSelectedAnswerDataOnLocalDatabase();
  }

  updateSelectedAnswerDataOnLocalDatabase() {
    var answerStringData =
        Utils.getStringFromJson(signUpOnBoardSelectedAnswersModel);
    LocalQuestionnaire localQuestionnaire = LocalQuestionnaire();
    localQuestionnaire.selectedAnswers = answerStringData;
    SignUpOnBoardProviders.db
        .updateSelectedAnswers(signUpOnBoardSelectedAnswersModel, Constant.firstEventStep);
  }

  addFilteredQuestionListData(List<dynamic> questionListData) {
    if (questionListData != null) {
      currentQuestionListData = questionListData;
      questionListData.forEach((element) {
        switch (element.questionType) {
          case Constant.QuestionNumberType:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpAgeScreen(
                  sliderValue: element.min.toDouble(),
                  sliderMinValue: element.min.toDouble(),
                  sliderMaxValue: element.max.toDouble(),
                  minText: element.min.toString(),
                  maxText: element.max.toString(),
                  labelText: "",
                  currentTag: element.tag,
                  selectedAnswerListData:
                      signUpOnBoardSelectedAnswersModel.selectedAnswers,
                  selectedAnswerCallBack: (currentTag, selectedUserAnswer) {
                    print(currentTag + selectedUserAnswer);
                    selectedAnswerListData(currentTag, selectedUserAnswer);
                  },
                )));
            break;

          case Constant.QuestionTextType:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpNameScreen(
                  tag: element.tag,
                  selectedAnswerListData:
                      signUpOnBoardSelectedAnswersModel.selectedAnswers,
                  selectedAnswerCallBack: (currentTag, selectedUserAnswer) {
                    print(currentTag + selectedUserAnswer);
                    selectedAnswerListData(currentTag, selectedUserAnswer);
                  },
                )));
            break;

          case Constant.QuestionSingleType:
            List<OnBoardSelectOptionModel> valuesListData = [];
            element.values.forEach((element) {
              valuesListData.add(OnBoardSelectOptionModel(
                  optionId: element.valueNumber, optionText: element.text));
            });
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: OnBoardSelectOptions(
                  selectOptionList: valuesListData,
                  questionTag: element.tag,
                  selectedAnswerListData:
                      signUpOnBoardSelectedAnswersModel.selectedAnswers,
                  selectedAnswerCallBack: (currentTag, selectedUserAnswer) {
                    selectedAnswerListData(currentTag, selectedUserAnswer);
                  },
                )));
            break;
        }
        isAlreadyDataFiltered = true;
      });

      _currentPageIndex = currentScreenPosition;
      _progressPercent = (_currentPageIndex + 1) * 0.11;
      _pageController = PageController(initialPage: currentScreenPosition);
      /*_pageController.animateToPage(currentScreenPosition,
          duration: Duration(milliseconds: 1), curve: Curves.easeIn);*/

      print(questionListData);
    }
  }
}
