import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/blocs/LogDayBloc.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddHeadacheSection.dart';
import 'package:mobile/view/AddNoteBottomSheet.dart';
import 'package:mobile/view/DeleteLogOptionsBottomSheet.dart';
import 'package:mobile/view/LogDayDoubleTapDialog.dart';

class LogDayScreen extends StatefulWidget {
  @override
  _LogDayScreenState createState() => _LogDayScreenState();
}

class _LogDayScreenState extends State<LogDayScreen>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime;
  LogDayBloc _logDayBloc;
  List<Widget> _sectionWidgetList = [];
  List<Questions> _sleepValuesList = [];
  List<Questions> _medicationValuesList = [];
  List<Questions> _triggerValuesList = [];
  List<SelectedAnswers> selectedAnswers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now();
    _logDayBloc = LogDayBloc();

    requestService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDoubleTapDialog();
    });
  }

  void requestService() async {
    List<Map> logDayDataList;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if(userProfileInfoData != null)
      logDayDataList = await _logDayBloc.getAllLogDayData(userProfileInfoData.userId);
    else
      logDayDataList = await _logDayBloc.getAllLogDayData('4214');
    if (logDayDataList.length > 0) {
      logDayDataList.forEach((element) {
        List<dynamic> map = jsonDecode(element['selectedAnswers']);
        map.forEach((element) {
          selectedAnswers.add(SelectedAnswers(
              questionTag: element['questionTag'], answer: element['answer']));
        });
      });
    }
    _logDayBloc.fetchLogDayData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            onTap: (){
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
                          addNewWidgets(snapshot.data);
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  Constant.doubleTapAnItem,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Constant.doubleTapTextColor,
                                      fontFamily: Constant.jostRegular),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(children: _sectionWidgetList),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    showAddNoteBottomSheet();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      Constant.addANote,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Constant.addCustomNotificationTextColor,
                                        fontFamily: Constant.jostRegular,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BouncingWidget(
                                    onPressed: () {},
                                    child: Container(
                                      width: 110,
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Constant.chatBubbleGreen,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Constant.submit,
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
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BouncingWidget(
                                    onPressed: () {},
                                    child: Container(
                                      width: 110,
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.3, color: Constant.chatBubbleGreen),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Constant.cancel,
                                          style: TextStyle(
                                              color: Constant.chatBubbleGreen,
                                              fontSize: 15,
                                              fontFamily: Constant.jostMedium),
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
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Text(
                                  snapshot.error.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: Constant.jostMedium,
                                    color: Constant.chatBubbleGreen
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              BouncingWidget(
                                onPressed: () {

                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Constant.chatBubbleGreen,
                                  ),
                                  child: Text(
                                    'Tap to Retry',
                                    style: TextStyle(
                                      color: Constant.bubbleChatTextView,
                                      fontSize: 14,
                                      fontFamily: Constant.jostMedium
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(
                                backgroundColor: Constant.chatBubbleGreen,
                              ),
                            ),
                          );
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
    );
  }

  void showAddNoteBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => AddNoteBottomSheet());
  }

  void addNewWidgets(List<Questions> questionList) {
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
              questions.values[index].isDoubleTapped = true;
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
                selectedAnswers: selectedAnswers),
          );
        }
      });
    }
  }

  void _showDeleteLogOptionBottomSheet() async{
    var resultOfDeleteBottomSheet = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DeleteLogOptionsBottomSheet()
    );
    if (resultOfDeleteBottomSheet == Constant.deleteLog) {
      SignUpOnBoardProviders.db.deleteAllUserLogDayData();
      Navigator.pop(context);
    }
  }

  Future<void> _showDoubleTapDialog() async {
    return showDialog<void>(
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
