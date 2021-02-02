import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpOnBoardSecondStepBloc.dart';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardFirstStepQuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/NetworkErrorScreen.dart';
import 'package:mobile/view/OnBoardMultiSelectOption.dart';
import 'package:mobile/view/on_board_bottom_buttons.dart';
import 'package:mobile/view/on_board_chat_bubble.dart';
import 'package:mobile/view/on_board_select_options.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'package:mobile/view/sign_up_name_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartTwoOnBoardScreens extends StatefulWidget {
  final String argumentsName;

  const PartTwoOnBoardScreens({this.argumentsName = Constant.clinicalImpressionShort1});

  @override
  _PartTwoOnBoardScreensState createState() => _PartTwoOnBoardScreensState();
}

class _PartTwoOnBoardScreensState extends State<PartTwoOnBoardScreens> {
  PageController _pageController = PageController(
    initialPage: 0,
  );

  int _currentPageIndex = 0;
  double _progressPercent = 0;

  List<SignUpOnBoardFirstStepQuestionsModel> _pageViewWidgetList;
  bool isEndOfOnBoard = false;
  bool isAlreadyDataFiltered = false;
  SignUpOnBoardSecondStepBloc _signUpOnBoardSecondStepBloc;

  bool _isButtonClicked = false;
  SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel =
      SignUpOnBoardSelectedAnswersModel();

  int currentScreenPosition = 0;

  List<Questions> currentQuestionListData = [];

