import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreTriggerMedicationsBloc.dart';
import 'package:mobile/models/MoreTriggerArgumentModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/SignUpBottomSheet.dart';

class MoreTriggersScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final Function(Questions, Function(int)) openTriggerMedicationActionSheetCallback;
  final MoreTriggersArgumentModel moreTriggersArgumentModel;
  final Function(Stream, Function) showApiLoaderCallback;

  const MoreTriggersScreen({Key key, this.onPush, this.openActionSheetCallback, this.openTriggerMedicationActionSheetCallback, this.moreTriggersArgumentModel, this.showApiLoaderCallback})
      : super(key: key);
  @override
  _MoreTriggersScreenState createState() => _MoreTriggersScreenState();
}

class _MoreTriggersScreenState extends State<MoreTriggersScreen> with SingleTickerProviderStateMixin {
  MoreTriggerMedicationBloc _bloc;

  String _initialSelectedAnswerListJson;

  @override
  void initState() {
    super.initState();

    _bloc = MoreTriggerMedicationBloc();

    _bloc.editStream.listen((event) {
      if(event == Constant.success) {
        Navigator.pop(context, event);
      }
    });

    List<SelectedAnswers> initialSelectedAnswerList = [];

    _initialSelectedAnswerListJson = Constant.blankString;

    if(widget.moreTriggersArgumentModel.selectedAnswerList != null && widget.moreTriggersArgumentModel.selectedAnswerList.length > 0) {
      initialSelectedAnswerList.addAll(widget.moreTriggersArgumentModel.selectedAnswerList);

      initialSelectedAnswerList.removeWhere((element) => element.questionTag == Constant.headacheMedicationsTag);

      if(initialSelectedAnswerList.length > 0)
        _initialSelectedAnswerListJson = jsonEncode(initialSelectedAnswerList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_checkIfAnyChangesMade()) {
          _showSaveAndExitBottomSheet();
          return false;
        } else {
          return true;
        }
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
                        if(_checkIfAnyChangesMade())
                          _showSaveAndExitBottomSheet();
                        else
                          Navigator.pop(context);
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
                              "Triggers",
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
                      question: Questions(tag: 'headache.trigger', values: widget.moreTriggersArgumentModel.triggerValues),
                      isFromMoreScreen: true,
                      selectAnswerListData: widget.moreTriggersArgumentModel.selectedAnswerList,
                      selectAnswerCallback: (question, valuesList) {
                        SelectedAnswers triggerSelectedAnswer = widget.moreTriggersArgumentModel.selectedAnswerList.firstWhere((element) => element.questionTag == 'headache.trigger', orElse: () => null);
                        if(triggerSelectedAnswer != null) {
                          triggerSelectedAnswer.answer = jsonEncode(valuesList);
                        } else {
                          widget.moreTriggersArgumentModel.selectedAnswerList.add(SelectedAnswers(questionTag: 'headache.trigger', answer: jsonEncode(valuesList)));
                        }
                      },
                      openTriggerMedicationActionSheetCallback: widget.openTriggerMedicationActionSheetCallback,
                    ),
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Constant.whichOfTheFollowingDoYouSuspect,
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

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _showSaveAndExitBottomSheet() async {
    var resultFromActionSheet = await widget.openActionSheetCallback(Constant.saveAndExitActionSheet, null);
    if(resultFromActionSheet != null && resultFromActionSheet is String) {
      if(resultFromActionSheet == Constant.saveAndExit) {
        //call edit info api
        SelectedAnswers selectedAnswers = widget.moreTriggersArgumentModel.selectedAnswerList.firstWhere((element) => element.questionTag == 'headache.trigger', orElse: () => null);
        if(selectedAnswers != null) {
          _bloc.initNetworkStreamController();
          widget.showApiLoaderCallback(_bloc.networkStream, () {
            _bloc.enterLoadingDataToNetworkStreamController();
            _bloc.callEditApi(widget.moreTriggersArgumentModel.eventId,
                widget.moreTriggersArgumentModel.selectedAnswerList,
                widget.moreTriggersArgumentModel.responseModel);
          });
          _bloc.callEditApi(widget.moreTriggersArgumentModel.eventId,
              widget.moreTriggersArgumentModel.selectedAnswerList,
              widget.moreTriggersArgumentModel.responseModel);
        }
      } else {
        Navigator.pop(context, resultFromActionSheet);
      }
    }
  }

  bool _checkIfAnyChangesMade() {
    bool isChangesMade = false;
    if(widget.moreTriggersArgumentModel.selectedAnswerList != null) {
      List<SelectedAnswers> selectedAnswerList = [];

      selectedAnswerList.addAll(widget.moreTriggersArgumentModel.selectedAnswerList);

      selectedAnswerList.removeWhere((element) => element.questionTag == Constant.headacheMedicationsTag);


      String selectedAnswerListJson = Constant.blankString;

      if(selectedAnswerList.length > 0) {
        selectedAnswerListJson = jsonEncode(selectedAnswerList);
      }

      if (_initialSelectedAnswerListJson.isEmpty) {
        isChangesMade = selectedAnswerList.length > 0;
      } else {
        isChangesMade = _initialSelectedAnswerListJson != selectedAnswerListJson;
      }
    }

    return isChangesMade;
  }
}
