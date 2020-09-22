import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';

import '../util/constant.dart';
import 'on_board_bottom_buttons.dart';
import 'on_board_chat_bubble.dart';
import 'sign_up_age_screen.dart';

class PartOneOnBoardScreenTwo extends StatefulWidget {
  @override
  _PartOneOnBoardScreenStateTwo createState() =>
      _PartOneOnBoardScreenStateTwo();
}

class _PartOneOnBoardScreenStateTwo extends State<PartOneOnBoardScreenTwo> {
  PageController _pageController = PageController(
    initialPage: 0,
  );

  int _currentPageIndex = 0;
  double _progressPercent = 0.66;

  List<Widget> _pageViewWidgetList;
  bool isEndOfOnBoard = false;

  List<String> _questionList = [
    Constant.howManyDays,
    Constant.howManyHours,
    Constant.onScaleOf,
    Constant.howDisabled
  ];

  void _onBackPressed() {
    setState(() {
      double stepOneProgress = 0.14;

      if (_currentPageIndex != 0) {
        _progressPercent -= stepOneProgress;
        _currentPageIndex--;
        _pageController.animateToPage(_currentPageIndex,
            duration: Duration(milliseconds: 250), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageViewWidgetList = [
      SignUpAgeScreen(
        sliderValue: 0,
        sliderMinValue: 0,
        sliderMaxValue: 31,
        minText: '0',
        maxText: '31',
        labelText: Constant.days,
      ),
      SignUpAgeScreen(
        sliderValue: 0,
        sliderMinValue: 0,
        sliderMaxValue: 24,
        minText: '0',
        maxText: '24',
        labelText: Constant.days,
      ),
      SignUpAgeScreen(
        sliderValue: 1,
        sliderMinValue: 1,
        sliderMaxValue: 10,
        minText: '1',
        maxText: '10',
        labelText: Constant.blankString,
      ),
      SignUpAgeScreen(
        sliderValue: 0,
        sliderMinValue: 0,
        sliderMaxValue: 4,
        minText: '0',
        maxText: '4',
        labelText: Constant.blankString,
      ),
    ];
  }

  @override
  void didUpdateWidget(PartOneOnBoardScreenTwo oldWidget) {
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
                    double stepOneProgress = 0.11;

                    if (_progressPercent == 1) {
                      isEndOfOnBoard = true;
                      TextToSpeechRecognition.pauseSpeechToText(
                          true, "");
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
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic);
                    }
                  });
                },
                onBoardPart: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
