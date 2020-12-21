import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/blocs/LogDayBloc.dart';
import 'package:mobile/models/LogDayScreenArgumentModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddANoteWidget.dart';
import 'package:mobile/view/AddHeadacheSection.dart';
import 'package:mobile/view/AddNoteBottomSheet.dart';
import 'package:mobile/view/DeleteLogOptionsBottomSheet.dart';
import 'package:mobile/view/LogDayDoubleTapDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'NetworkErrorScreen.dart';

class LogDayScreen extends StatefulWidget {
  final LogDayScreenArgumentModel logDayScreenArgumentModel;

  const LogDayScreen({Key key, this.logDayScreenArgumentModel}) : super(key: key);

  @override
  _LogDayScreenState createState() => _LogDayScreenState();
}

class _LogDayScreenState extends State<LogDayScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _dateTime;
  LogDayBloc _logDayBloc;
  List<Widget> _sectionWidgetList = [];
  List<Questions> _questionsList = [];
  List<Questions> _sleepValuesList = [];
  List<Questions> _medicationValuesList = [];
  List<Questions> _triggerValuesList = [];
  List<SelectedAnswers> selectedAnswers = [];

  bool _isDataPopulated = false;

  @override
  void initState() {
    super.initState();
    if (widget.logDayScreenArgumentModel == null) {
      _dateTime = DateTime.now();
    } else {
      _dateTime = widget.logDayScreenArgumentModel.selectedDateTime;
    }
    if(widget.logDayScreenArgumentModel != null) {
      _logDayBloc = LogDayBloc(widget.logDayScreenArgumentModel.selectedDateTime);
    } else {
      _logDayBloc = LogDayBloc(null);
    }

    requestService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showApiLoaderDialog(context);
    });
  }

  void requestService() async {
    List<Map> logDayDataList;
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if (userProfileInfoData != null)
      logDayDataList =
          await _logDayBloc.getAllLogDayData(userProfileInfoData.userId);
    else
      logDayDataList = await _logDayBloc.getAllLogDayData('4214');
    if (logDayDataList.length > 0 && selectedAnswers.length == 0) {
      logDayDataList.forEach((element) {
        List<dynamic> map = jsonDecode(element['selectedAnswers']);
        map.forEach((element) {
          selectedAnswers.add(SelectedAnswers(questionTag: element['questionTag'], answer: element['answer'], isDoubleTapped: true));
        });
      });
    }

    List<SelectedAnswers> doubleTappedSelectedAnswerList = [];
    doubleTappedSelectedAnswerList.addAll(selectedAnswers);

    /*if(widget.logDayScreenArgumentModel != null && widget.logDayScreenArgumentModel.isFromRecordScreen) {
      String selectedDate = '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}T00:00:00Z';
      await _logDayBloc.fetchCalendarHeadacheLogDayData(selectedDate);
      selectedAnswers = _logDayBloc.getSelectedAnswerList(doubleTappedSelectedAnswerList);
    } else {
      _logDayBloc.fetchLogDayData();
    }*/

    String selectedDate = '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}T00:00:00Z';
    await _logDayBloc.fetchCalendarHeadacheLogDayData(selectedDate);
    selectedAnswers = _logDayBloc.getSelectedAnswerList(doubleTappedSelectedAnswerList);

    if(widget.logDayScreenArgumentModel == null || (widget.logDayScreenArgumentModel != null && !widget.logDayScreenArgumentModel.isFromRecordScreen)) {
      if(selectedAnswers.length == 0)
        selectedAnswers = doubleTappedSelectedAnswerList;
    }

  }

  @override
  void dispose() {
    _logDayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        _showDeleteLogOptionBottomSheet();
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          decoration: Constant.backgroundBoxDecoration,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  decoration: BoxDecoration(
                    color: Constant.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${Utils.getMonthName(_dateTime.month)} ${_dateTime.day}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDeleteLogOptionBottomSheet();
                                //Navigator.pop(context);
                              },
                              child: Image(
                                image: AssetImage(Constant.closeIcon),
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          thickness: 1,
                          color: Constant.chatBubbleGreen,
                          height: 30,
                        ),
                      ),
                      StreamBuilder<dynamic>(
                        stream: _logDayBloc.logDayDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (!_isDataPopulated) {
                              Utils.closeApiLoaderDialog(context);
                              Future.delayed(Duration(milliseconds: 200), () {
                                _showDoubleTapDialog();
                              });
                              addNewWidgets(snapshot.data);
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    Constant.doubleTapAnItem,
                                    style: TextStyle(
                                        fontSize: Platform.isAndroid ? 13 : 14,
                                        color: Constant.doubleTapTextColor,
                                        fontFamily: Constant.jostRegular),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(children: _sectionWidgetList),
                                AddANoteWidget(
                                  scaffoldKey: scaffoldKey,
                                  selectedAnswerList: selectedAnswers,
                                  noteTag: 'logday.note',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BouncingWidget(
                                      onPressed: () {
                                        if(selectedAnswers.length > 0)
                                          _onSubmitClicked();
                                      },
                                      child: Container(
                                        width: 110,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Constant.chatBubbleGreen,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Constant.submit,
                                            style: TextStyle(
                                                color:
                                                    Constant.bubbleChatTextView,
                                                fontSize: 15,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BouncingWidget(
                                      onPressed: () {
                                        _showDeleteLogOptionBottomSheet();
                                      },
                                      child: Container(
                                        width: 110,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.3,
                                              color: Constant.chatBubbleGreen),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Constant.cancel,
                                            style: TextStyle(
                                                color: Constant.chatBubbleGreen,
                                                fontSize: 15,
                                                fontFamily:
                                                    Constant.jostMedium),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            Utils.closeApiLoaderDialog(context);
                            return NetworkErrorScreen(
                              errorMessage: snapshot.error.toString(),
                              tapToRetryFunction: () {
                                Utils.showApiLoaderDialog(context);
                                requestService();
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddNoteBottomSheet() async {
    scaffoldKey.currentState.showBottomSheet(
        (context) => AddNoteBottomSheet(
              addNoteCallback: (note) {
                if (note != null) {
                  if (note is String) {
                    if (note.trim() != '') {
                      SelectedAnswers noteSelectedAnswer =
                          selectedAnswers.firstWhere(
                              (element) => element.questionTag == 'logday.note',
                              orElse: () => null);
                      if (noteSelectedAnswer == null)
                        selectedAnswers.add(SelectedAnswers(
                            questionTag: 'logday.note', answer: note));
                      else
                        noteSelectedAnswer.answer = note;
                    }
                  }
                }
              },
            ),
        backgroundColor: Colors.transparent);
  }

  void addNewWidgets(List<Questions> questionList) {
    _questionsList.addAll(questionList);
    if (_sectionWidgetList.length == 0) {
      if (selectedAnswers.length != 0) {
        selectedAnswers.forEach((element) {
          Questions questions = questionList.firstWhere(
              (element1) => element1.tag == element.questionTag,
              orElse: () => null);
          if (questions != null &&
              (questions.questionType == 'multi' ||
                  questions.questionType == 'single')) {
            try {
              int index = int.parse(element.answer) - 1;
              questions.values[index].isSelected = true;
              questions.values[index].isDoubleTapped = element.isDoubleTapped ?? true;
            } catch (e) {
              print(e.toString());
            }
          }
        });
      }
      List<Questions> allQuestionList = [];
      allQuestionList.addAll(questionList);
      _sectionWidgetList = [];
      questionList.forEach((element) {
        if (element.precondition.contains('behavior.presleep')) {
          _sleepValuesList.add(element);
        } else if (element.precondition.contains('medication')) {
          _medicationValuesList.add(element);
        } else if (element.precondition.contains('triggers1')) {
          _triggerValuesList.add(element);
        }
      });

      questionList.removeWhere((element) => _sleepValuesList.contains(element));
      questionList
          .removeWhere((element) => _medicationValuesList.contains(element));
      questionList
          .removeWhere((element) => _triggerValuesList.contains(element));

      List<SelectedAnswers> doubleTapSelectedAnswerList = [];

      doubleTapSelectedAnswerList.addAll(selectedAnswers);

      questionList.forEach((element) {
        if (element.precondition == null || element.precondition.isEmpty) {
          _sectionWidgetList.add(
            AddHeadacheSection(
                headerText: element.text,
                subText: element.helpText,
                contentType: element.tag,
                sleepExpandableWidgetList: _sleepValuesList,
                medicationExpandableWidgetList: _medicationValuesList,
                triggerExpandableWidgetList: _triggerValuesList,
                valuesList: element.values,
                questionType: element.questionType,
                allQuestionsList: allQuestionList,
                selectedAnswers: selectedAnswers,
            doubleTapSelectedAnswer: doubleTapSelectedAnswerList,),
          );
        }
      });
    }
    _isDataPopulated = true;
  }

  void _showDeleteLogOptionBottomSheet() async {
    var resultOfDeleteBottomSheet = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DeleteLogOptionsBottomSheet());
    if (resultOfDeleteBottomSheet == Constant.deleteLog) {
      SignUpOnBoardProviders.db.deleteAllUserLogDayData();
      Navigator.pop(context, false);
    }
  }

  Future<void> _showDoubleTapDialog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isDialogDisplayed =
        sharedPreferences.getBool(Constant.logDayDoubleTapDialog) ?? false;

    if (!isDialogDisplayed) {
      sharedPreferences.setBool(Constant.logDayDoubleTapDialog, true);
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: LogDayDoubleTapDialog(),
          );
        },
      );
    }
  }

  void _onSubmitClicked() async {
    Utils.showApiLoaderDialog(context,
        networkStream: _logDayBloc.sendLogDayDataStream,
        tapToRetryFunction: () {
      _logDayBloc.enterSomeDummyDataToStreamController();
      _callSendLogDayDataApi();
    });
    _callSendLogDayDataApi();
  }

  void _callSendLogDayDataApi() async {
    var response =
        await _logDayBloc.sendLogDayData(selectedAnswers, _questionsList);
    if (response is String) {
      if (response == Constant.success) {
        //SignUpOnBoardProviders.db.deleteAllUserLogDayData();
        Navigator.pop(context);
        if(widget.logDayScreenArgumentModel == null) {
          Navigator.pushReplacementNamed(
              context, Constant.logDaySuccessScreenRouter);
        } else {
          if(widget.logDayScreenArgumentModel.isFromRecordScreen) {
            Navigator.pop(context, true);
          } else {
            Navigator.pushReplacementNamed(
                context, Constant.logDaySuccessScreenRouter);
          }
        }
      }
    }
  }
}
