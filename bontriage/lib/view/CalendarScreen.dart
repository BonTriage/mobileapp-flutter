import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CalendarIntensityScreen.dart';
import 'package:mobile/view/slide_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CalendarTriggersScreen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  PageController _pageController;
  List<Widget> pageViewWidgetList;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
    pageViewWidgetList = [Container()];
  }

  @override
  void didUpdateWidget(CalendarScreen oldWidget) {
    // TODO: implement didUpdateWidget
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (currentIndex == 1) {
                      setState(() {
                        currentIndex = currentIndex - 1;
                        _pageController.animateToPage(currentIndex,
                            duration: Duration(microseconds: 300),
                            curve: Curves.easeIn);
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Constant.backgroundColor.withOpacity(0.85),
                    child: Image(
                      image: AssetImage(Constant.calenderBackArrow),
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  currentIndex == 0 ? 'Triggers' : 'Intensity',
                  style: TextStyle(
                      color: Constant.locationServiceGreen,
                      fontSize: 18,
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
                    radius: 15,
                    backgroundColor: Constant.backgroundColor.withOpacity(0.85),
                    child: Image(
                      image: AssetImage(Constant.calenderNextArrow),
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideDots(isActive: currentIndex == 0),
                SlideDots(isActive: currentIndex == 1)
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
       pageViewWidgetList = [CalendarTriggersScreen(), CalendarIntensityScreen()];
     });
    }
  }
}
