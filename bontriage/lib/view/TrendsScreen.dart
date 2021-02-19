import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsTrendsScreenBloc.dart';
import 'package:mobile/models/EditGraphViewFilterModel.dart';
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
import 'package:mobile/models/TrendsFilterModel.dart';

class TrendsScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;

  const TrendsScreen(
      {Key key,
      this.showApiLoaderCallback,
      this.navigateToOtherScreenCallback,
      this.openActionSheetCallback})
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
  EditGraphViewFilterModel _editGraphViewFilterModel;

  var lastSelectedHeadacheName;
  List<TrendsFilterModel> behavioursListData = [];

  List<TrendsFilterModel> medicationsListData = [];

  List<TrendsFilterModel> triggersListData = [];

  @override
  void initState() {
    super.initState();
    recordsTrendsDataModel = RecordsTrendsDataModel();
    _recordsTrendsScreenBloc = RecordsTrendsScreenBloc();
    _pageController = PageController(initialPage: 0);
    pageViewWidgetList = [Container()];

    _editGraphViewFilterModel = EditGraphViewFilterModel();
    _editGraphViewFilterModel.selectedDateTime = DateTime.now();
    _dateTime = _editGraphViewFilterModel.selectedDateTime;
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
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
        selectedHeadacheName);
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
                  if (selectedHeadacheName == null) {
                    List<HeadacheListDataModel> headacheListModelData =
                        snapshot.data.headacheListModelData;
                    selectedHeadacheName = headacheListModelData[0].text;
                  }
                  getDotsFilterListData();
                  getCurrentPositionOfTabBar();
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        selectedHeadacheName,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 16,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (currentIndex != 0) {
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
                              if (currentIndex != 3) {
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
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              openEditGraphViewBottomSheet();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Constant.backgroundTransparentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Edit graph view',
                                style: TextStyle(
                                    color: Constant.locationServiceGreen,
                                    fontSize: 12,
                                    fontFamily: Constant.jostRegular),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Constant.backgroundColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    topLeft: Radius.circular(12)),
                              ),
                              child: Image(
                                image: AssetImage(Constant.barGraph),
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                          /*Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Constant.backgroundTransparentColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: Image(
                    image: AssetImage(Constant.lineGraph),
                    width: 15,
                    height: 15,
                  ),
                ),*/
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
                            print('trends set state 2');
                            setState(() {
                              currentIndex = index;
                              _editGraphViewFilterModel.currentTabIndex =
                                  currentIndex;
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
    _editGraphViewFilterModel.recordsTrendsDataModel = recordsTrendsDataModel;
    if (_editGraphViewFilterModel.singleTypeHeadacheSelected == null) {
      String headacheName =
          recordsTrendsDataModel.headacheListModelData[0].text;
      _editGraphViewFilterModel
        ..singleTypeHeadacheSelected = headacheName
        ..compareHeadacheTypeSelected1 = headacheName
        ..compareHeadacheTypeSelected2 = headacheName;
    }
    pageViewWidgetList = [
      TrendsIntensityScreen(
          editGraphViewFilterModel: _editGraphViewFilterModel, updateTrendsDataCallback: _updateTrendsData,),
      TrendsDisabilityScreen(
          editGraphViewFilterModel: _editGraphViewFilterModel, updateTrendsDataCallback: _updateTrendsData,),
      TrendsFrequencyScreen(
          editGraphViewFilterModel: _editGraphViewFilterModel, updateTrendsDataCallback: _updateTrendsData,),
      TrendsDurationScreen(editGraphViewFilterModel: _editGraphViewFilterModel),
    ];
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

  void requestService(String firstDayOfTheCurrentMonth,
      String lastDayOfTheCurrentMonth, String selectedHeadacheName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar =
        sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    int recordTabBarPosition =
        sharedPreferences.getInt(Constant.recordTabNavigatorState);

    if (currentPositionOfTabBar == 1 && recordTabBarPosition == 2) {
      _recordsTrendsScreenBloc.initNetworkStreamController();
      widget.showApiLoaderCallback(_recordsTrendsScreenBloc.networkDataStream,
          () {
        _recordsTrendsScreenBloc.enterSomeDummyDataToStream();
        _recordsTrendsScreenBloc.fetchAllHeadacheListData(
            firstDayOfTheCurrentMonth,
            lastDayOfTheCurrentMonth,
            selectedHeadacheName);
      });
      print('Start Day: $firstDayOfTheCurrentMonth ????? LastDay: $lastDayOfTheCurrentMonth');
      _recordsTrendsScreenBloc.fetchAllHeadacheListData(
          firstDayOfTheCurrentMonth,
          lastDayOfTheCurrentMonth,
          selectedHeadacheName);
    }
  }

  void navigateToHeadacheStartScreen() async {
    // await widget.navigateToOtherScreenCallback(Constant.headacheStartedScreenRouter, null);
  }

  void openEditGraphViewBottomSheet() async {
    var resultFromActionSheet = await widget.openActionSheetCallback(
        Constant.editGraphViewBottomSheet, _editGraphViewFilterModel);
    if (resultFromActionSheet == Constant.success) {
/*      if (_editGraphViewFilterModel.headacheTypeRadioButtonSelected ==
          Constant.viewSingleHeadache) {*/
        selectedHeadacheName =
            _editGraphViewFilterModel.singleTypeHeadacheSelected;
        _pageController.animateToPage(_editGraphViewFilterModel.currentTabIndex,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);

        //Constant.noneRadioButtonText,
        // Constant.loggedBehaviors,
        // Constant.loggedPotentialTriggers,
        // Constant.medications,

        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
            selectedHeadacheName);
     // }
    }
    print(resultFromActionSheet);
  }

  void getDotsFilterListData() {
    triggersListData = [];
    medicationsListData = [];
    behavioursListData = [];
    _editGraphViewFilterModel.trendsFilterListModel = TrendsFilterListModel();
    _editGraphViewFilterModel.trendsFilterListModel.triggersListData = [];
    _editGraphViewFilterModel.trendsFilterListModel.medicationListData = [];
    _editGraphViewFilterModel.trendsFilterListModel.behavioursListData = [];

    behavioursListData
        .add(TrendsFilterModel(dotName: 'Exercise', occurringDateList: []));
    behavioursListData
        .add(TrendsFilterModel(dotName: 'Reg. meals', occurringDateList: []));
    behavioursListData
        .add(TrendsFilterModel(dotName: 'Good sleep', occurringDateList: []));

    recordsTrendsDataModel.behaviors.forEach((behavioursElement) {
      behavioursElement.data.forEach((dataElement) {
        if (dataElement.behaviorPreexercise == 'Yes') {
          behavioursListData[0].occurringDateList.add(behavioursElement.date);
        } else if (dataElement.behaviorPremeal == 'Yes') {
          behavioursListData[1].occurringDateList.add(behavioursElement.date);
        } else if (dataElement.behaviorPresleep == 'Yes') {
          behavioursListData[2].occurringDateList.add(behavioursElement.date);
        }
      });
    });

    recordsTrendsDataModel.triggers.forEach((triggersElement) {
      triggersElement.data.forEach((dataElement) {
        dataElement.triggers1.forEach((triggers1Element) {
          var triggersDotName = triggersListData.firstWhere(
              (element) => element.dotName == triggers1Element,
              orElse: () => null);
          if (triggersDotName == null) {
            triggersListData.add(TrendsFilterModel(
                dotName: triggers1Element,
                occurringDateList: [triggersElement.date],
                numberOfOccurrence: 1));
          } else {
            triggersDotName.occurringDateList.add(triggersElement.date);
            triggersDotName.numberOfOccurrence++;
          }
        });
      });
    });

    triggersListData
        .sort((a, b) => b.numberOfOccurrence.compareTo(a.numberOfOccurrence));

    print('TriggersListData $triggersListData');

    recordsTrendsDataModel.medication.forEach((medicationElement) {
      medicationElement.data.forEach((dataElement) {
        var medicationDotName = medicationsListData.firstWhere(
            (element) => element.dotName == dataElement.medication,
            orElse: () => null);
        if (medicationDotName == null) {
          medicationsListData.add(TrendsFilterModel(
              dotName: dataElement.medication,
              occurringDateList: [medicationElement.date],
              numberOfOccurrence: 1));
        } else {
          medicationDotName.occurringDateList.add(medicationElement.date);
          medicationDotName.numberOfOccurrence++;
        }
      });
    });

    medicationsListData
        .sort((a, b) => b.numberOfOccurrence.compareTo(a.numberOfOccurrence));
    print('MedicationListData $triggersListData');
    _editGraphViewFilterModel.trendsFilterListModel.triggersListData =
        triggersListData;
    _editGraphViewFilterModel.trendsFilterListModel.behavioursListData =
        behavioursListData;
    _editGraphViewFilterModel.trendsFilterListModel.medicationListData =
        medicationsListData;
    print('AllModelsData $_editGraphViewFilterModel');
    _editGraphViewFilterModel.numberOfDaysInMonth = totalDaysInCurrentMonth;
  }

  void _updateTrendsData() {
    _dateTime = _editGraphViewFilterModel.selectedDateTime;
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(currentMonth, currentYear);
    firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, 1);
    lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, totalDaysInCurrentMonth);
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
        selectedHeadacheName);
  }
}
