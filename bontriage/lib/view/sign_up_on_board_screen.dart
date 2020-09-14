import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleLeftPointed.dart';
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

class _SignUpOnBoardScreenState extends State<SignUpOnBoardScreen> {
  bool isVolumeOn = true;
  double _progressPercent = 0;
  int _currentPageIndex = 0;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  List<Widget> _pageViewWidgetList;

  List<String> questionList = [
    Constant.firstBasics,
    Constant.whatShouldICallYou,
    Constant.howOld,
    Constant.likeToEnableLocationServices,
    Constant.howManyDays,
    Constant.howManyHours,
    Constant.onScaleOf,
    Constant.howDisabled
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageViewWidgetList = [
      Container(),
      SignUpNameScreen(),
      SignUpAgeScreen(
        sliderValue: 3,
        sliderMinValue: 3,
        sliderMaxValue: 72,
        minText: '3',
        maxText: '72',
        labelText: Constant.yearsOld,
      ),
      SignUpLocationServices(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage(Constant.closeIcon),
                        width: 26,
                        height: 26,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(Constant.userAvatar),
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image(
                        image: AssetImage(isVolumeOn
                            ? Constant.volumeOn
                            : Constant.volumeOff),
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ChatBubbleLeftPointed(
                    painter: ChatBubblePainter(Constant.oliveGreen),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        questionList[_currentPageIndex],
                        style: TextStyle(
                            fontSize: 13,fontWeight: FontWeight.bold,height: 1.5, color: Constant.chatBubbleGreen),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: PageView.builder(
              controller: _pageController,
              itemCount: _pageViewWidgetList.length,
              itemBuilder: (BuildContext context, int index) {
                return _pageViewWidgetList[index];
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPageIndex != 0)
                        BouncingWidget(
                          duration: Duration(milliseconds: 100),
                          scaleFactor: 1.5,
                          onPressed: () {
                            setState(() {
                              if (_currentPageIndex != 0) {
                                _progressPercent -= 0.14;
                                _currentPageIndex--;
                                _pageController.animateToPage(_currentPageIndex,
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeIn);
                              } else {
                                _progressPercent = 0;
                              }
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xffafd794),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                Constant.back,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontFamily: "FuturaMaxiLight",
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: 20,
                        ),
                      BouncingWidget(
                        duration: Duration(milliseconds: 100),
                        scaleFactor: 1.5,
                        onPressed: () {
                          setState(() {
                            if (_progressPercent == 1) {
                              Navigator.pushNamed(context,
                                  Constant.signUpOnBoardPersonalizedHeadacheResultRouter);
                            } else {
                                _currentPageIndex++;

                                if (_currentPageIndex !=
                                    _pageViewWidgetList.length - 1)
                                _progressPercent += 0.14;
                                else {
                                  _progressPercent = 1;
                                }

                                _pageController.animateToPage(_currentPageIndex,
                                    duration: Duration(milliseconds: 150),
                                    curve: Curves.easeIn);
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xffafd794),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              Constant.next,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: "FuturaMaxiLight",
                                  fontWeight: FontWeight.bold),
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
                    padding: EdgeInsets.symmetric(horizontal: 13),
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
                    height: 8,
                  ),
                SizedBox(
                  height: 10.5,
                ),
                if (_currentPageIndex != 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Part 1 of 3',
                          style: TextStyle(
                              color: Constant.chatBubbleGreen, fontSize: 13),
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
}
