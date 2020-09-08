import 'package:flutter/material.dart';
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
    Constant.atWhatAge
  ];

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
        Constant.yes,
        Constant.no
      ],),
      SignUpAgeScreen(
        sliderValue: 0,
        sliderMinValue: 0,
        sliderMaxValue: 20,
        minText: '0',
        maxText: '20+',
        labelText: Constant.yearsOld,
      ),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.lessThanFiveMinutes,
        Constant.fiveToTenMinutes,
        Constant.tenToThirtyMinutes,
        Constant.moreThanThirtyMinutes
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.fewSecAtATime,
        Constant.fewSecUpTo20Min,
        Constant.moreThan20Min,
        Constant.moreThan3To4Hours
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.alwaysOneSide,
        Constant.usuallyOnOneSide,
        Constant.usuallyOnBothSide,
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
      OnBoardSelectOptions(selectOptionList: [
        Constant.yes,
        Constant.no
      ],),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              itemCount: _pageViewWidgetList.length,
              itemBuilder: (BuildContext context, int index) {
                return _pageViewWidgetList[index];
              },
            )),
            OnBoardBottomButtons(
              progressPercent: _progressPercent,
              backButtonFunction: () {},
              nextButtonFunction: () {setState(() {
                _progressPercent += 0.2;
              });},
              onBoardPart: 2,
            )
          ],
        ),
      ),
    );
  }
}
