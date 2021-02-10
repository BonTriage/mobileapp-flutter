import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsTrendsScreenBloc.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/NetworkErrorScreen.dart';
import 'package:mobile/view/TrendsDisabilityScreen.dart';
import 'package:mobile/view/TrendsDurationScreen.dart';
import 'package:mobile/view/TrendsFrequencyScreen.dart';
import 'package:mobile/view/TrendsIntensityScreen.dart';
import 'package:mobile/view/slide_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendsScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Future<dynamic> Function(String,dynamic) openActionSheetCallback;

  const TrendsScreen(
      {Key key, this.showApiLoaderCallback, this.navigateToOtherScreenCallback, this.openActionSheetCallback})
      : super(key: key);

  @override
  _TrendsScreenState createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  PageController _pageController;
  List<Widget> pageViewWidgetList;
  int currentIndex = 0;
  RecordsTrendsScreenBloc _recordsTrendsScreenBloc;
  String selectedHeadacheName;
  RecordsTrendsDataModel recordsTrendsDataModel;
  DateTime _dateTime;
  int currentMonth;
  int currentYear;
  int totalDaysInCurrentMonth;
  String firstDayOfTheCurrentMonth;
  String lastDayOfTheCurrentMonth;

  var lastSelectedHeadacheName;

  @override
  void initState() {
    super.initState();
    recordsTrendsDataModel = RecordsTrendsDataModel();
    _recordsTrendsScreenBloc = RecordsTrendsScreenBloc();
    _pageController = PageController(initialPage: 0);
    pageViewWidgetList = [Container()];
    _dateTime = DateTime.now();
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(currentMonth, currentYear);
    firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, 1);
    lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, totalDaysInCurrentMonth);
  }

  @override
  void didUpdateWidget(TrendsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    requestService(firstDayOfTheCurrentMonth,lastDayOfTheCurrentMonth,selectedHeadacheName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<dynamic>(
            stream: _recordsTrendsScreenBloc.recordsTrendsDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == Constant.noHeadacheData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      Text(
                          'You didn\'t add any headache yet. So please\nadd any headache to see your Compass data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.3,
                              fontSize: 18,
                              fontFamily: Constant.jostRegular,
                              color: Constant.chatBubbleGreen)),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BouncingWidget(
                            onPressed: () {
                              navigateToHeadacheStartScreen();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 7),
                              decoration: BoxDecoration(
                                color: Constant.chatBubbleGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Add Headache',
                                  style: TextStyle(
                                      color: Constant.bubbleChatTextView,
                                      fontSize: 15,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  recordsTrendsDataModel = snapshot.data;
                  getCurrentPositionOfTabBar();
                  if (selectedHeadacheName == null) {
                    List<HeadacheListDataModel> headacheListModelData =   snapshot.data.headacheListModelData;
                    selectedHeadacheName = headacheListModelData[0].text;
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _openHeadacheTypeActionSheet(
                              snapshot.data.headacheListModelData);
                        },
                        child: Text(
                          selectedHeadacheName,
                          style: TextStyle(
                              color: Constant.locationServiceGreen,
                              fontSize: 16,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  Constant.backgroundColor.withOpacity(0.85),
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
                              backgroundColor:
                                  Constant.backgroundColor.withOpacity(0.85),
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
                  );
                }
              } else if (snapshot.hasError) {
                Utils.closeApiLoaderDialog(context);
                return NetworkErrorScreen(
                  errorMessage: snapshot.error.toString(),
                  tapToRetryFunction: () {
                    Utils.showApiLoaderDialog(context);
                    /* requestService(firstDayOfTheCurrentMonth,
                      lastDayOfTheCurrentMonth, selectedHeadacheName);*/
                  },
                );
              } else {
                return Container();
              }
            }),
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
          TrendsIntensityScreen(recordsTrendsDataModel: recordsTrendsDataModel),
          TrendsDisabilityScreen(recordsTrendsDataModel: recordsTrendsDataModel),
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

  void requestService(String firstDayOfTheCurrentMonth ,String lastDayOfTheCurrentMonth,String selectedHeadacheName) async {
    _recordsTrendsScreenBloc.fetchAllHeadacheListData(
            firstDayOfTheCurrentMonth,
            lastDayOfTheCurrentMonth,
            selectedHeadacheName);

  }

  void navigateToHeadacheStartScreen() async {
    // await widget.navigateToOtherScreenCallback(Constant.headacheStartedScreenRouter, null);
  }

  void _openHeadacheTypeActionSheet(
      List<HeadacheListDataModel> headacheListData) async {
    if (lastSelectedHeadacheName != null) {
      var lastSelectedHeadacheNameData = headacheListData.firstWhere(
              (element) => element.text == lastSelectedHeadacheName,
          orElse: () => null);
      if (lastSelectedHeadacheNameData != null) {
        lastSelectedHeadacheNameData.isSelected = true;
      }
    }
    var resultFromActionSheet = await widget.openActionSheetCallback(
        Constant.compassHeadacheTypeActionSheet, headacheListData);
    lastSelectedHeadacheName = resultFromActionSheet;
    if (resultFromActionSheet != null) {
      selectedHeadacheName = resultFromActionSheet.toString();
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName);
      print(resultFromActionSheet);
    }
  }
}