import 'package:flutter/material.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/on_board_bottom_buttons.dart';
import 'package:mobile/view/on_board_chat_bubble.dart';
import 'package:mobile/view/on_board_select_options.dart';
import 'package:mobile/view/sign_up_age_screen.dart';

class PartTwoOnBoardScreens extends StatefulWidget {
  @override
  _PartTwoOnBoardScreensState createState() => _PartTwoOnBoardScreensState();
}

class _PartTwoOnBoardScreensState extends State<PartTwoOnBoardScreens> {
  PageController _pageController = PageController(
    initialPage: 0,
  );

  int _currentPageIndex = 0;
  double _progressPercent = 0;

  List<Widget> _pageViewWidgetList;
  bool isEndOfOnBoard = false;
  
  List<String> _questionList = [
    Constant.atWhatAge,
    Constant.headacheChanged,
    Constant.howManyTimes,
    Constant.didYourHeadacheStart,
    Constant.isYourHeadache,
    Constant.separateHeadachesPerDay,
    Constant.headachesFrequentForDays,
    Constant.headachesOccurSeveralDays,
    Constant.headachesBuild,
    Constant.headacheLast,
    Constant.experienceYourHeadache,
    Constant.isYourHeadacheWorse,
    Constant.headacheStartDuring,
  ];

  void _onBackPressed() {
    setState(() {
      double stepOneProgress = 1 / _pageViewWidgetList.length;

      if (_currentPageIndex != 0) {
        _progressPercent -= stepOneProgress;
        _currentPageIndex--;
        _pageController.animateToPage(_currentPageIndex,
            duration: Duration(milliseconds: 1),
            curve: Curves.easeIn);
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

    _pageViewWidgetList = [
      SignUpAgeScreen(
        sliderValue: 3,
        sliderMinValue: 3,
        sliderMaxValue: 72,
        minText: '3',
        maxText: '72',
        labelText: Constant.yearsOld,
      ),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      SignUpAgeScreen(
        sliderValue: 0,
        sliderMinValue: 0,
        sliderMaxValue: 20,
        minText: '0',
        maxText: '20+',
        labelText: Constant.times,
      ),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.lessThanFiveMinutes),
        OnBoardSelectOptionModel(optionText: Constant.fiveToTenMinutes),
        OnBoardSelectOptionModel(optionText: Constant.tenToThirtyMinutes),
        OnBoardSelectOptionModel(optionText: Constant.moreThanThirtyMinutes),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.fewSecAtATime),
        OnBoardSelectOptionModel(optionText: Constant.fewSecUpTo20Min),
        OnBoardSelectOptionModel(optionText: Constant.moreThan20Min),
        OnBoardSelectOptionModel(optionText: Constant.moreThan3To4Hours),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.alwaysOneSide),
        OnBoardSelectOptionModel(optionText: Constant.usuallyOnOneSide),
        OnBoardSelectOptionModel(optionText: Constant.usuallyOnBothSide),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes),
        OnBoardSelectOptionModel(optionText: Constant.no),
      ],),
    ];

    _progressPercent = 1 / _pageViewWidgetList.length;
  }

  @override
  void didUpdateWidget(PartTwoOnBoardScreens oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: Constant.backgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OnBoardChatBubble(
                isEndOfOnBoard: isEndOfOnBoard,
                chatBubbleText: _questionList[_currentPageIndex],
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
                  return _pageViewWidgetList[index];
                },
              )),
              OnBoardBottomButtons(
                progressPercent: _progressPercent,
                backButtonFunction: _onBackPressed,
                nextButtonFunction: () {
                  setState(() {
                    double stepOneProgress = 1 / _pageViewWidgetList.length;

                    if (_progressPercent == 1) {
                       isEndOfOnBoard = true;
                       TextToSpeechRecognition.pauseSpeechToText(
                           true, "");
                      Navigator.pushReplacementNamed(context, Constant.onBoardHeadacheNameScreenRouter);
                      //TODO: Move to next screen
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
                  });
                },
                onBoardPart: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
