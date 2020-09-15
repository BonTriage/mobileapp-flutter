import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/util/constant.dart';

import 'SignUpBottomSheet.dart';
import 'on_board_bottom_buttons.dart';
import 'on_board_chat_bubble.dart';

class PartThreeOnBoardScreens extends StatefulWidget {
  @override
  _PartThreeOnBoardScreensState createState() =>
      _PartThreeOnBoardScreensState();
}

class _PartThreeOnBoardScreensState extends State<PartThreeOnBoardScreens> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentPageIndex = 0;
  double _progressPercent = 0;

  List<Widget> _pageViewWidgetList;
  List<String> _questionList = [
    Constant.suspectTriggerYourHeadache,
    Constant.followingMedications,
    Constant.followingDevices,
    Constant.followingLifeStyle,
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel = [
    SignUpHeadacheAnswerListModel(answerData: 'Red wine', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: 'Bright lights', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: 'High humidity', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: 'Dust & dander', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 5', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10', isSelected: false)
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel1 = [
    SignUpHeadacheAnswerListModel(answerData: 'Asprin', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Eletriptan', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Excederin', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Almotriptan', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: 'Dexmethasone', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10', isSelected: false)
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel2 = [
    SignUpHeadacheAnswerListModel(answerData: 'Answer 1', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 2', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 3', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 4', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 5', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10', isSelected: false)
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel3 = [
    SignUpHeadacheAnswerListModel(answerData: 'Answer 1', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 2', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 3', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 4', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 5', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10', isSelected: false)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageViewWidgetList = [
      SignUpBottomSheet(selectOptionList: signUpHeadacheAnswerListModel),
      SignUpBottomSheet(selectOptionList: signUpHeadacheAnswerListModel1),
      SignUpBottomSheet(selectOptionList: signUpHeadacheAnswerListModel2),
      SignUpBottomSheet(selectOptionList: signUpHeadacheAnswerListModel3),
    ];

    _progressPercent = 1 / _pageViewWidgetList.length;
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
              physics: NeverScrollableScrollPhysics(),
              itemCount: _pageViewWidgetList.length,
              itemBuilder: (BuildContext context, int index) {
                return _pageViewWidgetList[index];
              },
            )),
            OnBoardBottomButtons(
              progressPercent: _progressPercent,
              backButtonFunction: () {
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
              },
              nextButtonFunction: () {
                setState(() {
                  double stepOneProgress = 1 / _pageViewWidgetList.length;

                  if (_progressPercent == 1) {
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
              onBoardPart: 3,
            )
          ],
        ),
      ),
    );
  }
}
