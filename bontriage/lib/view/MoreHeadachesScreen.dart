import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreHeadachesBloc.dart';
import 'package:mobile/models/MoreHeadacheScreenArgumentModel.dart';
import 'package:mobile/models/PartTwoOnBoardArgumentModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserGenerateReportDataModel.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomTextWidget.dart';

class MoreHeadachesScreen extends StatefulWidget {
  final Function(BuildContext, String, dynamic) onPush;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final MoreHeadacheScreenArgumentModel moreHeadacheScreenArgumentModel;
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;

  const MoreHeadachesScreen(
      {Key key, this.onPush, this.openActionSheetCallback, this.moreHeadacheScreenArgumentModel, this.showApiLoaderCallback, this.navigateToOtherScreenCallback})
      : super(key: key);

  @override
  _MoreHeadachesScreenState createState() => _MoreHeadachesScreenState();
}

class _MoreHeadachesScreenState extends State<MoreHeadachesScreen> {

  MoreHeadacheBloc _bloc;
  int _totalDaysInCurrentMonth;


  @override
  void initState() {
    super.initState();
    _bloc = MoreHeadacheBloc();

    _listenToDeleteHeadacheStream();
    _listenToViewReportStream();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          Expanded(
                            child: CustomTextWidget(
                              text: widget.moreHeadacheScreenArgumentModel.headacheTypeData.text,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 16,
                                  fontFamily: Constant.jostRegular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        MoreSection(
                          currentTag: Constant.viewReport,
                          text: Constant.viewReport,
                          moreStatus: '',
                          isShowDivider: true,
                          viewReportClickedCallback: () {
                            _checkStoragePermission().then((value) {
                              if(value) {
                                _openDateRangeActionSheet(Constant.dateRangeActionSheet, null);
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _bloc.initNetworkStreamController();
                            widget.showApiLoaderCallback(_bloc.networkStream, () {
                              _bloc.networkSink.add(Constant.loading);
                              _getDiagnosticAnswerList();
                            });
                            _getDiagnosticAnswerList();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: Constant.reCompleteInitialAssessment,
                                style: TextStyle(
                                    color: Constant.addCustomNotificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Image(
                                    width: 16,
                                    height: 16,
                                    image: AssetImage(Constant.rightArrow),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 30,
                          color: Constant.locationServiceGreen,
                        ),
                        GestureDetector(
                          onTap: () {
                            _openDeleteHeadacheActionSheet();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: Constant.deleteHeadacheType,
                                style: TextStyle(
                                    color: Constant.pinkTriggerColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Image(
                                    width: 16,
                                    height: 16,
                                    image: AssetImage(Constant.rightArrow),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTextWidget(
                      text: _getInfoText(),
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 14,
                          fontFamily: Constant.jostMedium
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInfoText() {
    return 'Based on what you entered, it looks like your ${widget.moreHeadacheScreenArgumentModel.headacheTypeData.text} could potentially be considered by doctors to be a ${widget.moreHeadacheScreenArgumentModel.headacheTypeData.isMigraine ? 'Migraine' : 'Headache'}. This is not a diagnosis, but it is an accurate clinical impression, based on your answers, of how your headache best matches up to known headache types. If you haven’t already done so, you should see a qualified medical professional for a firm diagnosis';
  }

  void _openDeleteHeadacheActionSheet() async {
    var resultOfActionSheet = await widget.openActionSheetCallback(Constant.deleteHeadacheTypeActionSheet, null);
    if(resultOfActionSheet == Constant.deleteHeadacheType) {
      var result = await Utils.showConfirmationDialog(context, 'Are you sure want to delete this headache type?');
      if(result == 'Yes') {
        _bloc.initNetworkStreamController();
        widget.showApiLoaderCallback(_bloc.networkStream, () {
          _bloc.networkSink.add(Constant.loading);
          _bloc.callDeleteHeadacheTypeService(
              widget.moreHeadacheScreenArgumentModel.headacheTypeData
                  .valueNumber);
        });
        _bloc.callDeleteHeadacheTypeService(
            widget.moreHeadacheScreenArgumentModel.headacheTypeData
                .valueNumber);
      }
    }
  }

  void _listenToDeleteHeadacheStream() {
    _bloc.deleteHeadacheStream.listen((data) {
      if(data == 'Event Deleted') {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _getDiagnosticAnswerList() async {
    List<SelectedAnswers> selectedAnswerList = await _bloc.fetchDiagnosticAnswers(widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber);
    if(selectedAnswerList.length > 0) {
      Future.delayed(Duration(milliseconds: 500), () async {
        var eventId = await widget.navigateToOtherScreenCallback(Constant.partTwoOnBoardScreenRouter, PartTwoOnBoardArgumentModel(
          eventId: widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber,
          selectedAnswersList: selectedAnswerList,
          argumentName: Constant.clinicalImpressionEventType,
          isFromMoreScreen: true,
        ));

        print('ResultFromAssessment???$eventId');

        if(eventId != null && eventId is String) {
          /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString(Constant.updateCalendarIntensityData, Constant.trueString);*/
          widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber = eventId;
        }
      });
    }
  }

  void _openDateRangeActionSheet(String actionSheetIdentifier, dynamic argument) async {
    DateTime startDateTime, endDateTime;

    startDateTime = DateTime.now();
    startDateTime = DateTime(startDateTime.year, startDateTime.month, 1);

    _totalDaysInCurrentMonth =
        Utils.daysInCurrentMonth(startDateTime.month, startDateTime.month);

    endDateTime = DateTime(startDateTime.year, startDateTime.month, _totalDaysInCurrentMonth);

    var resultFromActionSheet = await widget.openActionSheetCallback(Constant.dateRangeActionSheet, startDateTime);
    /*if (resultFromActionSheet != null && resultFromActionSheet is String) {
      switch (resultFromActionSheet) {
        case Constant.last2Weeks:
          startDateTime = DateTime.now();
          endDateTime = startDateTime.subtract(Duration(days: 13));
          break;
        case Constant.last4Weeks:
          startDateTime = DateTime.now();
          endDateTime = startDateTime.subtract(Duration(days: 27));
          break;
        case Constant.last2Months:
          startDateTime = DateTime.now();
          endDateTime = startDateTime.subtract(Duration(days: 59));
          break;
        case Constant.last3Months:
          startDateTime = DateTime.now();
          endDateTime = startDateTime.subtract(Duration(days: 89));
          break;
        default:
          startDateTime = DateTime.now();
          endDateTime = startDateTime.subtract(Duration(days: 13));
      }
     _getUserReport(startDateTime, endDateTime);
    }*/
    if(resultFromActionSheet != null && resultFromActionSheet is DateTime) {
      startDateTime = DateTime(resultFromActionSheet.year, resultFromActionSheet.month, 1);

      _totalDaysInCurrentMonth =
          Utils.daysInCurrentMonth(resultFromActionSheet.month, resultFromActionSheet.month);

      endDateTime = DateTime(startDateTime.year, startDateTime.month, _totalDaysInCurrentMonth);
      _getUserReport(endDateTime, startDateTime);
    }
  }

  void _getUserReport(DateTime startDateTime, DateTime endDateTime) {
    _bloc.initNetworkStreamController();
    widget.showApiLoaderCallback(
      _bloc.networkStream,
        () {
          _bloc.enterDummyDataToNetworkStream();
          _bloc.getUserGenerateReportData(
              '${endDateTime.year}-${endDateTime.month}-${endDateTime.day}T00:00:00Z',
              '${startDateTime.year}-${startDateTime.month}-${startDateTime.day}T00:00:00Z',
              widget.moreHeadacheScreenArgumentModel.headacheTypeData.text);
        }
    );
    _bloc.getUserGenerateReportData(
        '${endDateTime.year}-${endDateTime.month}-${endDateTime.day}T00:00:00Z',
        '${startDateTime.year}-${startDateTime.month}-${startDateTime.day}T00:00:00Z',
        widget.moreHeadacheScreenArgumentModel.headacheTypeData.text);
  }

  ///Method to navigate to pdf screen
  void _navigateToPdfScreen(String base64String) {
    widget.onPush(context, TabNavigatorRoutes.pdfScreenRoute, base64String);
  }

  ///Method to get permission of the storage.
  Future<bool> _checkStoragePermission() async {
    if(Platform.isAndroid) {
      return await Constant.platform.invokeMethod('getStoragePermission');
    } else {
      return true;
    }
  }

  void _listenToViewReportStream() {
    _bloc.viewReportStream.listen((reportModel) {
      if(reportModel is UserGenerateReportDataModel) {
        _navigateToPdfScreen(reportModel.map.base64);
      }
    });
  }
}
