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
    SignUpHeadacheAnswerListModel(answerData: 'Red wine'),
    SignUpHeadacheAnswerListModel(answerData: 'Bright lights'),
    SignUpHeadacheAnswerListModel(answerData: 'High humidity'),
    SignUpHeadacheAnswerListModel(answerData: 'Dust & dander'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 5'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10')
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel1 = [
    SignUpHeadacheAnswerListModel(answerData: 'Asprin'),
    SignUpHeadacheAnswerListModel(answerData: 'Eletriptan'),
    SignUpHeadacheAnswerListModel(answerData: 'Excederin'),
    SignUpHeadacheAnswerListModel(answerData: 'Almotriptan'),
    SignUpHeadacheAnswerListModel(answerData: 'Dexmethasone'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10')
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel2 = [
    SignUpHeadacheAnswerListModel(answerData: 'Answer 1'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 2'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 3'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 4'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 5'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10')
  ];
  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel3 = [
    SignUpHeadacheAnswerListModel(answerData: 'Answer 1'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 2'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 3'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 4'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 5'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 6'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 7'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 8'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 9'),
    SignUpHeadacheAnswerListModel(answerData: 'Answer 10')
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
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
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
                        duration: Duration(milliseconds: 1),
                        curve: Curves.easeIn);
                  }
                });
              },
              nextButtonFunction: () {
                setState(() {
                  double stepOneProgress = 1 / _pageViewWidgetList.length;

                  if (_progressPercent == 1) {
                    Navigator.pushReplacementNamed(
                        context, Constant.postPartThreeOnBoardRouter);
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
