import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/TrendsDisabilityScreen.dart';
import 'package:mobile/view/TrendsDurationScreen.dart';
import 'package:mobile/view/TrendsFrequencyScreen.dart';
import 'package:mobile/view/TrendsIntensityScreen.dart';
import 'package:mobile/view/slide_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CompareCompassScreen.dart';
import 'OverTimeCompassScreen.dart';

class TrendsScreen extends StatefulWidget {
  @override
  _TrendsScreenState createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  PageController _pageController;
  List<Widget> pageViewWidgetList;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    pageViewWidgetList = [Container()];
  }

  @override
  void didUpdateWidget(TrendsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getCurrentPositionOfTabBar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 13),
                  decoration: BoxDecoration(
                    color: Constant.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Read about trends',
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 16,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Image(
                        image: AssetImage(Constant.upperArrow),
                        width: 15,
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'MY HEADACHE',
              style: TextStyle(
                  color: Constant.locationServiceGreen,
                  fontSize: 16,
                  fontFamily: Constant.jostRegular),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (currentIndex == 3) {
                      setState(() {
                        currentIndex = currentIndex - 1;
                        _pageController.animateToPage(currentIndex,
                            duration: Duration(microseconds: 300),
                            curve: Curves.easeIn);
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Constant.backgroundColor.withOpacity(0.85),
                    child: Image(
                      image: AssetImage(Constant.calenderBackArrow),
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  getCurrentTextView(),
                  style: TextStyle(
                      color: Constant.locationServiceGreen,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      fontFamily: Constant.jostMedium),
                ),
                SizedBox(
                  width: 60,
                ),
                GestureDetector(
                  onTap: () {
                    if (currentIndex == 0) {
                      setState(() {
                        currentIndex = currentIndex + 1;
                        _pageController.animateToPage(currentIndex,
                            duration: Duration(microseconds: 300),
                            curve: Curves.easeIn);
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Constant.backgroundColor.withOpacity(0.85),
                    child: Image(
                      image: AssetImage(Constant.calenderNextArrow),
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideDots(isActive: currentIndex == 0),
                SlideDots(isActive: currentIndex == 1),
                SlideDots(isActive: currentIndex == 2),
                SlideDots(isActive: currentIndex == 3)
              ],
            ),
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return pageViewWidgetList[index];
                },
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                reverse: false,
                itemCount: pageViewWidgetList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrentPositionOfTabBar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar =
        sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    if (currentPositionOfTabBar == 1) {
      setState(() {
        pageViewWidgetList = [
          TrendsIntensityScreen(),
          TrendsDisabilityScreen(),
          TrendsFrequencyScreen(),
          TrendsDurationScreen(),
        ];
      });
    }
  }

  String getCurrentTextView() {
    if (currentIndex == 0) {
      return 'Intensity';
    } else if (currentIndex == 1) {
      return 'Disability';
    } else if (currentIndex == 2) {
      return 'Frequency';
    } else if (currentIndex == 3) {
      return 'Duration';
    }
    return 'Intensity';
  }
}
