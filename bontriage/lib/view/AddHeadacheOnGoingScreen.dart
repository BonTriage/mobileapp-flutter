import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/AddHeadacheLogBloc.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserAddHeadacheLogModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddANoteWidget.dart';
import 'package:mobile/view/AddHeadacheSection.dart';
import 'NetworkErrorScreen.dart';

class AddHeadacheOnGoingScreen extends StatefulWidget {
  final CurrentUserHeadacheModel currentUserHeadacheModel;

  const AddHeadacheOnGoingScreen({Key key, this.currentUserHeadacheModel})
      : super(key: key);

  @override
  _AddHeadacheOnGoingScreenState createState() =>
      _AddHeadacheOnGoingScreenState();
}

class _AddHeadacheOnGoingScreenState extends State<AddHeadacheOnGoingScreen>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime;
  AddHeadacheLogBloc _addHeadacheLogBloc;
  String headacheType = '';
  SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel =
      SignUpOnBoardSelectedAnswersModel();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Questions> _addHeadacheUserListData;

  List<SelectedAnswers> selectedAnswers = [];

  bool _isUserHeadacheEnded = false;

  bool _isDataPopulated = false;
  bool _isFromRecordScreen = false;
  CurrentUserHeadacheModel _currentUserHeadacheModel;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();

    signUpOnBoardSelectedAnswersModel.selectedAnswers = [];

    _currentUserHeadacheModel = widget.currentUserHeadacheModel;

    _isFromRecordScreen = widget.currentUserHeadacheModel.isFromRecordScreen ?? false;

    try {
       _dateTime = DateTime.parse(widget.currentUserHeadacheModel.selectedDate);
    } catch(e) {
      print(e.toString());
    }

    signUpOnBoardSelectedAnswersModel.eventType = "Headache";
    signUpOnBoardSelectedAnswersModel.selectedAnswers = [];

    _addHeadacheLogBloc = AddHeadacheLogBloc();
    _addHeadacheLogBloc.currentUserHeadacheModel = widget.currentUserHeadacheModel;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Utils.showApiLoaderDialog(context);
    });

    requestService();
  }

  @override
  void didUpdateWidget(AddHeadacheOnGoingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addHeadacheLogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              Navigator.pop(context, _addHeadacheLogBloc.isHeadacheLogged);
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
                        height: 30,
                        thickness: 1,
                        color: Constant.chatBubbleGreen,
                      ),
                    ),
                    Container(
                      child: StreamBuilder<dynamic>(
                        stream: _addHeadacheLogBloc.addHeadacheLogDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(!_isDataPopulated) {
                              /*if(widget.currentUserHeadacheModel.isFromRecordScreen ?? false) {
                                addSelectedHeadacheDetailsData(Constant.onGoingTag, 'No');
                                addSelectedHeadacheDetailsData(Constant.endTimeTag, widget.currentUserHeadacheModel.selectedEndDate);
                              }*/
                              Utils.closeApiLoaderDialog(context);
                            }
                            return Column(
                              children: [
                                Column(
                                  children:
                                      _getAddHeadacheSection(snapshot.data),
                                ),
                                AddANoteWidget(
                                  selectedAnswerList: signUpOnBoardSelectedAnswersModel.selectedAnswers,
                                  scaffoldKey: scaffoldKey,
                                  noteTag: 'headache.note',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BouncingWidget(
                                      onPressed: () {
                                        saveDataInLocalDataBaseOrServer();
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
                                            _isUserHeadacheEnded
                                                ? Constant.submit
                                                : Constant.save,
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
                                        Navigator.pop(context);
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
                          } else if (snapshot.hasError){
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

  /// This method will be use for add widget from the help of ADDHeadacheSection class.
  List<Widget> _getAddHeadacheSection(List<dynamic> addHeadacheListData) {
    List<Widget> listOfWidgets = [];
    _addHeadacheUserListData = addHeadacheListData;
    selectedAnswers.forEach((element) {
      Questions questionsTag = _addHeadacheUserListData
          .firstWhere((element1) => element1.tag == element.questionTag, orElse: () => null);
      if(questionsTag != null) {
        switch (questionsTag.questionType) {
          case Constant.singleTypeTag:
            Values answerValuesData = questionsTag.values
                .firstWhere((element1) => element1.text == element.answer);
            answerValuesData.isSelected = true;
            break;
          case Constant.numberTypeTag:
          /*if(element.answer == null) {
            SelectedAnswers numberTypeSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element1) => element1.questionTag == element.questionTag, orElse: () => null);
            if(numberTypeSelectedAnswer == null)
              signUpOnBoardSelectedAnswersModel.selectedAnswers.add(SelectedAnswers(questionTag: element.questionTag, answer: '0'));
            else
              numberTypeSelectedAnswer.answer = '0';
          }*/
            questionsTag.currentValue = element.answer;
            break;
          case Constant.dateTimeTypeTag:
            questionsTag.updatedAt = element.answer;
            break;
        }
      }
    });

    _addHeadacheUserListData.forEach((element) {
      listOfWidgets.add(AddHeadacheSection(
          headerText: element.text,
          subText: element.helpText,
          contentType: element.tag,
          min: element.min.toDouble(),
          max: element.max.toDouble(),
          valuesList: element.values,
          updateAtValue: null,
          selectedCurrentValue: element.currentValue,
          selectedAnswers: signUpOnBoardSelectedAnswersModel.selectedAnswers,
          addHeadacheDetailsData: addSelectedHeadacheDetailsData,
          moveWelcomeOnBoardTwoScreen: moveOnWelcomeBoardSecondStepScreens,
          isHeadacheEnded: !widget.currentUserHeadacheModel.isOnGoing,
        currentUserHeadacheModel: _currentUserHeadacheModel,
      ));
    });

    _isDataPopulated = true;
    return listOfWidgets;
  }

  /// This method will be use for to insert and update his answer in the local model.So we will save his answer on the basis of current Tag
  void addSelectedHeadacheDetailsData(String currentTag, String selectedValue) {
    SelectedAnswers selectedAnswers;
    if (signUpOnBoardSelectedAnswersModel.selectedAnswers.length > 0) {
      selectedAnswers = signUpOnBoardSelectedAnswersModel.selectedAnswers
          .firstWhere((model) => model.questionTag == currentTag,
              orElse: () => null);
    }
    if (selectedAnswers != null) {
      selectedAnswers.answer = selectedValue;
    } else {
      signUpOnBoardSelectedAnswersModel.selectedAnswers
          .add(SelectedAnswers(questionTag: currentTag, answer: selectedValue));
      print(signUpOnBoardSelectedAnswersModel.selectedAnswers);
    }

    if (currentTag == "ongoing") {
      if (selectedValue == "Yes") {
        _isUserHeadacheEnded = false;
      } else {
        _isUserHeadacheEnded = true;
      }
      setState(() {});
    }
  }

  /// This method will be use for if user click Headache Plus Icon and he want to add another headache name of Add headache Screen.
  /// So we will move to the user  2nd Step of welcome OnBoard Screen in which he will add all information related to his headache.
  moveOnWelcomeBoardSecondStepScreens() async {
    final pushToScreenResult = await Navigator.pushNamed(
        context, Constant.partTwoOnBoardScreenRouter,
        arguments: Constant.clinicalImpressionEventType);
    if (pushToScreenResult != null) {
      setState(() {
        if (_addHeadacheUserListData != null) {
          Questions questions = _addHeadacheUserListData.firstWhere(
              (element) => element.tag == "headacheType",
              orElse: () => null);
          if (questions != null) {
            questions.values.removeLast();
            Values values = questions.values.firstWhere(
                (element) => element.isSelected,
                orElse: () => null);
            if (values != null) {
              values.isSelected = false;
            }
            questions.values
                .add(Values(text: pushToScreenResult, isSelected: true));
          }

          addSelectedHeadacheDetailsData("headacheType", pushToScreenResult);
        }
      });
    }
    print(pushToScreenResult);
  }

  void saveDataInLocalDataBaseOrServer() async {
    /*UserAddHeadacheLogModel userAddHeadacheLogModel = UserAddHeadacheLogModel();
    List<SelectedAnswers> selectedAnswerList =
        signUpOnBoardSelectedAnswersModel.selectedAnswers;

    SelectedAnswers selectedAnswer = selectedAnswerList.firstWhere(
        (element) => element.questionTag == "ongoing",
        orElse: () => null);
    if (selectedAnswer == null || selectedAnswer.answer == "Yes") {
      userAddHeadacheLogModel.selectedAnswers = json.encode(selectedAnswerList);
      var userProfileInfoData =
          await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
      if (userProfileInfoData != null)
        userAddHeadacheLogModel.userId = userProfileInfoData.userId;
      else
        userAddHeadacheLogModel.userId = "4214";
      saveAndUpdateDataInLocalDatabase(userAddHeadacheLogModel);
      Navigator.pop(context);
    } else {
      Utils.showApiLoaderDialog(
        context,
        networkStream: _addHeadacheLogBloc.sendAddHeadacheLogDataStream,
        tapToRetryFunction: () {
          _addHeadacheLogBloc.enterSomeDummyData();
          _callSendAddHeadacheLogApi();
        }
      );
      _callSendAddHeadacheLogApi();
    }*/

    SelectedAnswers headacheTypeSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == Constant.headacheTypeTag, orElse: () => null);

    if(headacheTypeSelectedAnswer != null) {
      Utils.showApiLoaderDialog(
          context,
          networkStream: _addHeadacheLogBloc.sendAddHeadacheLogDataStream,
          tapToRetryFunction: () {
            _addHeadacheLogBloc.enterSomeDummyData();
            _callSendAddHeadacheLogApi();
          }
      );
      _callSendAddHeadacheLogApi();
    } else {
      //show headacheType selection error
      print('headache type error');
      Utils.showValidationErrorDialog(context, 'Please select a headache type.');
    }
  }

  void _callSendAddHeadacheLogApi() async {
    var response = await _addHeadacheLogBloc
        .sendAddHeadacheDetailsData(signUpOnBoardSelectedAnswersModel);
    if (response == Constant.success) {
      Navigator.pop(context);
      if(!_isFromRecordScreen) {
        if(_isUserHeadacheEnded)
          await SignUpOnBoardProviders.db.deleteUserCurrentHeadacheData();
        Navigator.pushReplacementNamed(context, Constant.addHeadacheSuccessScreenRouter);
      } else {
        Navigator.pop(context, _addHeadacheLogBloc.isHeadacheLogged);
      }
    }
  }

  void saveAndUpdateDataInLocalDatabase(UserAddHeadacheLogModel userAddHeadacheLogModel) async {
    try {
      int userProgressDataCount = await SignUpOnBoardProviders.db
          .checkUserProgressDataAvailable(
              SignUpOnBoardProviders.TABLE_ADD_HEADACHE);
      if (userProgressDataCount == 0) {
        SignUpOnBoardProviders.db
            .insertAddHeadacheDetails(userAddHeadacheLogModel);
      } else {
        SignUpOnBoardProviders.db
            .updateAddHeadacheDetails(userAddHeadacheLogModel);
      }
    } catch (e) {
      e.toString();
    }
  }

  void requestService() async {
    List<Map> userHeadacheDataList;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if (userProfileInfoData != null)
      userHeadacheDataList = await _addHeadacheLogBloc.fetchDataFromLocalDatabase(userProfileInfoData.userId);
    else
      userHeadacheDataList = await _addHeadacheLogBloc.fetchDataFromLocalDatabase("4214");
    if (userHeadacheDataList.length > 0) {
      userHeadacheDataList.forEach((element) {
        List<dynamic> map = jsonDecode(element['selectedAnswers']);
        map.forEach((element) {
          selectedAnswers.add(SelectedAnswers(questionTag: element['questionTag'], answer: element['answer']));
        });
      });
      signUpOnBoardSelectedAnswersModel.selectedAnswers = selectedAnswers;
    }

    if(_isFromRecordScreen) {
      await _addHeadacheLogBloc.fetchCalendarHeadacheLogDayData(widget.currentUserHeadacheModel);
      signUpOnBoardSelectedAnswersModel.selectedAnswers = _addHeadacheLogBloc.selectedAnswersList;

      SelectedAnswers startTimeSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == Constant.onSetTag, orElse: () => null);
      SelectedAnswers endTimeSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == Constant.endTimeTag, orElse: () => null);
      SelectedAnswers onGoingSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == Constant.onGoingTag, orElse: () => null);

      if(startTimeSelectedAnswer != null) {
        _currentUserHeadacheModel.selectedDate = startTimeSelectedAnswer.answer;
      }

      if(endTimeSelectedAnswer != null) {
        _currentUserHeadacheModel.selectedEndDate = endTimeSelectedAnswer.answer;
      }

      if(onGoingSelectedAnswer != null) {
        _currentUserHeadacheModel.isOnGoing = onGoingSelectedAnswer.answer.toLowerCase() != 'no';
      }

      print(_currentUserHeadacheModel);
    } else {
      if(_currentUserHeadacheModel.headacheId != null) {
        await _addHeadacheLogBloc.fetchCalendarHeadacheLogDayData(widget.currentUserHeadacheModel);
        signUpOnBoardSelectedAnswersModel.selectedAnswers = _addHeadacheLogBloc.selectedAnswersList;
      } else {
        //put condition for the headache id to fetch the current on going headache data
        _addHeadacheLogBloc.fetchAddHeadacheLogData();
      }
    }
  }
}
