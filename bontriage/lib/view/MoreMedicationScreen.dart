import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreTriggerMedicationsBloc.dart';
import 'package:mobile/models/MoreMedicationArgumentModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/SignUpBottomSheet.dart';

class MoreMedicationScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final Function(Questions, Function(int)) openTriggerMedicationActionSheetCallback;
  final MoreMedicationArgumentModel moreMedicationArgumentModel;
  final Function(Stream, Function) showApiLoaderCallback;

  const MoreMedicationScreen({Key key, this.onPush, this.openActionSheetCallback, this.openTriggerMedicationActionSheetCallback, this.moreMedicationArgumentModel, this.showApiLoaderCallback})
      : super(key: key);
  @override
  _MoreMedicationScreenState createState() => _MoreMedicationScreenState();
}

class _MoreMedicationScreenState extends State<MoreMedicationScreen> with SingleTickerProviderStateMixin {

  MoreTriggerMedicationBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = MoreTriggerMedicationBloc();

    _bloc.editStream.listen((event) {
      if(event == Constant.success) {
        Navigator.pop(context, event);
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showSaveAndExitBottomSheet();
        return false;
      },
      child: Container(
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
                        _showSaveAndExitBottomSheet();
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
                              Constant.medication,
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
                    SignUpBottomSheet(
                      question: Questions(tag: 'headache.medications', values: widget.moreMedicationArgumentModel.medicationValues),
                      isFromMoreScreen: true,
                      selectAnswerListData: widget.moreMedicationArgumentModel.selectedAnswerList,
                      selectAnswerCallback: (question, valuesList) {
                        SelectedAnswers medicationSelectedAnswer = widget.moreMedicationArgumentModel.selectedAnswerList.firstWhere((element) => element.questionTag == 'headache.medications', orElse: () => null);
                        if(medicationSelectedAnswer != null) {
                          medicationSelectedAnswer.answer = jsonEncode(valuesList);
                        } else {
                          widget.moreMedicationArgumentModel.selectedAnswerList.add(SelectedAnswers(questionTag: 'headache.medications', answer: jsonEncode(valuesList)));
                        }
                      },
                      openTriggerMedicationActionSheetCallback: widget.openTriggerMedicationActionSheetCallback,
                    ),
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Constant.whichOfTheFollowingMedication,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 14,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSaveAndExitBottomSheet() async {
    var resultFromActionSheet = await widget.openActionSheetCallback(Constant.saveAndExitActionSheet, null);
    if(resultFromActionSheet != null && resultFromActionSheet is String) {
      if(resultFromActionSheet == Constant.saveAndExit) {
        //call edit info api
        SelectedAnswers selectedAnswers = widget.moreMedicationArgumentModel.selectedAnswerList.firstWhere((element) => element.questionTag == 'headache.medications', orElse: () => null);
        if(selectedAnswers != null) {
          _bloc.initNetworkStreamController();
          widget.showApiLoaderCallback(_bloc.networkStream, () {
            _bloc.enterLoadingDataToNetworkStreamController();
            _bloc.callEditApi(widget.moreMedicationArgumentModel.eventId,
                widget.moreMedicationArgumentModel.selectedAnswerList,
                widget.moreMedicationArgumentModel.responseModel);
          });
          _bloc.callEditApi(widget.moreMedicationArgumentModel.eventId,
              widget.moreMedicationArgumentModel.selectedAnswerList,
              widget.moreMedicationArgumentModel.responseModel);
        }
      } else {
        Navigator.pop(context, resultFromActionSheet);
      }
    }
  }
}
