import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'package:mobile/view/sign_up_location_services.dart';
import 'package:mobile/view/sign_up_name_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:mobile/util/constant.dart';

import 'ChatBubbleLeftPointed.dart';

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
    Constant.likeToEnableLocationServices
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageViewWidgetList = [
      Container(),
      SignUpNameScreen(),
      SignUpAgeScreen(),
      SignUpLocationServices(),
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
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
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
                        width: 50,
                        height: 50,
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
                    painter: ChatBubblePainter(Constant.chatBubbleGreenBlue),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        questionList[_currentPageIndex],
                        style: TextStyle(
                            fontSize: 16, color: Constant.chatBubbleGreen),
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
                              if (_progressPercent > 0.1) {
                                _progressPercent -= 0.11;
                              } else {
                                _progressPercent = 0;
                              }

                              if (_currentPageIndex != 0) {
                                _currentPageIndex--;
                                _pageController.animateToPage(_currentPageIndex,
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeIn);
                              }
                            });
                          },
                          child: Container(
                            width: 120,
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
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
                            if (_progressPercent < 0.9) {
                              _progressPercent += 0.1;
                            }

                            if (_currentPageIndex !=
                                _pageViewWidgetList.length - 1) {
                              _currentPageIndex++;
                              _pageController.animateToPage(_currentPageIndex,
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeIn);
                            }
                          });
                        },
                        child: Container(
                          width: 120,
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
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
                      animationDuration: 500,
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
