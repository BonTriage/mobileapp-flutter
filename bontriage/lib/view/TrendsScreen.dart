import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/RecordsTrendsScreenBloc.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/models/EditGraphViewFilterModel.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
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
  final Future<DateTime> Function (CupertinoDatePickerMode, Function, DateTime) openDatePickerCallback;

  const TrendsScreen(
      {Key key,
      this.showApiLoaderCallback,
      this.navigateToOtherScreenCallback,
      this.openActionSheetCallback,
      this.openDatePickerCallback})
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

  CurrentUserHeadacheModel currentUserHeadacheModel;

  var lastSelectedHeadacheName;
  List<TrendsFilterModel> behavioursListData = [];

  List<TrendsFilterModel> medicationsListData = [];

  List<TrendsFilterModel> triggersListData = [];

  String secondSelectedHeadacheName;
  bool _isInitiallyServiceHit = false;

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
    _isInitiallyServiceHit = false;
  }

  @override
  void didUpdateWidget(TrendsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('in did update widget of trends screen');
    _getUserCurrentHeadacheData();
    requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
        selectedHeadacheName, secondSelectedHeadacheName ?? Constant.blankString, secondSelectedHeadacheName != null);
  }

  @override
  void dispose() {
    _recordsTrendsScreenBloc.dispose();
    super.dispose();
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            'We noticed you didn’t log any  headache yet. So please add any headache to see your Trends data.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.3,
                                fontSize: 14,
                                fontFamily: Constant.jostRegular,
                                color: Constant.chatBubbleGreen)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BouncingWidget(
                            onPressed: () {
                              if(currentUserHeadacheModel != null && currentUserHeadacheModel.isOnGoing) {
                                _navigateToAddHeadacheScreen();
                              } else {
                                _navigateUserToHeadacheLogScreen();
                              }
                              //navigateToHeadacheStartScreen();
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
                  return Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            secondSelectedHeadacheName != null
                                ? '$selectedHeadacheName Vs $secondSelectedHeadacheName'
                                : selectedHeadacheName,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 14,
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
                                      _pageController.animateToPage(
                                          currentIndex,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn);
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Constant.backgroundColor
                                      .withOpacity(0.85),
                                  child: Image(
                                    image:
                                        AssetImage(Constant.calenderBackArrow),
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
                                      _pageController.animateToPage(
                                          currentIndex,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn);
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Constant.backgroundColor
                                      .withOpacity(0.85),
                                  child: Image(
                                    image:
                                        AssetImage(Constant.calenderNextArrow),
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
                                child: Card(
                                  elevation: 4,
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  semanticContainer: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          Constant.backgroundTransparentColor,
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
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 100),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Constant.barTutorialsTapColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  topLeft: Radius.circular(12)),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Utils.showTrendsTutorialDialog(context);
                              },
                              child: Image(
                                image: AssetImage(Constant.barQuestionMark),
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else if (snapshot.hasError) {
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
        editGraphViewFilterModel: _editGraphViewFilterModel,
        updateTrendsDataCallback: _updateTrendsData,
        openDatePickerCallback: widget.openDatePickerCallback,
      ),
      TrendsDisabilityScreen(
        editGraphViewFilterModel: _editGraphViewFilterModel,
        updateTrendsDataCallback: _updateTrendsData,
        openDatePickerCallback: widget.openDatePickerCallback,
      ),
      TrendsFrequencyScreen(
        editGraphViewFilterModel: _editGraphViewFilterModel,
        updateTrendsDataCallback: _updateTrendsData,
        openDatePickerCallback: widget.openDatePickerCallback,
      ),
      TrendsDurationScreen(editGraphViewFilterModel: _editGraphViewFilterModel,updateTrendsDataCallback: _updateTrendsData, openDatePickerCallback: widget.openDatePickerCallback,),
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

  void requestService(
      String firstDayOfTheCurrentMonth,
      String lastDayOfTheCurrentMonth,
      String selectedHeadacheName,
      String selectedAnotherHeadacheName,
      bool isMultipleHeadacheSelected) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    int recordTabBarPosition = sharedPreferences.getInt(Constant.recordTabNavigatorState);
    String isSeeMoreClicked = sharedPreferences.getString(Constant.isSeeMoreClicked) ?? Constant.blankString;
    String updateTrendsData = sharedPreferences.getString(Constant.updateTrendsData) ?? Constant.blankString;

    print(_isInitiallyServiceHit);

    print(isSeeMoreClicked);

    if(!_isInitiallyServiceHit && currentPositionOfTabBar == 1 && recordTabBarPosition == 2 && isSeeMoreClicked.isEmpty) {
      sharedPreferences.remove(Constant.updateTrendsData);
      _isInitiallyServiceHit = true;
      _recordsTrendsScreenBloc.initNetworkStreamController();
      print('show api loader 16');
      widget.showApiLoaderCallback(_recordsTrendsScreenBloc.networkDataStream,
              () {
            _recordsTrendsScreenBloc.enterSomeDummyDataToStream();
            _recordsTrendsScreenBloc.fetchAllHeadacheListData(
                firstDayOfTheCurrentMonth,
                lastDayOfTheCurrentMonth,
                selectedHeadacheName,
                selectedAnotherHeadacheName,
                isMultipleHeadacheSelected);
          });
      print(
          'Start Day: $firstDayOfTheCurrentMonth ????? LastDay: $lastDayOfTheCurrentMonth');
      _recordsTrendsScreenBloc.fetchAllHeadacheListData(
          firstDayOfTheCurrentMonth,
          lastDayOfTheCurrentMonth,
          selectedHeadacheName,
          selectedAnotherHeadacheName,
          isMultipleHeadacheSelected);
    } else if (currentPositionOfTabBar == 1 && recordTabBarPosition == 2 && isSeeMoreClicked.isEmpty && updateTrendsData == Constant.trueString) {
      sharedPreferences.remove(Constant.updateTrendsData);
      _recordsTrendsScreenBloc.initNetworkStreamController();
      print('show api loader 15');
      widget.showApiLoaderCallback(_recordsTrendsScreenBloc.networkDataStream,
          () {
        _recordsTrendsScreenBloc.enterSomeDummyDataToStream();
        _recordsTrendsScreenBloc.fetchAllHeadacheListData(
            firstDayOfTheCurrentMonth,
            lastDayOfTheCurrentMonth,
            selectedHeadacheName,
            selectedAnotherHeadacheName,
            isMultipleHeadacheSelected);
      });
      print(
          'Start Day: $firstDayOfTheCurrentMonth ????? LastDay: $lastDayOfTheCurrentMonth');
      _recordsTrendsScreenBloc.fetchAllHeadacheListData(
          firstDayOfTheCurrentMonth,
          lastDayOfTheCurrentMonth,
          selectedHeadacheName,
          selectedAnotherHeadacheName,
          isMultipleHeadacheSelected);
    }
  }

  void navigateToHeadacheStartScreen() async {
     await widget.navigateToOtherScreenCallback(Constant.headacheStartedScreenRouter, null);
  }

  void openEditGraphViewBottomSheet() async {
    var resultFromActionSheet = await widget.openActionSheetCallback(
        Constant.editGraphViewBottomSheet, _editGraphViewFilterModel);
    if (resultFromActionSheet == Constant.success) {
      _isInitiallyServiceHit = false;
      if (_editGraphViewFilterModel.headacheTypeRadioButtonSelected ==
          Constant.viewSingleHeadache) {
        secondSelectedHeadacheName = null;
        selectedHeadacheName =
            _editGraphViewFilterModel.singleTypeHeadacheSelected;
        _pageController.animateToPage(_editGraphViewFilterModel.currentTabIndex,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        secondSelectedHeadacheName = null;

        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
            selectedHeadacheName, '', false);
      } else {
        selectedHeadacheName = _editGraphViewFilterModel.compareHeadacheTypeSelected1;
        secondSelectedHeadacheName = _editGraphViewFilterModel.compareHeadacheTypeSelected2;
        _pageController.animateToPage(_editGraphViewFilterModel.currentTabIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth, selectedHeadacheName, secondSelectedHeadacheName, true);
      }
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
        dataElement.medication.forEach((medicationDataElement) {
          var medicationDotName = medicationsListData.firstWhere(
                  (element) => element.dotName == medicationDataElement,
              orElse: () => null);
          if (medicationDotName == null) {
            medicationsListData.add(TrendsFilterModel(
                dotName: medicationDataElement,
                occurringDateList: [medicationElement.date],
                numberOfOccurrence: 1));
          } else {
            medicationDotName.occurringDateList.add(medicationElement.date);
            medicationDotName.numberOfOccurrence++;
          }
        });
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

  void _updateTrendsData() async {
    _isInitiallyServiceHit = false;
    _dateTime = _editGraphViewFilterModel.selectedDateTime;
    currentMonth = _dateTime.month;
    currentYear = _dateTime.year;
    totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(currentMonth, currentYear);
    firstDayOfTheCurrentMonth = Utils.firstDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, 1);
    lastDayOfTheCurrentMonth = Utils.lastDateWithCurrentMonthAndTimeInUTC(
        currentMonth, currentYear, totalDaysInCurrentMonth);
    if (_editGraphViewFilterModel.headacheTypeRadioButtonSelected ==
        Constant.viewSingleHeadache) {
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName, '', false);
    } else {
      requestService(firstDayOfTheCurrentMonth, lastDayOfTheCurrentMonth,
          selectedHeadacheName, secondSelectedHeadacheName, true);
    }
  }

  void _navigateToAddHeadacheScreen() async{
    DateTime currentDateTime = DateTime.now();
    DateTime endHeadacheDateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, currentDateTime.hour, currentDateTime.minute, 0, 0, 0);

    currentUserHeadacheModel.selectedEndDate = Utils.getDateTimeInUtcFormat(endHeadacheDateTime);

    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);

    currentUserHeadacheModel.isOnGoing = false;
    currentUserHeadacheModel.selectedEndDate =  Utils.getDateTimeInUtcFormat(endHeadacheDateTime);

    await widget.navigateToOtherScreenCallback(Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    _getUserCurrentHeadacheData();
  }

  void _navigateUserToHeadacheLogScreen() async {
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if (userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);

    if (currentUserHeadacheModel == null) {
      await widget.navigateToOtherScreenCallback(Constant.headacheStartedScreenRouter, null);
    }
    else {
      if(currentUserHeadacheModel.isOnGoing) {
        await widget.navigateToOtherScreenCallback(Constant.currentHeadacheProgressScreenRouter, null);
      } else
        await widget.navigateToOtherScreenCallback(Constant.addHeadacheOnGoingScreenRouter, currentUserHeadacheModel);
    }
    _getUserCurrentHeadacheData();
  }

  Future<void> _getUserCurrentHeadacheData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int currentPositionOfTabBar = sharedPreferences.getInt(Constant.currentIndexOfTabBar);
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    if(currentPositionOfTabBar == 1 && userProfileInfoData != null) {
      currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);
    }
  }
}
