import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CalendarIntensityScreen.dart';
import 'package:mobile/view/slide_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CalendarTriggersScreen.dart';

class CalendarScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;

  const CalendarScreen({Key key, this.showApiLoaderCallback,this.navigateToOtherScreenCallback}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  PageController _pageController;
  List<Widget> pageViewWidgetList;
  int currentIndex = 0;

  StreamController<dynamic> _refreshCalendarDataStreamController;

  StreamSink<dynamic> get refreshCalendarDataSink =>
      _refreshCalendarDataStreamController.sink;

  Stream<dynamic> get refreshCalendarDataStream =>
      _refreshCalendarDataStreamController.stream;

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
    _refreshCalendarDataStreamController = StreamController<dynamic>.broadcast();
    _initPageViewStreamController = StreamController<dynamic>();
  }

  @override
  void didUpdateWidget(CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getCurrentPositionOfTabBar();
    print('in did update widget calendar screen');
  }

  @override
  void dispose() {
    _refreshCalendarDataStreamController?.close();
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
                  currentIndex == 0 ? 'Triggers' : 'Intensity',
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
            SizedBox(height: 10,),
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
              )/*PageView.builder(
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
    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    if (currentPositionOfTabBar == 1 && pageViewWidgetList.length != 2) {
     //setState(() {
       pageViewWidgetList = [
         CalendarTriggersScreen(showApiLoaderCallback: widget.showApiLoaderCallback,navigateToOtherScreenCallback:widget.navigateToOtherScreenCallback, refreshCalendarDataStream: refreshCalendarDataStream, refreshCalendarDataSink: refreshCalendarDataSink,),
         CalendarIntensityScreen(showApiLoaderCallback: widget.showApiLoaderCallback,navigateToOtherScreenCallback:widget.navigateToOtherScreenCallback, refreshCalendarDataStream: refreshCalendarDataStream, refreshCalendarDataSink: refreshCalendarDataSink,),
       ];
     //});
      initPageViewSink.add('data');
    }
  }
}
