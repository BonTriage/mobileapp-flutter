import 'dart:io';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/UserGenerateReportBloc.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreGenerateReportScreen extends StatefulWidget {
  final Function(BuildContext, String, dynamic) onPush;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;

  const MoreGenerateReportScreen(
      {Key key, this.onPush, this.openActionSheetCallback})
      : super(key: key);

  @override
  _MoreGenerateReportScreenState createState() =>
      _MoreGenerateReportScreenState();
}

class _MoreGenerateReportScreenState extends State<MoreGenerateReportScreen> {
  String _dateRangeSelected;
  DateTime _startDateTime;
  DateTime _endDateTime;
  UserGenerateReportBloc _userGenerateReportBloc;
  int _totalDaysInCurrentMonth;

  @override
  void initState() {
    super.initState();
    _startDateTime = DateTime.now();

    _userGenerateReportBloc = UserGenerateReportBloc();
    //_dateRangeSelected = Constant.last2Weeks;

    _startDateTime = DateTime(_startDateTime.year, _startDateTime.month, 1);

    _totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(_startDateTime.month, _startDateTime.month);

    _endDateTime = DateTime(_startDateTime.year, _startDateTime.month, _totalDaysInCurrentMonth);

    _dateRangeSelected = '${Utils.getShortMonthName(_startDateTime.month)}, ${_startDateTime.year}';

    /*_startDateTime = DateTime.now();
    _endDateTime = _startDateTime.subtract(Duration(days: 13));*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Constant.moreBackgroundColor,
                          ),
                          child: Row(
                            children: [
                              Image(
                                width: 16,
                                height: 16,
                                image: AssetImage(Constant.leftArrow),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Constant.generateReport,
                                style: TextStyle(
                                    color: Constant.locationServiceGreen,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constant.moreBackgroundColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MoreSection(
                              currentTag: Constant.dateRange,
                              text: Constant.dateRange,
                              moreStatus: _dateRangeSelected,
                              isShowDivider: false,
                              navigateToOtherScreenCallback: _openDateRangeActionSheet,
                            ),
                            /*MoreSection(
                                text: Constant.dataToInclude,
                                moreStatus: Constant.all,
                                isShowDivider: false,
                              ),
                              MoreSection(
                                text: Constant.fileType,
                                moreStatus: Constant.pdf,
                                isShowDivider: false,
                              ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BouncingWidget(
                        onPressed: () {
                          _checkStoragePermission().then((isPermissionGranted) {
                            if(isPermissionGranted) {
                              _userGenerateReportBloc.inItNetworkStream();
                              Utils.showApiLoaderDialog(context,
                                  networkStream: _userGenerateReportBloc.userGenerateReportDataStream,
                                  tapToRetryFunction: () {
                                    _userGenerateReportBloc.enterSomeDummyDataToStreamController();
                                    getUserReport();
                                  });
                              getUserReport();
                            } else {
                              print('Please allow the storage permission before use');
                            }
                          });
                          // widget.openActionSheetCallback(Constant.generateReportActionSheet, null);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Constant.chatBubbleGreen),
                          child: Text(
                            Constant.generateReport,
                            style: TextStyle(
                              fontSize: 14,
                              color: Constant.bubbleChatTextView,
                              fontFamily: Constant.jostMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDateRangeActionSheet(String actionSheetIdentifier, dynamic argument) async {
    print('GenerateReportStartTime????$_startDateTime');
    var resultFromActionSheet = await widget.openActionSheetCallback(
        Constant.dateRangeActionSheet, _startDateTime);
    /*if (resultFromActionSheet != null && resultFromActionSheet is String) {
      switch (resultFromActionSheet) {
        case Constant.last2Weeks:
          _startDateTime = DateTime.now();
          _endDateTime = _startDateTime.subtract(Duration(days: 13));
          break;
        case Constant.last4Weeks:
          _startDateTime = DateTime.now();
          _endDateTime = _startDateTime.subtract(Duration(days: 27));
          break;
        case Constant.last2Months:
          _startDateTime = DateTime.now();
          _endDateTime = _startDateTime.subtract(Duration(days: 59));
          break;
        case Constant.last3Months:
          _startDateTime = DateTime.now();
          _endDateTime = _startDateTime.subtract(Duration(days: 89));
          break;
        default:
          _startDateTime = DateTime.now();
          _endDateTime = _startDateTime.subtract(Duration(days: 13));
      }
      setState(() {
        _dateRangeSelected = resultFromActionSheet;
      });
      //getUserReport();
    }*/
    if(resultFromActionSheet != null && resultFromActionSheet is DateTime) {
      _startDateTime = DateTime(resultFromActionSheet.year, resultFromActionSheet.month, 1);

      _totalDaysInCurrentMonth =
          Utils.daysInCurrentMonth(resultFromActionSheet.month, resultFromActionSheet.month);

      _endDateTime = DateTime(_startDateTime.year, _startDateTime.month, _totalDaysInCurrentMonth);

      setState(() {
        _dateRangeSelected = '${Utils.getShortMonthName(_startDateTime.month)}, ${_startDateTime.year}';
      });
    }
  }

  ///Method to navigate to pdf screen
  void _navigateToPdfScreen(String base64String) {
    widget.onPush(context, TabNavigatorRoutes.pdfScreenRoute, base64String);
  }

//$year-$month-${date}T$hour:$minute:${second}Z
  void getUserReport() async {
    /*var responseData = await _userGenerateReportBloc.getUserGenerateReportData(
        '${_endDateTime.year}-${_endDateTime.month}-${_endDateTime.day}T00:00:00Z',
        '${_startDateTime.year}-${_startDateTime.month}-${_startDateTime.day}T00:00:00Z');*/
    var responseData = await _userGenerateReportBloc.getUserGenerateReportData(
        '${_startDateTime.year}-${_startDateTime.month}-${_startDateTime.day}T00:00:00Z',
        '${_endDateTime.year}-${_endDateTime.month}-${_endDateTime.day}T00:00:00Z');
    print(responseData);
    if (responseData != null && responseData is String && responseData.isNotEmpty) {
      _navigateToPdfScreen(responseData);
    }
  }

  ///Method to get permission of the storage.
  Future<bool> _checkStoragePermission() async {
    if(Platform.isAndroid) {
      return await Constant.platform.invokeMethod('getStoragePermission');
    } else {
      return true;
    }
  }
}