  Future<bool> _onBackPressed() async {
    if(!_isButtonClicked) {
      _isButtonClicked = true;
      if (_currentPageIndex == 0) {
        if (widget.argumentsName == Constant.clinicalImpressionEventType) {
          var userHeadacheName = signUpOnBoardSelectedAnswersModel
              .selectedAnswers
              .firstWhere((model) =>
          model.questionTag == "nameClinicalImpression", orElse: () => null);

          if (userHeadacheName != null)
            Navigator.pop(context, userHeadacheName.answer);
          else
            Navigator.pop(context);

          Future.delayed(Duration(milliseconds: 350), () {
            _isButtonClicked = false;
          });
          return false;
        }
        Future.delayed(Duration(milliseconds: 350), () {
          _isButtonClicked = false;
        });
        return true;
      } else {
        setState(() {
          double stepOneProgress = 1 / _pageViewWidgetList.length;

          if (_currentPageIndex != 0) {
            _progressPercent -= stepOneProgress;
            _currentPageIndex--;
            _pageController.animateToPage(_currentPageIndex,
                duration: Duration(milliseconds: 1), curve: Curves.easeIn);
          }
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

  @override
  void dispose() {
    _pageController.dispose();
    _signUpOnBoardSecondStepBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _signUpOnBoardSecondStepBloc = SignUpOnBoardSecondStepBloc();
    signUpOnBoardSelectedAnswersModel.eventType = Constant.secondEventStep;
    signUpOnBoardSelectedAnswersModel.selectedAnswers = [];

    _pageViewWidgetList = [];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Utils.showApiLoaderDialog(context);
    });

    getCurrentUserPosition();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Constant.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: StreamBuilder<dynamic>(
                stream: _signUpOnBoardSecondStepBloc
                    .signUpOnBoardSecondStepDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (!isAlreadyDataFiltered && !_isButtonClicked) {
                      Utils.closeApiLoaderDialog(context);
                      addFilteredQuestionListData(snapshot.data);
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OnBoardChatBubble(
                          isEndOfOnBoard: isEndOfOnBoard,
                          chatBubbleText:
                              _pageViewWidgetList[_currentPageIndex].questions,
                          closeButtonFunction: () {
                            if(widget.argumentsName == Constant.clinicalImpressionShort1)
                              Utils.navigateToExitScreen(context);
                            else
                              Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          height: 15,
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
                        SizedBox(
                          height: 15,
                        ),
                        OnBoardBottomButtons(
                          progressPercent: _progressPercent,
                          backButtonFunction: () {
                            _onBackPressed();
                          },
                          currentIndex: _currentPageIndex,
                          nextButtonFunction: () {
                            if(!_isButtonClicked) {
                              _isButtonClicked = true;
                              if (Utils.validationForOnBoard(
                                  signUpOnBoardSelectedAnswersModel.selectedAnswers,
                                  currentQuestionListData[_currentPageIndex])) {
                                setState(() {
                                  double stepOneProgress =
                                      1 / _pageViewWidgetList.length;
                                  if (_progressPercent == 1) {
                                    moveUserToNextScreen();
                                  } else {
                                    _currentPageIndex++;

                                    if (_currentPageIndex !=
                                        _pageViewWidgetList.length - 1)
                                      _progressPercent += stepOneProgress;
                                    else {
                                      _progressPercent = 1;
                                    }

                                    _pageController.animateToPage(_currentPageIndex,
                                        duration: Duration(milliseconds: 1),
                                        curve: Curves.easeIn);
                                  }
                                  if(widget.argumentsName == Constant.clinicalImpressionShort1)
                                    getCurrentQuestionTag(_currentPageIndex);
                                });
                              }
                              Future.delayed(Duration(milliseconds: 350), () {
                                _isButtonClicked = false;
                              });
                            }
                          },
                          onBoardPart: 2,
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    Utils.closeApiLoaderDialog(context);
                    return NetworkErrorScreen(
                      errorMessage: snapshot.error.toString(),
                      tapToRetryFunction: () {
                        Utils.showApiLoaderDialog(context);
                        requestService();
                      },
                    );
                  } else {
                    return Container();
                  }
                })),
      ),
    );
  }

  /// This method will be use for to set the UI content from the respective Question Tag.
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
                  uiHints: element.uiHints,
                )));
            break;

          case Constant.QuestionTextType:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpNameScreen(
                  tag: element.tag,
                  helpText: element.helpText,
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
                    })));
            break;
          case Constant.QuestionMultiType:
            List<OnBoardSelectOptionModel> valuesListData = [];
            element.values.forEach((element) {
              valuesListData.add(OnBoardSelectOptionModel(
                  optionId: element.valueNumber, optionText: element.text));
            });
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: OnBoardMultiSelectOptions(
                    selectOptionList: valuesListData,
                    questionTag: element.tag,
                    selectedAnswerListData:
                        signUpOnBoardSelectedAnswersModel.selectedAnswers,
                    selectedAnswerCallBack: (currentTag, selectedUserAnswer) {
                      selectedAnswerListData(currentTag, selectedUserAnswer);
                    })));
            break;
        }
        isAlreadyDataFiltered = true;
      });
      print(questionListData);
      // We have to change this condition
      _currentPageIndex = currentScreenPosition;
      _progressPercent =
          (_currentPageIndex + 1) * (1 / _pageViewWidgetList.length);
      _pageController = PageController(initialPage: currentScreenPosition);
    }
  }

  /// This method will be use for to get current position of the user. When he last time quit the application or click the close
  /// icon. We will fetch last position from Local database.
  void getCurrentUserPosition() async {
    if(widget.argumentsName == Constant.clinicalImpressionShort1) {
      UserProgressDataModel userProgressModel =
      await SignUpOnBoardProviders.db.getUserProgress();
      if (userProgressModel != null &&
          userProgressModel.step == Constant.secondEventStep) {
        currentScreenPosition = userProgressModel.userScreenPosition;
        print(userProgressModel);
      }

      getCurrentQuestionTag(currentScreenPosition);
    }

    requestService();
  }

  /// In this method we will hit the API of Second step of questions list.So if we have empty table into the database.
  /// then we hit the API and save the all questions data in to the database. if not then we will fetch the all data from the local
  /// database of respective table.
  void requestService() async {
    List<LocalQuestionnaire> localQuestionnaireData =
        await SignUpOnBoardProviders.db
            .getQuestionnaire(Constant.secondEventStep);

    if (localQuestionnaireData != null && localQuestionnaireData.length > 0) {
      signUpOnBoardSelectedAnswersModel = await _signUpOnBoardSecondStepBloc
          .fetchDataFromLocalDatabase(localQuestionnaireData);
    } else {

      _signUpOnBoardSecondStepBloc
          .fetchSignUpOnBoardSecondStepData(widget.argumentsName);
    }
  }

  /// This method will be use for to get current tag from respective API and if the current table from database is empty then insert the
  /// data on respective position of the questions list.and if not then update the data on respective position.
  void getCurrentQuestionTag(int currentPageIndex) async {
    var isDataBaseExists = await SignUpOnBoardProviders.db.isDatabaseExist();
    UserProgressDataModel userProgressDataModel = UserProgressDataModel();

    if (!isDataBaseExists) {
      userProgressDataModel = await _signUpOnBoardSecondStepBloc
          .fetchSignUpOnBoardSecondStepData(widget.argumentsName);
    } else {
      int userProgressDataCount = await SignUpOnBoardProviders.db
          .checkUserProgressDataAvailable(
              SignUpOnBoardProviders.TABLE_USER_PROGRESS);
      userProgressDataModel.userId = Constant.userID;
      userProgressDataModel.step = Constant.secondEventStep;
      userProgressDataModel.userScreenPosition = currentPageIndex;
      userProgressDataModel.questionTag = (currentQuestionListData.length > 0)
          ? currentQuestionListData[currentPageIndex].tag
          : '';

      if (userProgressDataCount == 0) {
        SignUpOnBoardProviders.db.insertUserProgress(userProgressDataModel);
      } else {
        SignUpOnBoardProviders.db.updateUserProgress(userProgressDataModel);
      }
    }
  }

  /// This method will be use for select the answer data on the basis of current Tag. and also update the selected answer in local database.
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

    if(widget.argumentsName == Constant.clinicalImpressionShort1)
      updateSelectedAnswerDataOnLocalDatabase();
  }

  /// This method will be use for update the answer in to the database on the basis of event type.
  updateSelectedAnswerDataOnLocalDatabase() {
    var answerStringData =
        Utils.getStringFromJson(signUpOnBoardSelectedAnswersModel);
    LocalQuestionnaire localQuestionnaire = LocalQuestionnaire();
    localQuestionnaire.selectedAnswers = answerStringData;
    SignUpOnBoardProviders.db.updateSelectedAnswers(
        signUpOnBoardSelectedAnswersModel, Constant.secondEventStep);
  }

  void moveUserToNextScreen() {
    isEndOfOnBoard = true;
    TextToSpeechRecognition.speechToText("");

    Utils.showApiLoaderDialog(
      context,
      networkStream: _signUpOnBoardSecondStepBloc.sendSecondStepDataStream,
      tapToRetryFunction: () {
        _signUpOnBoardSecondStepBloc.enterSomeDummyDataToStreamController();
        _callSendSecondStepDataApi();
      }
    );

    _callSendSecondStepDataApi();
  }

  void _callSendSecondStepDataApi() async {
    var response = await _signUpOnBoardSecondStepBloc.sendSignUpSecondStepData(signUpOnBoardSelectedAnswersModel);
    if (response is String) {
      if (response == Constant.success) {
        await SignUpOnBoardProviders.db
            .deleteOnBoardQuestionnaireProgress(Constant.secondEventStep);
        Navigator.pop(context);
        if (widget.argumentsName == Constant.clinicalImpressionEventType) {
          var userHeadacheName =
          signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere(
                  (model) => model.questionTag == "nameClinicalImpression");
          Navigator.pop(context, userHeadacheName.answer);
        } else {
          SelectedAnswers nameClinicalImpressionSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == "nameClinicalImpression", orElse: () => null);
          if(nameClinicalImpressionSelectedAnswer != null) {
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString(Constant.userHeadacheName, nameClinicalImpressionSelectedAnswer.answer);
          }
          Navigator.pushReplacementNamed(context,
              Constant.signUpOnBoardSecondStepPersonalizedHeadacheResultRouter);
        }
      }
    }
  }
}
