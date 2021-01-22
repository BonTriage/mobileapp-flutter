import 'package:flutter/material.dart';
import 'package:mobile/util/TutorialsSliderDots.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CustomScrollBar.dart';

class SecondStepCompassResultTutorials extends StatefulWidget {
  @override
  _SecondStepCompassResultTutorialsState createState() =>
      _SecondStepCompassResultTutorialsState();

  final int tutorialsIndex;

  const SecondStepCompassResultTutorials({Key key, this.tutorialsIndex})
      : super(key: key);
}

class _SecondStepCompassResultTutorialsState
    extends State<SecondStepCompassResultTutorials> {
  int currentPageIndex = 0;
  List<Widget> _pageViewWidgets;

  PageController _pageController;
  List<ScrollController> _scrollControllerList;

  Widget _getThreeDotsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TutorialsSliderDots(isActive: currentPageIndex == 0),
        TutorialsSliderDots(isActive: currentPageIndex == 1),
        TutorialsSliderDots(isActive: currentPageIndex == 2),
        TutorialsSliderDots(isActive: currentPageIndex == 3),
        TutorialsSliderDots(isActive: currentPageIndex == 4),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.tutorialsIndex);
    currentPageIndex = widget.tutorialsIndex;
    _pageViewWidgets = [
      Text(
        Constant.compassTextView,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constant.chatBubbleGreen,
            fontSize: 14,
            fontFamily: Constant.jostMedium),
      ),
      Text(
        Constant.compassTextView,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constant.chatBubbleGreen,
            fontSize: 14,
            fontFamily: Constant.jostMedium),
      ),
      Text(
        Constant.compassTextView,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constant.chatBubbleGreen,
            fontSize: 14,
            fontFamily: Constant.jostMedium),
      ),
      Text(
        Constant.compassTextView,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constant.chatBubbleGreen,
            fontSize: 14,
            fontFamily: Constant.jostMedium),
      ),
      Text(
        Constant.compassTextView,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constant.chatBubbleGreen,
            fontSize: 14,
            fontFamily: Constant.jostMedium),
      ),
    ];

    _scrollControllerList =
        List.generate(_pageViewWidgets.length, (index) => ScrollController());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 220, maxWidth: MediaQuery.of(context).size.width),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      tutorialTitleByIndex(),
                      style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontSize: 16,
                          fontFamily: Constant.jostMedium),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      Constant.chatBubbleHorizontalPadding, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image(
                          image: AssetImage(Constant.closeIcon),
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              width: 250,
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CustomScrollBar(
                      isAlwaysShown: true,
                      controller: _scrollControllerList[index],
                      child: SingleChildScrollView(
                        physics: Utils.getScrollPhysics(),
                        controller: _scrollControllerList[index],
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: _pageViewWidgets[index],
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(bottom: 15),
                child: _getThreeDotsWidget())
          ],
        ),
      ),
    );
  }

  String tutorialTitleByIndex() {
    switch (currentPageIndex) {
      case 0:
        return Constant.compass;
      case 1:
        return Constant.intensity;
      case 2:
        return Constant.disability;
      case 3:
        return Constant.frequency;
      case 4:
        return Constant.duration;
    }
    return "";
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _scrollControllerList.forEach((element) {
      element?.dispose();
    });
    super.dispose();
  }
}
