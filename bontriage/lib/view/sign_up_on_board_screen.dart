import 'package:mobile/blocs/WelcomeOnBoardProfileBloc.dart';
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
import 'package:mobile/view/on_board_chat_bubble.dart';
import 'package:mobile/view/on_board_select_options.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'package:mobile/view/sign_up_location_services.dart';

import 'sign_up_name_screen.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SignUpOnBoardScreen extends StatefulWidget {
  @override
  _SignUpOnBoardScreenState createState() => _SignUpOnBoardScreenState();
}

class _SignUpOnBoardScreenState extends State<SignUpOnBoardScreen>
    with SingleTickerProviderStateMixin {
  bool isVolumeOn = true;
  bool isEndOfOnBoard = false;
  double _progressPercent = 0;
  int _currentPageIndex = 0;
  WelcomeOnBoardProfileBloc welcomeOnBoardProfileBloc;
  bool isAlreadyDataFiltered = false;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  List<SignUpOnBoardFirstStepQuestionsModel> _pageViewWidgetList;

  List<Questions> currentQuestionListData = [];

  SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel =
      SignUpOnBoardSelectedAnswersModel();

  int currentScreenPosition = 0;

  bool isButtonClicked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentQuestionListData.add(Questions());
    welcomeOnBoardProfileBloc = WelcomeOnBoardProfileBloc();
    signUpOnBoardSelectedAnswersModel.eventType = Constant.zeroEventStep;
    signUpOnBoardSelectedAnswersModel.selectedAnswers = [];
    _pageViewWidgetList = [
      SignUpOnBoardFirstStepQuestionsModel(
          questions: Constant.firstBasics, questionsWidget: Container())
    ];
    getCurrentUserPosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    welcomeOnBoardProfileBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: StreamBuilder<dynamic>(
              stream: welcomeOnBoardProfileBloc.albumDataStream,
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
                        chatBubbleText:
                            _pageViewWidgetList[_currentPageIndex].questions,
                        isEndOfOnBoard: isEndOfOnBoard,
                        closeButtonFunction: () {
                          Navigator.pushReplacementNamed(context, Constant.onBoardExitScreenRouter);
                        },
                      ),
                      SizedBox(height: 40),
                      Expanded(
                          child: PageView.builder(
                        controller: _pageController,
                        itemCount: _pageViewWidgetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _pageViewWidgetList[index].questionsWidget;
                        },
                        physics: NeverScrollableScrollPhysics(),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    Constant.chatBubbleHorizontalPadding),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  left: (_currentPageIndex != 0)
                                      ? 0
                                      : (MediaQuery.of(context).size.width -
                                          190),
                                  duration: Duration(milliseconds: 250),
                                  child: AnimatedOpacity(
                                    opacity:
                                        (_currentPageIndex != 0) ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 250),
                                    child: BouncingWidget(
                                      duration: Duration(milliseconds: 100),
                                      scaleFactor: 1.5,
                                      onPressed: () {
                                        isButtonClicked = true;
                                        setState(() {
                                          if (_currentPageIndex != 0) {
                                            _progressPercent -= 0.11;
                                            _currentPageIndex--;
                                            _pageController.animateToPage(
                                                _currentPageIndex,
                                                duration:
                                                    Duration(milliseconds: 1),
                                                curve: Curves.easeIn);
                                          } else {
                                            _progressPercent = 0;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 130,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: Color(0xffafd794),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Constant.back,
                                            style: TextStyle(
                                              color:
                                                  Constant.bubbleChatTextView,
                                              fontSize: 14,
                                              fontFamily: Constant.jostMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: BouncingWidget(
                                    duration: Duration(milliseconds: 100),
                                    scaleFactor: 1.5,
                                    onPressed: () {
                                      isButtonClicked = true;
                                      if(Utils.validationForOnBoard(signUpOnBoardSelectedAnswersModel.selectedAnswers, currentQuestionListData[_currentPageIndex])) {
                                        setState(() {
                                          if (_progressPercent == 0.55) {
                                            /*     welcomeOnBoardProfileBloc
                                            .sendSignUpFirstStepData(
                                                signUpOnBoardSelectedAnswersModel);*/
                                            isEndOfOnBoard = true;
                                            TextToSpeechRecognition
                                                .pauseSpeechToText(true, "");
                                            Navigator.pushReplacementNamed(
                                                context,
                                                Constant
                                                    .onBoardHeadacheInfoScreenRouter);
                                          } else {
                                            _currentPageIndex++;

                                            if (_currentPageIndex !=
                                                _pageViewWidgetList.length - 1)
                                              _progressPercent += 0.11;
                                            else {
                                              _progressPercent = 0.55;
                                            }

                                            _pageController.animateToPage(
                                                _currentPageIndex,
                                                duration:
                                                Duration(milliseconds: 1),
                                                curve: Curves.easeIn);

                                            getCurrentQuestionTag(
                                                _currentPageIndex);
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 130,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Color(0xffafd794),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Constant.next,
                                          style: TextStyle(
                                            color: Constant.bubbleChatTextView,
                                            fontSize: 14,
                                            fontFamily: Constant.jostMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 36,
                          ),
                          if (_currentPageIndex != 0)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 23),
                              child: LinearPercentIndicator(
                                animation: true,
                                lineHeight: 8.0,
                                animationDuration: 200,
                                animateFromLastPercent: true,
                                percent: _progressPercent,
                                backgroundColor: Constant.chatBubbleGreenBlue,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Constant.chatBubbleGreen,
                              ),
                            )
                          else
                            SizedBox(
                              height: 12.5,
                            ),
                          SizedBox(
                            height: 10.5,
                          ),
                          if (_currentPageIndex != 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Constant.chatBubbleHorizontalPadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'PART 1 OF 3',
                                    style: TextStyle(
                                        color: Constant.chatBubbleGreen,
                                        fontSize: 13,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ],
                              ),
                            )
                          else
                            SizedBox(
                              height: 14,
                            ),
                          SizedBox(
                            height: 46,
                          )
                        ],
                      ),
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
              })),
    );
  }

  addFilteredQuestionListData(List<Questions> questionListData) {
    if (questionListData != null) {
      currentQuestionListData.addAll(questionListData);
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
                  },
                )));
            break;
          case Constant.QuestionLocationType:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpLocationServices(
                  question: element,
                  selectedAnswerListData: signUpOnBoardSelectedAnswersModel.selectedAnswers,
                  selectedAnswerCallBack: selectedAnswerListData,
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

  void requestService() async {
    List<LocalQuestionnaire> localQuestionnaireData =
        await SignUpOnBoardProviders.db
            .getQuestionnaire(Constant.zeroEventStep);
    if (localQuestionnaireData != null && localQuestionnaireData.length > 0) {
      signUpOnBoardSelectedAnswersModel = await welcomeOnBoardProfileBloc
          .fetchDataFromLocalDatabase(localQuestionnaireData);
    } else {
      welcomeOnBoardProfileBloc.fetchSignUpFirstStepData();
    }
  }

  void getCurrentUserPosition() async {
    UserProgressDataModel userProgressModel =
        await SignUpOnBoardProviders.db.getUserProgress();
    if (userProgressModel != null &&
        userProgressModel.step == Constant.zeroEventStep) {
      currentScreenPosition = userProgressModel.userScreenPosition;
      print(userProgressModel);
    }
    getCurrentQuestionTag(currentScreenPosition);
    requestService();
  }

  void getCurrentQuestionTag(int currentPageIndex) async {
    var isDataBaseExists = await SignUpOnBoardProviders.db.isDatabaseExist();
    UserProgressDataModel userProgressDataModel = UserProgressDataModel();

    if (!isDataBaseExists) {
      userProgressDataModel =
          await welcomeOnBoardProfileBloc.fetchSignUpFirstStepData();
    } else {
      int userProgressDataCount = await SignUpOnBoardProviders.db
          .checkUserProgressDataAvailable(
              SignUpOnBoardProviders.TABLE_USER_PROGRESS);
      userProgressDataModel.userId = Constant.userID;
      userProgressDataModel.step = Constant.zeroEventStep;
      userProgressDataModel.userScreenPosition = currentPageIndex;
      userProgressDataModel.questionTag =
      (currentQuestionListData.length > 0) ? currentQuestionListData[currentPageIndex].tag : '';

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
        .updateSelectedAnswers(signUpOnBoardSelectedAnswersModel, Constant.zeroEventStep);
  }
}
