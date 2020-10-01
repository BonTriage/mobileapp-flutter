import 'package:mobile/blocs/WelcomeOnBoardProfileBloc.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardFirstStepQuestionsModel.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
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

  List<String> questionList = [
    Constant.firstBasics,
    Constant.whatShouldICallYou,
    Constant.withWhatGender,
    Constant.whatBiologicalSex,
    Constant.howOld,
    Constant.likeToEnableLocationServices,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    welcomeOnBoardProfileBloc = WelcomeOnBoardProfileBloc();
    welcomeOnBoardProfileBloc.fetchSignUpFirstStepData();

    _pageViewWidgetList = [
      SignUpOnBoardFirstStepQuestionsModel(
          questions: Constant.firstBasics, questionsWidget: Container())
    ];

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OnBoardChatBubble(
              chatBubbleText: _pageViewWidgetList[_currentPageIndex].questions,
              isEndOfOnBoard: isEndOfOnBoard,
            ),
            SizedBox(height: 40),
            Expanded(
                child: StreamBuilder<dynamic>(
                    stream: welcomeOnBoardProfileBloc.albumDataStream,
                    builder: (context, snapshot) {
                      if (!isAlreadyDataFiltered)
                        addFilteredQuestionListData(snapshot.data);
                      return PageView.builder(
                        controller: _pageController,
                        itemCount: _pageViewWidgetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _pageViewWidgetList[index].questionsWidget;
                        },
                        physics: NeverScrollableScrollPhysics(),
                      );
                    })),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.chatBubbleHorizontalPadding),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        left: (_currentPageIndex != 0)
                            ? 0
                            : (MediaQuery.of(context).size.width - 190),
                        duration: Duration(milliseconds: 250),
                        child: AnimatedOpacity(
                          opacity: (_currentPageIndex != 0) ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 250),
                          child: BouncingWidget(
                            duration: Duration(milliseconds: 100),
                            scaleFactor: 1.5,
                            onPressed: () {
                              setState(() {
                                if (_currentPageIndex != 0) {
                                  /*isReverseAnimation = true;
                                    _animationController.reverse();*/
                                  _progressPercent -= 0.11;
                                  _currentPageIndex--;
                                  _pageController.animateToPage(
                                      _currentPageIndex,
                                      duration: Duration(milliseconds: 1),
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.back,
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
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: BouncingWidget(
                          duration: Duration(milliseconds: 100),
                          scaleFactor: 1.5,
                          onPressed: () {
                            setState(() {
                              if (_progressPercent == 0.55) {
                                isEndOfOnBoard = true;
                                TextToSpeechRecognition.pauseSpeechToText(
                                    true, "");
                                Navigator.pushReplacementNamed(context,
                                    Constant.onBoardHeadacheInfoScreenRouter);
                              } else {
                                _currentPageIndex++;

                                if (_currentPageIndex !=
                                    _pageViewWidgetList.length - 1)
                                  _progressPercent += 0.11;
                                else {
                                  _progressPercent = 0.55;
                                }

                                _pageController.animateToPage(_currentPageIndex,
                                    duration: Duration(milliseconds: 1),
                                    curve: Curves.easeIn);
                              }
                            });
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
                        horizontal: Constant.chatBubbleHorizontalPadding),
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
        ),
      ),
    );
  }

  addFilteredQuestionListData(List<Questions> questionListData) {
    if (questionListData != null) {
      questionListData.forEach((element) {

        switch (element.questionType){
          case "number":
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpAgeScreen(
                  sliderValue: element.min.toDouble(),
                  sliderMinValue: element.min.toDouble(),
                  sliderMaxValue: element.max.toDouble(),
                  minText: element.min.toString(),
                  maxText: element.max.toString(),
                  labelText: "",
                )));
            break;

          case "text":
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpNameScreen()));
            break;

          case "single":
          List<OnBoardSelectOptionModel> valuesListData;
          element.values.forEach((element) {
            valuesListData.add(OnBoardSelectOptionModel(optionId: element.valueNumber,optionText: element.text));
          });
          _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
              questions: element.helpText,
              questionsWidget: OnBoardSelectOptions(
                selectOptionList: valuesListData,
              )));
          break;
          case "location":
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpLocationServices()));
            break;
        }
   /*     switch (element.tag) {
          case Constant.profileName:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpNameScreen()));

            break;
          case Constant.profileAge:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpAgeScreen(
                  sliderValue: element.min.toDouble(),
                  sliderMinValue: element.min.toDouble(),
                  sliderMaxValue: element.max.toDouble(),
                  minText: element.min.toString(),
                  maxText: element.max.toString(),
                  labelText: Constant.yearsOld,
                )));

            break;
          case Constant.profileSex:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: OnBoardSelectOptions(
                  selectOptionList: [
                    OnBoardSelectOptionModel(optionText: Constant.woman),
                    OnBoardSelectOptionModel(optionText: Constant.man),
                    OnBoardSelectOptionModel(optionText: Constant.interSex),
                    OnBoardSelectOptionModel(
                        optionText: Constant.preferNotToAnswer)
                  ],
                )));

            break;
          case Constant.profileLocation:
            _pageViewWidgetList.add(SignUpOnBoardFirstStepQuestionsModel(
                questions: element.helpText,
                questionsWidget: SignUpLocationServices()));
            break;
        }*/
        isAlreadyDataFiltered = true;
      });
      print(questionListData);
    }
  }
}
