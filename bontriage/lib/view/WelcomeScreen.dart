import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'slide_dots.dart';
import 'WelcomePage.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}


class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentPageIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  List<Widget> _pageViewWidgets;

  Widget _getThreeDotsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideDots(isActive: currentPageIndex == 0),
        SlideDots(isActive: currentPageIndex == 1),
        SlideDots(isActive: currentPageIndex == 2),
      ],
    );
  }

  String _getButtonText() {
    if (currentPageIndex == 2)
      return Constant.getGoing;
    else
      return Constant.next;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageViewWidgets = [
      WelcomePage(
        headerText: Constant.welcomeToMigraineMentor,
        imagePath: Constant.brain,
        subText: Constant.developedByATeam,
      ),
      WelcomePage(
        headerText: Constant.trackRightData,
        imagePath: Constant.chart,
        subText: Constant.mostHeadacheTracking,
      ),
      WelcomePage(
        headerText: Constant.conquerYourHeadaches,
        imagePath: Constant.notifsGreenWhite,
        subText: Constant.withRegularUse,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: _pageViewWidgets.length,
                  controller: _pageController,
                  onPageChanged: (currentPage) {
                    setState(() {
                      currentPageIndex = currentPage;
                    });
                    print(currentPage);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return _pageViewWidgets[index];
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    _getThreeDotsWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (currentPageIndex != 2) {
                          currentPageIndex++;
                          _pageController.animateToPage(currentPageIndex,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeIn);
                        } else {
                          Navigator.pushReplacementNamed(context,
                              Constant.welcomeStartAssessmentScreenRouter);
                        }
                      },
                      child: Container(
                        width: 140,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffafd794),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _getButtonText(),
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
