import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CompareCompassScreen.dart';
import 'package:mobile/view/OverTimeCompassScreen.dart';
import 'package:mobile/view/slide_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompassScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Future<dynamic> Function(String,dynamic) openActionSheetCallback;

  const CompassScreen(
      {Key key, this.showApiLoaderCallback, this.navigateToOtherScreenCallback, this.openActionSheetCallback})
      : super(key: key);

  @override
  _CompassScreenState createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  PageController _pageController;
  List<Widget> pageViewWidgetList;
  int currentIndex = 0;

  StreamController<dynamic> _initPageViewStreamController;

  StreamSink<dynamic> get initPageViewSink =>
      _initPageViewStreamController.sink;

  Stream<dynamic> get initPageViewStream =>
      _initPageViewStreamController.stream;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    pageViewWidgetList = [Container()];
    _initPageViewStreamController = StreamController<dynamic>();
  }

  @override
  void didUpdateWidget(CompassScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getCurrentPositionOfTabBar();
  }

  @override
  void dispose() {
    _initPageViewStreamController?.close();
    super.dispose();
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
                            duration: Duration(milliseconds: 300),
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
                  currentIndex == 0 ? 'Over Time' : 'Compare',
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
                            duration: Duration(milliseconds: 300),
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
                SlideDots(isActive: currentIndex == 1)
              ],
            ),
            Expanded(
              child: StreamBuilder<dynamic>(
                stream: initPageViewStream,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return PageView.builder(
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
                    );
                  } else {
                    return Container();
                  }
                },
              ),/*PageView.builder(
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
              ),*/
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
    int recordTabBarPosition = 0;

    try {
      recordTabBarPosition = sharedPreferences.getInt(Constant.recordTabNavigatorState);
    } catch (e) {
      print(e);
    }
    print(currentPositionOfTabBar);
    if (currentPositionOfTabBar == 1 && recordTabBarPosition == 1) {
      /*setState(() {
        pageViewWidgetList = [
          OverTimeCompassScreen(openActionSheetCallback: widget.openActionSheetCallback, showApiLoaderCallback: widget.showApiLoaderCallback,navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,),
          CompareCompassScreen(openActionSheetCallback: widget.openActionSheetCallback, showApiLoaderCallback: widget.showApiLoaderCallback,navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,),
        ];
      });*/
      pageViewWidgetList = [
        OverTimeCompassScreen(openActionSheetCallback: widget.openActionSheetCallback, showApiLoaderCallback: widget.showApiLoaderCallback,navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,),
        CompareCompassScreen(openActionSheetCallback: widget.openActionSheetCallback, showApiLoaderCallback: widget.showApiLoaderCallback,navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,),
      ];
      initPageViewSink.add('Data');
    }
  }
}
