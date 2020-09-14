import 'package:flutter/material.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
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
            duration: Duration(milliseconds: 250),
            curve: Curves.easeIn);
      }
    });
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
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
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
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.lessThanFiveMinutes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.fiveToTenMinutes, isSelected: false),
        OnBoardSelectOptionModel(optionText: Constant.tenToThirtyMinutes, isSelected: false),
        OnBoardSelectOptionModel(optionText: Constant.moreThanThirtyMinutes, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.fewSecAtATime, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.fewSecUpTo20Min, isSelected: false),
        OnBoardSelectOptionModel(optionText: Constant.moreThan20Min, isSelected: false),
        OnBoardSelectOptionModel(optionText: Constant.moreThan3To4Hours, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.alwaysOneSide, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.usuallyOnOneSide, isSelected: false),
        OnBoardSelectOptionModel(optionText: Constant.usuallyOnBothSide, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
      OnBoardSelectOptions(selectOptionList: [
        OnBoardSelectOptionModel(optionText: Constant.yes, isSelected: true),
        OnBoardSelectOptionModel(optionText: Constant.no, isSelected: false),
      ],),
    ];

    _progressPercent = 1 / _pageViewWidgetList.length;
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
                      Navigator.pushReplacementNamed(context, Constant.partThreeOnBoardScreenRouter);
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
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic);
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
