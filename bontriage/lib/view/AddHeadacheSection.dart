import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/models/LogDayQuestionnaire.dart';
import 'package:mobile/models/MedicationSelectedDataModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/TriggerWidgetModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddNewMedicationDialog.dart';
import 'package:mobile/view/CircleLogOptions.dart';
import 'package:mobile/view/DateTimePicker.dart';
import 'package:mobile/view/LogDayChipList.dart';
import 'package:mobile/view/MedicationDosagePicker.dart';
import 'package:mobile/view/TimeSection.dart';
import 'package:mobile/view/sign_up_age_screen.dart';
import 'dart:io' show Platform;

class AddHeadacheSection extends StatefulWidget {
  final String headerText;
  final String subText;
  final String contentType;
  final String selectedCurrentValue;
  final String questionType;
  final double min;
  final double max;
  final List<Questions> allQuestionsList;
  final List<Questions> sleepExpandableWidgetList;
  final List<Questions> medicationExpandableWidgetList;
  final List<Questions> triggerExpandableWidgetList;
  final List<Values> valuesList;
  final List<Values> chipsValuesList;
  final Function(String, String) addHeadacheDetailsData;
  final Function moveWelcomeOnBoardTwoScreen;
  final String updateAtValue;
  final List<SelectedAnswers> selectedAnswers;
  final List<SelectedAnswers> doubleTapSelectedAnswer;
  final bool isHeadacheEnded;
  final CurrentUserHeadacheModel currentUserHeadacheModel;
  final bool isFromRecordsScreen;
  final String uiHints;
  final DateTime selectedDateTime;

  AddHeadacheSection(
      {Key key,
        this.headerText,
        this.subText,
        this.contentType,
        this.min,
        this.max,
        this.valuesList,
        this.chipsValuesList,
        this.sleepExpandableWidgetList,
        this.medicationExpandableWidgetList,
        this.addHeadacheDetailsData,
        this.selectedCurrentValue,
        this.updateAtValue,
        this.moveWelcomeOnBoardTwoScreen,
        this.triggerExpandableWidgetList,
        this.questionType,
        this.allQuestionsList,
        this.selectedAnswers,
        this.isHeadacheEnded,
        this.currentUserHeadacheModel,
        this.doubleTapSelectedAnswer,
        this.isFromRecordsScreen = false,
        this.uiHints,
        this.selectedDateTime})
      : super(key: key);

  @override
  _AddHeadacheSectionState createState() => _AddHeadacheSectionState();
}

class _AddHeadacheSectionState extends State<AddHeadacheSection>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  int numberOfSleepItemSelected = 0;
  int whichSleepItemSelected = 0;
  List<int> whichMedicationItemSelected = [];
  int _whichExpandedMedicationItemSelected = 0;
  int whichTriggerItemSelected = 0;
  bool isValuesUpdated = false;
  List<List<String>> _medicineTimeList = [];
  List<List<Questions>> _medicationDosageList = [];
  List<int> _numberOfDosageAddedList = [];
  MedicationSelectedDataModel _medicationSelectedDataModel;
  List<TriggerWidgetModel> _triggerWidgetList = [];
  String previousMedicationTag;
  List<SelectedAnswers> selectedAnswerListOfTriggers = [];
  List<List<String>> _additionalMedicationDosage = [];
  DateTime _selectedDateTime;

  ///Method to get section widget
  Widget _getSectionWidget() {
    switch (widget.contentType) {
      case 'headacheType':
        var value = widget.valuesList.firstWhere(
                (model) => model.text == Constant.plusText,
            orElse: () => null);
        if (value == null) {
          widget.valuesList.add(Values(
              text: Constant.plusText,
              valueNumber: widget.valuesList.length.toString()));
        }

        if(widget.selectedAnswers != null) {
          SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere((element) => element.questionTag == widget.contentType, orElse: () => null);

          if(selectedAnswers != null) {
            Values selectedValue = widget.valuesList.firstWhere((element) => element.text == selectedAnswers.answer, orElse: () => null);
            if (selectedValue != null)
              selectedValue.isSelected = true;
          }
        }
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onCircleItemSelected: _onHeadacheTypeItemSelected,
        ));
      case 'onset':
        return _getWidget(TimeSection(
          currentTag: widget.contentType,
          updatedDateValue: widget.updateAtValue,
          addHeadacheDateTimeDetailsData: _onHeadacheDateTimeSelected,
          isHeadacheEnded: widget.isHeadacheEnded,
          currentUserHeadacheModel: widget.currentUserHeadacheModel,
        ));
      case 'severity':
        String selectedCurrentValue;
        if(widget.selectedAnswers != null) {
          SelectedAnswers intensitySelectedAnswer = widget.selectedAnswers.firstWhere((element) => element.questionTag == 'severity', orElse: () => null);
          if (intensitySelectedAnswer != null) {
            selectedCurrentValue = intensitySelectedAnswer.answer;
          } else {
            widget.selectedAnswers.add(SelectedAnswers(questionTag: 'severity', answer: widget.min.toInt().toString()));
          }
        }

        if(selectedCurrentValue == null)
          selectedCurrentValue = widget.selectedCurrentValue;
        return _getWidget(SignUpAgeScreen(
          sliderValue: (selectedCurrentValue == null ||
              selectedCurrentValue.isEmpty)
              ? widget.min
              : double.parse(selectedCurrentValue),
          minText: Constant.one,
          maxText: Constant.ten,
          currentTag: widget.contentType,
          sliderMinValue: widget.min,
          sliderMaxValue: widget.max,
          minTextLabel: Constant.mild,
          maxTextLabel: Constant.veryPainful,
          labelText: '',
          horizontalPadding: 0,
          selectedAnswerCallBack: _onHeadacheIntensitySelected,
          isAnimate: false,
          uiHints: widget.uiHints,
        ));
      case 'disability':
        String selectedCurrentValue;
        if(widget.selectedAnswers != null) {
          SelectedAnswers intensitySelectedAnswer = widget.selectedAnswers.firstWhere((element) => element.questionTag == 'disability', orElse: () => null);
          if (intensitySelectedAnswer != null) {
            selectedCurrentValue = intensitySelectedAnswer.answer;
          } else {
            widget.selectedAnswers.add(SelectedAnswers(questionTag: 'disability', answer: widget.min.toInt().toString()));
          }
        }

        if(selectedCurrentValue == null)
          selectedCurrentValue = widget.selectedCurrentValue;
        return _getWidget(SignUpAgeScreen(
          sliderValue: (selectedCurrentValue == null ||
              selectedCurrentValue.isEmpty)
              ? widget.min
              : double.parse(selectedCurrentValue),
          minText: Constant.one,
          maxText: Constant.ten,
          currentTag: widget.contentType,
          sliderMinValue: widget.min,
          sliderMaxValue: widget.max,
          minTextLabel: Constant.noneAtALL,
          maxTextLabel: Constant.totalDisability,
          labelText: '',
          horizontalPadding: 0,
          selectedAnswerCallBack: _onHeadacheIntensitySelected,
          isAnimate: false,
          uiHints: widget.uiHints,
        ));

      case 'behavior.presleep':
        if (!isValuesUpdated) {
          isValuesUpdated = true;
          Values value = widget.valuesList.firstWhere(
                  (element) => element.isDoubleTapped || element.isSelected,
              orElse: () => null);
          if (value != null) {
            try {
              _onSleepItemSelected(int.parse(value.valueNumber) - 1);
            } catch (e) {
              print(e.toString());
            }
          }
        }

        numberOfSleepItemSelected = 0;
        widget.sleepExpandableWidgetList[0].values.forEach((element) {
          if (element.isSelected != null && element.isSelected) {
            numberOfSleepItemSelected++;
          }
        });

        Values selectedExpandedSleepItemValue = widget.sleepExpandableWidgetList[0].values.firstWhere((element) => element.isSelected, orElse: () => null);
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          preCondition: widget.sleepExpandableWidgetList[0].precondition,
          overlayNumber: numberOfSleepItemSelected,
          onCircleItemSelected: _onSleepItemSelected,
          onDoubleTapItem: _onDoubleTapItem,
          isAnySleepItemSelected: selectedExpandedSleepItemValue != null,
          currentTag: widget.contentType,
        ));
      case 'behavior.premeal':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onDoubleTapItem: _onDoubleTapItem,
          onCircleItemSelected: _onExerciseItemSelected,
          currentTag: widget.contentType,
        ));
      case 'behavior.preexercise':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onDoubleTapItem: _onDoubleTapItem,
          onCircleItemSelected: _onExerciseItemSelected,
          currentTag: widget.contentType,
        ));
      case 'medication':
        try {
          ///This below code is to show expanded view of medications
          if (!isValuesUpdated) {
            isValuesUpdated = true;
            List<Values> valueList = widget.valuesList.where(
                    (element) => element.isDoubleTapped || element.isSelected).toList();
            valueList.forEach((value1) {
              int medicationIndex = widget.valuesList.indexOf(value1);

              int indexValue = whichMedicationItemSelected.firstWhere((element) => element == medicationIndex, orElse: () => null);

              if(indexValue == null)
                whichMedicationItemSelected.add(medicationIndex);

              Values value = widget.valuesList.firstWhere((element) => element.isSelected, orElse: () => null);

              if (value != null) {
                _animationController.forward();
              } else {
                _animationController.reverse();
                widget.selectedAnswers.removeWhere((element) =>
                element.questionTag == 'administered');
              }

              String valueNumber = widget.valuesList[medicationIndex].valueNumber;
              bool isSelected = widget.valuesList[medicationIndex].isSelected;
              bool isNewlyAdded = widget.valuesList[medicationIndex].isNewlyAdded;

              if(!isSelected) {
                whichMedicationItemSelected.remove(medicationIndex);
              }

              if(isNewlyAdded && isSelected) {
                if(_additionalMedicationDosage[medicationIndex].length < _numberOfDosageAddedList[medicationIndex] + 1) {
                  for (var i = 0; i < _numberOfDosageAddedList[medicationIndex] + 1; i++) {
                    _additionalMedicationDosage[medicationIndex].add('50 mg');
                  }
                }
              }

              _updateMedicationSelectedDataModel();
              _updateSelectedAnswerListWhenCircleItemSelected(valueNumber, isSelected);
              _storeExpandedWidgetDataIntoLocalModel();

              SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere((element) => element.questionTag == 'administered', orElse: () => null);
              if (selectedAnswers != null) {
                DateTime dateTime = DateTime.parse(selectedAnswers.answer);
                _medicineTimeList[medicationIndex][0] = Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
              }
            });
            /*if (value != null) {
              _onMedicationItemSelected(int.parse(value.valueNumber) - 1);
              SelectedAnswers selectedAnswers = widget.selectedAnswers
                  .firstWhere(
                      (element) => element.questionTag == 'administered',
                  orElse: () => null);
              if (selectedAnswers != null) {
                DateTime dateTime = DateTime.parse(selectedAnswers.answer);
                _medicineTimeList[whichMedicationItemSelected][0] = Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
              }
            }*/
          }
        } catch(e) {
          print(e.toString());
        }

        Values plusValue = widget.valuesList.firstWhere((element) => element.text == Constant.plusText, orElse: () => null);
        if(plusValue == null) {
          widget.valuesList.add(Values(text: Constant.plusText,
              valueNumber: (widget.valuesList.length + 1).toString()));
          _medicineTimeList.add(List.generate(1, (index) => DateTime.now().toString()));
          _medicationDosageList.add(List.generate(1, (index) => Questions()));
          _numberOfDosageAddedList.add(0);
        }

        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onCircleItemSelected: _onMedicationItemSelected,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
          questionType: widget.questionType,
          isForMedication: true,
        ));
      case 'triggers1':
        if (!isValuesUpdated) {
          isValuesUpdated = true;
          widget.valuesList.asMap().forEach((index, element) {
            if (element.isSelected || element.isDoubleTapped) {
              Future.delayed(Duration(milliseconds: index * 400), () {
                _onTriggerItemSelected(index);
              });
            }
          });
        }
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          questionType: widget.questionType,
          onCircleItemSelected: _onTriggerItemSelected,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
        ));
      default:
        return Container();
    }
  }

  void _onHeadacheTypeItemSelected(int index) {
    if (widget.valuesList[index].text == Constant.plusText) {
      widget.moveWelcomeOnBoardTwoScreen();
    } else
      widget.addHeadacheDetailsData(
          widget.contentType, widget.valuesList[index].text);
  }

  void _onHeadacheIntensitySelected(String currentTag, String currentValue) {
    widget.addHeadacheDetailsData(currentTag, currentValue);
  }

  void _onHeadacheDateTimeSelected(String currentTag, String currentValue) {
    widget.addHeadacheDetailsData(currentTag, currentValue);
  }

  void _onDoubleTapItem(String currentTag, String selectedAnswer,
      String questionType, bool isDoubleTapped, int index) {
    whichSleepItemSelected = index;

    int indexValue = whichMedicationItemSelected.firstWhere((element) => element == index, orElse: () => null);

    if(indexValue == null)
      whichMedicationItemSelected.add(index);

    whichTriggerItemSelected = index;

    if(widget.contentType == 'medication')
      _updateMedicationSelectedDataModel();

    if(widget.valuesList[index].text.toLowerCase() == Constant.none) {
      setState(() {
        widget.valuesList.asMap().forEach((key, element) {
          if(index != key) {
            element
              ..isSelected = false
              ..isDoubleTapped = false;
          }
        });
        _triggerWidgetList.clear();
      });

      widget.selectedAnswers.removeWhere((element) => element.questionTag.contains('triggers1'));
      widget.doubleTapSelectedAnswer.removeWhere((element) => element.questionTag.contains('triggers1'));
    }

    if (isDoubleTapped) {
      if (questionType == 'multi') {
        SelectedAnswers selectedAnswerValue = widget.selectedAnswers.firstWhere((element) => (element.questionTag == currentTag && element.answer == selectedAnswer), orElse: () => null);
        if(selectedAnswerValue == null) {
          widget.selectedAnswers.add(SelectedAnswers(questionTag: currentTag, answer: selectedAnswer));
        }

        SelectedAnswers doubleTapSelectedAnswer = widget.doubleTapSelectedAnswer.firstWhere((element) => (element.questionTag == currentTag && element.answer == selectedAnswer), orElse: () => null);
        if(doubleTapSelectedAnswer == null)
          widget.doubleTapSelectedAnswer.add(SelectedAnswers(questionTag: currentTag, answer: selectedAnswer));
      } else {
        SelectedAnswers selectedAnswerObj = widget.selectedAnswers.firstWhere((element) => element.questionTag == currentTag, orElse: () => null);
        if (selectedAnswerObj == null) {
          widget.selectedAnswers.add(
              SelectedAnswers(questionTag: currentTag, answer: selectedAnswer));
        } else {
          selectedAnswerObj.answer = selectedAnswer;
        }

        SelectedAnswers doubleTapSelectedAnswerObj = widget.doubleTapSelectedAnswer.firstWhere((element) => element.questionTag == currentTag, orElse: () => null);
        if (doubleTapSelectedAnswerObj == null) {
          widget.doubleTapSelectedAnswer.add(SelectedAnswers(questionTag: currentTag, answer: selectedAnswer));
        } else {
          doubleTapSelectedAnswerObj.answer = selectedAnswer;
        }
      }
    } else {
      if (questionType == 'multi') {
        List<SelectedAnswers> selectedAnswerList = [];
        widget.selectedAnswers.forEach((element) {
          if (element.questionTag == currentTag &&
              element.answer == selectedAnswer) {
            selectedAnswerList.add(element);
          }
        });

        selectedAnswerList.forEach((element) {
          widget.selectedAnswers.remove(element);
        });

        List<SelectedAnswers> doubleTapSelectedAnswerList = [];
        widget.doubleTapSelectedAnswer.forEach((element) {
          if (element.questionTag == currentTag &&
              element.answer == selectedAnswer) {
            doubleTapSelectedAnswerList.add(element);
          }
        });

        doubleTapSelectedAnswerList.forEach((element) {
          widget.doubleTapSelectedAnswer.remove(element);
        });
      } else {
        SelectedAnswers selectedAnswerObj = widget.selectedAnswers.firstWhere(
                (element) => element.questionTag == currentTag,
            orElse: () => null);

        if (selectedAnswerObj != null) {
          widget.selectedAnswers.remove(selectedAnswerObj);
        }

        SelectedAnswers doubleTapSelectedAnswerObj = widget.doubleTapSelectedAnswer.firstWhere(
                (element) => element.questionTag == currentTag,
            orElse: () => null);

        if (doubleTapSelectedAnswerObj != null) {
          widget.doubleTapSelectedAnswer.remove(doubleTapSelectedAnswerObj);
        }
      }
    }
    storeExpandableViewSelectedData(isDoubleTapped);
    storeLogDayDataIntoDatabase();
    print(widget.selectedAnswers.length);
  }

  void storeExpandableViewSelectedData(bool isDoubleTapped) {
    switch (widget.contentType) {
      case 'behavior.presleep':
        String text = widget.valuesList[whichSleepItemSelected].text;
        String preCondition = widget.sleepExpandableWidgetList[0].precondition;

        if (preCondition.contains(text)) {
          List<Values> values = widget.sleepExpandableWidgetList[0].values;
          values.forEach((element) {
            if (element.isSelected) {
              widget.selectedAnswers.add(SelectedAnswers(questionTag: 'behavior.sleep', answer: element.valueNumber));
              widget.doubleTapSelectedAnswer.add(SelectedAnswers(questionTag: 'behavior.sleep', answer: element.valueNumber));
            }
          });
        } else {
          widget.selectedAnswers.removeWhere(
                  (element) => element.questionTag == 'behavior.sleep');
          widget.doubleTapSelectedAnswer.removeWhere(
                  (element) => element.questionTag == 'behavior.sleep');
        }
        break;
      case 'medication':
        if(isDoubleTapped) {
          SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere(
                  (element) => element.questionTag == 'administered',
              orElse: () => null);

          if (selectedAnswers == null) {
            widget.selectedAnswers.add(SelectedAnswers(
                questionTag: 'administered',
                answer: medicationSelectedDataModelToJson(
                    _medicationSelectedDataModel)));

          } else {
            selectedAnswers.answer =
                medicationSelectedDataModelToJson(_medicationSelectedDataModel);
          }
        } else {
          if(_medicationSelectedDataModel.selectedMedicationIndex.isEmpty)
            widget.selectedAnswers.removeWhere((element) => element.questionTag == 'administered');
        }

        MedicationSelectedDataModel medicationSelectedDataModel = MedicationSelectedDataModel.fromJson(jsonDecode(jsonEncode(_medicationSelectedDataModel)));

        List<Values> nonDoubleTappedMedicationList = [];
        List<List<String>> nonDoubleTappedDosageList = [];
        List<List<String>> nonDoubleTappedDateList = [];

        medicationSelectedDataModel.selectedMedicationIndex.asMap().forEach((index, element) {
          if(!element.isDoubleTapped) {
            nonDoubleTappedMedicationList.add(element);

            nonDoubleTappedDosageList.add(medicationSelectedDataModel.selectedMedicationDosageList[index]);
            nonDoubleTappedDateList.add(medicationSelectedDataModel.selectedMedicationDateList[index]);
          }
        });

        medicationSelectedDataModel.selectedMedicationIndex.retainWhere((element) => element.isDoubleTapped);

        nonDoubleTappedDosageList.forEach((element) {
          medicationSelectedDataModel.selectedMedicationDosageList.remove(element);
        });

        nonDoubleTappedDateList.forEach((element) {
          medicationSelectedDataModel.selectedMedicationDateList.remove(element);
        });

        print('BeforeLengthOfMeds???${medicationSelectedDataModel.selectedMedicationIndex.length}');

        print('Meds???${medicationSelectedDataModel.selectedMedicationIndex}');

        medicationSelectedDataModel.selectedMedicationIndex.retainWhere((element) => element.isDoubleTapped);

        print('AfterLengthOfMeds???${medicationSelectedDataModel.selectedMedicationIndex.length}');

        if(isDoubleTapped) {
          SelectedAnswers selectedAnswers = widget.doubleTapSelectedAnswer.firstWhere(
                  (element) => element.questionTag == 'administered',
              orElse: () => null);
          if (selectedAnswers == null) {
            widget.doubleTapSelectedAnswer.add(SelectedAnswers(
                questionTag: 'administered',
                answer: medicationSelectedDataModelToJson(
                    medicationSelectedDataModel)));

            print('MedicationDataDoubleTappedSave???${widget.doubleTapSelectedAnswer.last.answer}');
          } else {
            selectedAnswers.answer =
                medicationSelectedDataModelToJson(medicationSelectedDataModel);
            print('MedicationDataDoubleTappedSave???${selectedAnswers.answer}');
          }
        } else {
          MedicationSelectedDataModel medicationSelectedDataModel = MedicationSelectedDataModel.fromJson(jsonDecode(jsonEncode(_medicationSelectedDataModel)));

          print('BeforeLengthOfMeds???${medicationSelectedDataModel.selectedMedicationIndex.length}');

          medicationSelectedDataModel.selectedMedicationIndex.retainWhere((element) => element.isDoubleTapped);

          print('AfterLengthOfMeds???${medicationSelectedDataModel.selectedMedicationIndex.length}');

          if(medicationSelectedDataModel.selectedMedicationIndex.isEmpty)
            widget.doubleTapSelectedAnswer.removeWhere((element) => element.questionTag == 'administered');
        }
        break;
      case 'triggers1':
        widget.valuesList.forEach((element) {
          if (element.isDoubleTapped && element.isSelected) {
            Questions questionTriggerData = widget.triggerExpandableWidgetList
                .firstWhere(
                    (element1) => element1.precondition.contains(element.text),
                orElse: () => null);
            if (questionTriggerData != null) {
              SelectedAnswers selectedAnswerTriggerData =
              selectedAnswerListOfTriggers.firstWhere(
                      (element1) =>
                  element1.questionTag == questionTriggerData.tag,
                  orElse: () => null);
              if (selectedAnswerTriggerData != null) {
                SelectedAnswers selectedAnswerData = widget.selectedAnswers
                    .firstWhere(
                        (element1) =>
                    element1.questionTag ==
                        selectedAnswerTriggerData.questionTag,
                    orElse: () => null);
                if (selectedAnswerData == null) {
                  widget.selectedAnswers.add(SelectedAnswers(
                      questionTag: selectedAnswerTriggerData.questionTag,
                      answer: selectedAnswerTriggerData.answer));
                } else {
                  selectedAnswerData.answer = selectedAnswerTriggerData.answer;
                }
              }
            }
          }
        });

        widget.valuesList.forEach((element) {
          if (element.isDoubleTapped && element.isSelected) {
            Questions questionTriggerData = widget.triggerExpandableWidgetList
                .firstWhere(
                    (element1) => element1.precondition.contains(element.text),
                orElse: () => null);
            if (questionTriggerData != null) {
              SelectedAnswers selectedAnswerTriggerData =
              selectedAnswerListOfTriggers.firstWhere(
                      (element1) =>
                  element1.questionTag == questionTriggerData.tag,
                  orElse: () => null);
              if (selectedAnswerTriggerData != null) {
                SelectedAnswers selectedAnswerData = widget.doubleTapSelectedAnswer
                    .firstWhere(
                        (element1) =>
                    element1.questionTag ==
                        selectedAnswerTriggerData.questionTag,
                    orElse: () => null);
                if (selectedAnswerData == null) {
                  widget.doubleTapSelectedAnswer.add(SelectedAnswers(questionTag: selectedAnswerTriggerData.questionTag, answer: selectedAnswerTriggerData.answer));
                } else {
                  selectedAnswerData.answer = selectedAnswerTriggerData.answer;
                }
              }
            }
          }
        });
        break;
    }
  }

  void storeLogDayDataIntoDatabase() async {
    print(widget.doubleTapSelectedAnswer);
    List<Map> userLogDataMap;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    if(userProfileInfoData != null)
      userLogDataMap = await SignUpOnBoardProviders.db.getLogDayData(userProfileInfoData.userId);
    else
      userLogDataMap = await SignUpOnBoardProviders.db.getLogDayData('4214');

    if (userLogDataMap == null || userLogDataMap.length == 0) {
      LogDayQuestionnaire logDayQuestionnaire = LogDayQuestionnaire();
      var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
      if(userProfileInfoData != null)
        logDayQuestionnaire.userId = userProfileInfoData.userId;
      else
        logDayQuestionnaire.userId = '4214';

      logDayQuestionnaire.selectedAnswers = jsonEncode(widget.doubleTapSelectedAnswer);
      SignUpOnBoardProviders.db.insertLogDayData(logDayQuestionnaire);
    } else {
      var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

      if(userProfileInfoData != null)
        SignUpOnBoardProviders.db.updateLogDayData(jsonEncode(widget.doubleTapSelectedAnswer), userProfileInfoData.userId);
      else
        SignUpOnBoardProviders.db.updateLogDayData(jsonEncode(widget.doubleTapSelectedAnswer), '4214');
    }
  }

  void _onSleepItemSelected(int index) {
    String preCondition = widget.sleepExpandableWidgetList[0].precondition;
    String text = widget.valuesList[index].text;
    String valueNumber = widget.valuesList[index].valueNumber;
    bool isSelected = widget.valuesList[index].isSelected;

    whichSleepItemSelected = index;

    _updateSelectedAnswerListWhenCircleItemSelected(valueNumber, isSelected);

    if (preCondition.contains(text) && isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      widget.selectedAnswers.removeWhere((element) => element.questionTag == widget.sleepExpandableWidgetList[0].tag);
      widget.doubleTapSelectedAnswer.removeWhere((element) => element.questionTag == widget.sleepExpandableWidgetList[0].tag);
    }
  }

  void _onExerciseItemSelected(int index) {
    String valueNumber = widget.valuesList[index].valueNumber;
    bool isSelected = widget.valuesList[index].isSelected;
    _updateSelectedAnswerListWhenCircleItemSelected(valueNumber, isSelected);
  }

  void _onMedicationItemSelected(int index) {
    if (widget.valuesList[index].text == Constant.plusText) {
      _openAddNewMedicationDialog();
    } else {
      setState(() {
        int indexValue = whichMedicationItemSelected.firstWhere((element) => element == index, orElse: () => null);

        if(indexValue == null)
          whichMedicationItemSelected.add(index);
      });

      Values value = widget.valuesList.firstWhere((element) => element.isSelected, orElse: () => null);

      if (value != null) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        widget.selectedAnswers.removeWhere((element) =>
        element.questionTag == 'administered');
      }

      String valueNumber = widget.valuesList[index].valueNumber;
      bool isSelected = widget.valuesList[index].isSelected;
      bool isNewlyAdded = widget.valuesList[index].isNewlyAdded;

      if(!isSelected) {
        whichMedicationItemSelected.remove(index);
      }

      if(isNewlyAdded && isSelected) {
        if(_additionalMedicationDosage[index].length < _numberOfDosageAddedList[index] + 1) {
          for (var i = 0; i < _numberOfDosageAddedList[index] + 1; i++) {
            _additionalMedicationDosage[index].add('50 mg');
          }
        }
      }

      _updateMedicationSelectedDataModel();
      _updateSelectedAnswerListWhenCircleItemSelected(valueNumber, isSelected);
      _storeExpandedWidgetDataIntoLocalModel();
    }
  }

  void _onTriggerItemSelected(int index) {
    setState(() {
      whichTriggerItemSelected = index;
    });

    Values value = widget.valuesList.firstWhere((element) => element.isSelected, orElse: () => null);

    if (value != null) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    String valueNumber = widget.valuesList[index].valueNumber;
    String valueText = widget.valuesList[index].text;
    bool isSelected = widget.valuesList[index].isSelected;

    if(valueText.toLowerCase() == Constant.none && isSelected) {
      setState(() {
        widget.valuesList.asMap().forEach((key, element) {
          if(index != key) {
            element
              ..isSelected = false
              ..isDoubleTapped = false;
          }
        });
        _triggerWidgetList.clear();
      });

      widget.selectedAnswers.removeWhere((element) => element.questionTag.contains('triggers1'));
    } else if (isSelected) {
      Values noneValue = widget.valuesList.firstWhere((element) => element.text.toLowerCase() == Constant.none, orElse: () => null);
      if(noneValue != null) {
        setState(() {
          noneValue
            ..isSelected = false
            ..isDoubleTapped = false;
        });
      }

      //'1' for none option
      widget.selectedAnswers.removeWhere((element) => element.questionTag == 'triggers1' && element.answer == '1');
    }

    if(!isSelected) {
      Questions triggerExpandableQuestionObj = widget.triggerExpandableWidgetList.firstWhere((element) => element.precondition.toLowerCase().contains(valueText.toLowerCase()), orElse: () => null);
      if(triggerExpandableQuestionObj != null)
        widget.selectedAnswers.removeWhere((element) => element.questionTag == triggerExpandableQuestionObj.tag);
    }

    _updateSelectedAnswerListWhenCircleItemSelected(valueNumber, isSelected);
    _storeExpandedWidgetDataIntoLocalModel();
  }

  Widget _getWidget(Widget mainWidget) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.headerText,
              style: TextStyle(
                  fontSize: Platform.isAndroid ? 16 : 17,
                  color: Constant.chatBubbleGreen,
                  fontFamily: Constant.jostMedium),
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.subText,
              style: TextStyle(
                  fontSize: Platform.isAndroid ? 14 : 15,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        mainWidget,
        SizeTransition(
          sizeFactor: _animationController,
          child: FadeTransition(
              opacity: _animationController,
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 350),
                child: _getOptionOnSelectWidget(),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            height: 40,
            thickness: 0.5,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
    );
  }

  /// This method is used to get the widget which will get displayed when user select any option of any of a section
  Widget _getOptionOnSelectWidget() {
    switch (widget.contentType) {
      case 'behavior.presleep':
        Questions expandableWidgetData = widget.sleepExpandableWidgetList[0];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                expandableWidgetData.helpText,
                style: TextStyle(
                    color: Constant.locationServiceGreen,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                    fontSize: Platform.isAndroid ? 14 : 15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  physics: Utils.getScrollPhysics(),
                  child: Wrap(children: _getChipsWidget()),
                ),
              ),
            ),
          ],
        );
      case 'medication':
        List<Widget> widgetList = [];
        whichMedicationItemSelected.forEach((index) {
          String medName = widget.valuesList[index].text;

          print('MedicationName???$medName');

          Questions questions = widget.medicationExpandableWidgetList.firstWhere(
                  (element) {
                List<String> splitConditionList = element.precondition.split('=');
                if(splitConditionList.length == 2) {
                  splitConditionList[0] = splitConditionList[0].trim();
                  splitConditionList[1] = splitConditionList[1].trim();

                  return (medName == splitConditionList[1]);
                } else {
                  return false;
                }
              },
              orElse: () => null);

          print('MedicationOnSelect???$questions');

          DateTime _medicationDateTime = DateTime.now();

          try {
            _medicationDateTime = DateTime.parse(_medicineTimeList[index][0]);
          } catch(e) {
            print(e.toString());
          }

          widgetList.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'When did you take $medName?',
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontFamily: Constant.jostRegular,
                          fontSize: Platform.isAndroid ? 14 : 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Constant.backgroundTransparentColor,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _whichExpandedMedicationItemSelected = 0;
                              _openDatePickerBottomSheet(
                                  CupertinoDatePickerMode.time, index);
                            },
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                Utils.getTimeInAmPmFormat(_medicationDateTime.hour, _medicationDateTime.minute),
                                style: TextStyle(
                                    color: Constant.splashColor,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: Platform.isAndroid ? 14 : 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      (questions == null)
                          ? 'What dosage did you take?'
                          : questions.helpText,
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontFamily: Constant.jostRegular,
                          fontSize: Platform.isAndroid ? 14 : 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if(_medicationDosageList[index][0].values != null)
                    Container(
                      height: 30,
                      child: LogDayChipList(
                        question: _medicationDosageList[index][0],
                        onSelectCallback: _onMedicationChipSelectedCallback,
                      ),
                    )
                  else
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Constant.backgroundTransparentColor,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _showMedicationDosagePicker(0, index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constant.backgroundTransparentColor,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Text(
                                          (_additionalMedicationDosage[index].length >= 1) ? _additionalMedicationDosage[index][0] : '50 mg',
                                          style: TextStyle(
                                              color: Constant.splashColor,
                                              fontFamily: Constant.jostRegular,
                                              fontSize: Platform.isAndroid ? 14 : 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  _getAddedDosageList(index),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _numberOfDosageAddedList[index] = _numberOfDosageAddedList[index] + 1;
                          _medicineTimeList[index].add(DateTime.now().toString());
                          _additionalMedicationDosage[index].add('50 mg');

                          _updateMedicationSelectedDataModel();
                          _storeExpandedWidgetDataIntoLocalModel();

                          String medName = widget.valuesList[index].text;
                          Questions questions1 = widget.medicationExpandableWidgetList.firstWhere(
                                  (element) {
                                List<String> splitConditionList = element.precondition.split('=');
                                if(splitConditionList.length == 2) {
                                  splitConditionList[0] = splitConditionList[0].trim();
                                  splitConditionList[1] = splitConditionList[1].trim();

                                  return (medName == splitConditionList[1]);
                                } else {
                                  return false;
                                }
                              },
                              orElse: () => null);

                          if(questions1 != null) {
                            List<Values> valuesList = [];

                            questions1.values.forEach((element) {
                              valuesList.add(Values(text: element.text,
                                  valueNumber: element.valueNumber,
                                  isSelected: element.isSelected));
                            });

                            Questions questions2 = Questions(
                                tag: questions1.tag,
                                id: questions1.id,
                                questionType: questions1.questionType,
                                precondition: questions1.precondition,
                                next: questions1.next,
                                text: questions1.text,
                                helpText: questions1.helpText,
                                values: valuesList,
                                min: questions1.min,
                                max: questions1.max,
                                updatedAt: questions1.updatedAt,
                                exclusiveValue: questions1.exclusiveValue,
                                phi: questions1.phi,
                                required: questions1.required,
                                uiHints: questions1.uiHints,
                                currentValue: questions1.currentValue
                            );
                            _medicationDosageList[index].add(
                                questions2);
                          } else {
                            _medicationDosageList[index].add(
                                Questions());
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+ ',
                              style: TextStyle(
                                fontSize: Platform.isAndroid ? 14 : 15,
                                color: Constant.addCustomNotificationTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: Constant.jostRegular,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Add another dosage time for $medName',
                                style: TextStyle(
                                  fontSize: Platform.isAndroid ? 14 : 15,
                                  color: Constant.addCustomNotificationTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.jostRegular,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
          );
        });

        /*if(_selectedDateTime != null)
          _medicationDateTime = DateTime(_medicationDateTime.year, _medicationDateTime.month, _medicationDateTime.day, _selectedDateTime.);*/

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgetList,
        );
      case 'triggers1':
        if (_triggerWidgetList == null) {
          _triggerWidgetList = [];
        }

        String triggerName = widget.valuesList[whichTriggerItemSelected].text;

        bool isSelected =
            widget.valuesList[whichTriggerItemSelected].isSelected;
        Questions questions = widget.triggerExpandableWidgetList.firstWhere(
                (element) => element.precondition.toLowerCase().contains(triggerName.toLowerCase()),
            orElse: () => null);
        String questionTag = (questions == null) ? '' : questions.tag;
        TriggerWidgetModel triggerWidgetModel = _triggerWidgetList.firstWhere(
                (element) => element.questionTag == questionTag,
            orElse: () => null);

        String selectedTriggerValue;
        SelectedAnswers selectedAnswerTriggerData = selectedAnswerListOfTriggers
            .firstWhere((element) => element.questionTag == questionTag,
            orElse: () => null);
        if (selectedAnswerTriggerData != null) {
          selectedTriggerValue = selectedAnswerTriggerData.answer;
        }

        if (triggerWidgetModel == null) {
          if (questions == null) {
            _triggerWidgetList
                .add(TriggerWidgetModel(questionTag: "", widget: Container()));
          } else {
            switch (questions.questionType) {
              case 'number':
                _triggerWidgetList.add(TriggerWidgetModel(
                    questionTag: questions.tag,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            questions.helpText,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostRegular,
                                fontSize: Platform.isAndroid ? 14 : 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SignUpAgeScreen(
                          currentTag: questions.tag,
                          sliderValue: (selectedTriggerValue != null)
                              ? double.parse(selectedTriggerValue)
                              : questions.min.toDouble(),
                          sliderMinValue: questions.min.toDouble(),
                          sliderMaxValue: questions.max.toDouble(),
                          minText: questions.min.toString(),
                          maxText: questions.max.toString(),
                          labelText: '',
                          isAnimate: false,
                          horizontalPadding: 0,
                          onValueChangeCallback: onValueChangedCallback,
                          uiHints: questions.uiHints,
                        ),
                      ],
                    )));
                break;
              case 'text':
                _triggerWidgetList.add(TriggerWidgetModel(
                    questionTag: questions.tag,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            questions.helpText,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostRegular,
                                fontSize: Platform.isAndroid ? 14 : 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            minLines: 5,
                            maxLines: 6,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            onChanged: (text) {
                              onValueChangedCallback(questionTag, text.trim());
                            },
                            initialValue: (selectedTriggerValue != null)
                                ? selectedTriggerValue
                                : '',
                            style: TextStyle(
                                fontSize: Platform.isAndroid ? 14 : 15,
                                fontFamily: Constant.jostMedium,
                                color: Constant.unselectedTextColor),
                            cursorColor: Constant.unselectedTextColor,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              hintText: Constant.tapToType,
                              hintStyle: TextStyle(
                                  fontSize: Platform.isAndroid ? 14 : 15,
                                  color: Constant.unselectedTextColor,
                                  fontFamily: Constant.jostRegular),
                              filled: true,
                              fillColor: Constant.backgroundTransparentColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(3)),
                                borderSide: BorderSide(
                                    color: Constant.backgroundTransparentColor,
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(3)),
                                borderSide: BorderSide(
                                    color: Constant.backgroundTransparentColor,
                                    width: 1),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )));
                break;
              case 'multi':
                try {
                  if (selectedTriggerValue != null) {
                    Questions questionTrigger =
                    Questions.fromJson(jsonDecode(selectedTriggerValue));
                    questions = questionTrigger;
                    print(questionTrigger);
                  }
                } catch (e) {
                  print(e.toString());
                }
                _triggerWidgetList.add(TriggerWidgetModel(
                    questionTag: questions.tag,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            questions.helpText,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostRegular,
                                fontSize: Platform.isAndroid ? 14 : 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 30,
                            child: LogDayChipList(
                              question: questions,
                              onSelectCallback: onValueChangedCallback,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )));
                break;
              default:
                _triggerWidgetList.add(TriggerWidgetModel(
                    questionTag: questions.tag, widget: Container()));
            }
          }
        } else {
          if (!isSelected) {
            _triggerWidgetList.remove(triggerWidgetModel);
            selectedAnswerListOfTriggers
                .removeWhere((element) => element.questionTag == questionTag);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_triggerWidgetList.length,
                  (index) => _triggerWidgetList[index].widget),
        );
      default:
        return Container();
    }
  }

  void _onMedicationChipSelectedCallback(String tag, String data) {
    _updateMedicationSelectedDataModel();
    _storeExpandedWidgetDataIntoLocalModel();
  }

  Widget _getAddedDosageList(int index1) {
    if(_numberOfDosageAddedList[index1] > 0) {
      String medName = widget.valuesList[index1].text;
      Questions questions = widget.medicationExpandableWidgetList.firstWhere(
              (element) {
            List<String> splitConditionList = element.precondition.split('=');
            if(splitConditionList.length == 2) {
              splitConditionList[0] = splitConditionList[0].trim();
              splitConditionList[1] = splitConditionList[1].trim();

              return (medName == splitConditionList[1]);
            } else {
              return false;
            }
          },
          orElse: () => null);

      DateTime medicationDateTime = DateTime.now();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_numberOfDosageAddedList[index1], (index) {
          try {
            medicationDateTime = DateTime.parse(_medicineTimeList[index1][index + 1]);
          } catch(e) {
            print(e.toString());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'When did you take $medName?',
                  style: TextStyle(
                      color: Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular,
                      fontSize: Platform.isAndroid ? 14 : 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: Constant.backgroundTransparentColor,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _whichExpandedMedicationItemSelected = index + 1;
                          _openDatePickerBottomSheet(
                              CupertinoDatePickerMode.time, index1);
                        },
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            Utils.getTimeInAmPmFormat(
                                medicationDateTime.hour,
                                medicationDateTime
                                    .minute),
                            style: TextStyle(
                                color: Constant.splashColor,
                                fontFamily: Constant.jostRegular,
                                fontSize: Platform.isAndroid ? 14 : 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _numberOfDosageAddedList[index1] = _numberOfDosageAddedList[index1] - 1;
                      _medicineTimeList[index1].removeAt(index + 1);
                      _medicationDosageList[index1].removeAt(index + 1);
                      try {
                        _additionalMedicationDosage[index1]
                            .removeAt(index + 1);
                      } catch(e) {
                        print(e);
                      }
                      _updateMedicationSelectedDataModel();
                      _storeExpandedWidgetDataIntoLocalModel();
                    });
                  },
                  child: Text(
                    'Tap here to remove this dose',
                    style: TextStyle(
                      fontSize: Platform.isAndroid ? 14 : 15,
                      color: Constant.addCustomNotificationTextColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: Constant.jostRegular,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  (questions == null)
                      ? 'What dosage did you take?'
                      : questions.helpText,
                  style: TextStyle(
                      color: Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular,
                      fontSize: Platform.isAndroid ? 14 : 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if(_medicationDosageList[index1][index + 1].values != null)
                Container(
                  height: 30,
                  child: LogDayChipList(
                    question: _medicationDosageList[index1][index + 1],
                    onSelectCallback: _onMedicationChipSelectedCallback,
                  ),
                )
              else
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Constant.backgroundTransparentColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _showMedicationDosagePicker(index + 1, index1);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Constant.backgroundTransparentColor,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text(
                                      (_additionalMedicationDosage[index1].length >= index + 2) ? _additionalMedicationDosage[index1][index + 1] : '50 mg',
                                      style: TextStyle(
                                          color: Constant.splashColor,
                                          fontFamily: Constant.jostRegular,
                                          fontSize: Platform.isAndroid ? 14 : 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        }),
      );
    } else {
      return Container();
    }
  }

  void onValueChangedCallback(String currentTag, String value) {
    SelectedAnswers selectedAnswersObj = selectedAnswerListOfTriggers
        .firstWhere((element) => element.questionTag == currentTag,
        orElse: () => null);
    if (selectedAnswersObj != null) {
      selectedAnswersObj.answer = value;
    } else {
      selectedAnswerListOfTriggers
          .add(SelectedAnswers(questionTag: currentTag, answer: value));
    }

    _storeExpandedWidgetDataIntoLocalModel();
  }

  /// This method is used to get list of chips widget which will be shown when user taps on the options of sleep section
  List<Widget> _getChipsWidget() {
    List<Widget> chipsList = [];

    widget.sleepExpandableWidgetList[0].values.forEach((element) {
      chipsList.add(GestureDetector(
        onTap: () {
          setState(() {
            if (element.isSelected) {
              element.isSelected = false;
              element.isDoubleTapped = false;
            } else {
              element.isSelected = true;
            }
            _storeExpandedWidgetDataIntoLocalModel();
          });
        },
        onDoubleTap: () {
          /*setState(() {
            if(element.isDoubleTapped) {
              element.isDoubleTapped = false;
            } else {
              element.isDoubleTapped = true;
              if(!element.isSelected) {
                numberOfSleepItemSelected++;
              }
              element.isSelected = true;
            }
          });*/
        },
        child: Container(
          margin: EdgeInsets.only(
            right: 5,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: /*element.isDoubleTapped ? Constant.doubleTapTextColor : Constant.chatBubbleGreen*/ Constant
                    .chatBubbleGreen,
                width: element.isDoubleTapped ? /*2*/ 1 : 1),
            color: element.isSelected
                ? Constant.chatBubbleGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              element.text,
              style: TextStyle(
                  color: element.isSelected
                      ? Constant.bubbleChatTextView
                      : Constant.locationServiceGreen,
                  fontSize: Platform.isAndroid ? 12 : 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: Constant.jostRegular),
            ),
          ),
        ),
      ));
    });

    return chipsList;
  }

  @override
  void initState() {
    super.initState();

    _selectedDateTime = widget.selectedDateTime;

    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    if (widget.selectedAnswers != null) {
      widget.selectedAnswers.forEach((element) {
        if (element.questionTag.contains('triggers1.')) {
          selectedAnswerListOfTriggers.add(element);
        }
      });
    }

    if (widget.contentType == 'medication') {
      SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere((element) => element.questionTag == 'administered', orElse: () => null);

      if(selectedAnswers != null)
        _medicationSelectedDataModel = MedicationSelectedDataModel.fromJson(json.decode(selectedAnswers.answer));

      if(_medicationSelectedDataModel != null) {
        List<Values> selectedMedicationValue = _medicationSelectedDataModel.selectedMedicationIndex;

        selectedMedicationValue.forEach((element) {
          if(element.isNewlyAdded) {
            //widget.valuesList.add(Values(valueNumber: (widget.valuesList.length + 1).toString(), text: element.text, isSelected: true, isDoubleTapped: true, isNewlyAdded: true));
            widget.valuesList.add(element);
            widget.valuesList.last.valueNumber = (widget.valuesList.length + 1).toString();
            widget.valuesList.last.isSelected = true;
            widget.valuesList.last.isDoubleTapped = element.isDoubleTapped ?? false;
          } else {
            Values medValue = widget.valuesList.firstWhere((element1) => element1.text == element.text, orElse: () => null);
            if(medValue != null) {
              medValue.isSelected = true;
              medValue.isDoubleTapped = element.isDoubleTapped;
            }
          }
        });
      }

      for (var i = 0; i < widget.valuesList.length; i++) {
        _medicineTimeList.add(List.generate(1, (index) => DateTime.now().toString()));
        _additionalMedicationDosage.add([]);
      }

      _numberOfDosageAddedList = List.generate(widget.valuesList.length, (index) => 0);

      for(var i = 0; i < widget.valuesList.length; i++) {
        String medName = widget.valuesList[i].text;
        Questions questions = widget.medicationExpandableWidgetList.firstWhere(
                (element) {
              List<String> splitConditionList = element.precondition.split('=');
              if(splitConditionList.length == 2) {
                splitConditionList[0] = splitConditionList[0].trim();
                splitConditionList[1] = splitConditionList[1].trim();

                return (medName == splitConditionList[1]);
              } else {
                return false;
              }
            },
            orElse: () => null);

        if(questions != null) {
          List<Values> valuesList = [];

          questions.values.forEach((element) {
            valuesList.add(Values(text: element.text,
                valueNumber: element.valueNumber,
                isSelected: element.isSelected));
          });

          Questions questions1 = Questions(
              tag: questions.tag,
              id: questions.id,
              questionType: questions.questionType,
              precondition: questions.precondition,
              next: questions.next,
              text: questions.text,
              helpText: questions.helpText,
              values: valuesList,
              min: questions.min,
              max: questions.max,
              updatedAt: questions.updatedAt,
              exclusiveValue: questions.exclusiveValue,
              phi: questions.phi,
              required: questions.required,
              uiHints: questions.uiHints,
              currentValue: questions.currentValue
          );
          _medicationDosageList.add(List.generate(1, (index) => questions1));
        } else {
          _medicationDosageList.add(List.generate(1, (index) => Questions()));
        }
      }

      if(_medicationSelectedDataModel != null) {
        /*if(_medicationSelectedDataModel.isNewlyAdded) {
          _medicationSelectedDataModel.selectedMedicationIndex.add((widget.valuesList.length - 1).toString());
          storeExpandableViewSelectedData(true);
        }*/

        List<int> selectedMedicationIndexList = [];

        _medicationSelectedDataModel.selectedMedicationIndex.forEach((element) {
          Values medValue = widget.valuesList.firstWhere((element1) => element.text == element1.text, orElse: () => null);
          if(medValue != null) {
            int indexOfMedication = widget.valuesList.indexOf(medValue);
            selectedMedicationIndexList.add(indexOfMedication);
          } else {
            print('in here???${widget.valuesList.length}');
            widget.valuesList.add(Values(text: element.text, isNewlyAdded: true, valueNumber: (widget.valuesList.length + 1).toString(), isSelected: true, isDoubleTapped: element.isDoubleTapped ?? false));
            print('in here???${widget.valuesList.length}');
            selectedMedicationIndexList.add(widget.valuesList.length - 1);
            _numberOfDosageAddedList.add(0);
            _additionalMedicationDosage.add([]);
            _medicineTimeList.add(List.generate(1, (index) => DateTime.now().toString()));
          }
        });

        whichMedicationItemSelected = selectedMedicationIndexList;

        whichMedicationItemSelected.asMap().forEach((key, selectedMedicationIndex) {
          widget.valuesList[selectedMedicationIndex].isSelected = true;
          widget.valuesList[selectedMedicationIndex].isDoubleTapped = widget.valuesList[selectedMedicationIndex].isDoubleTapped ?? true;
          _numberOfDosageAddedList[selectedMedicationIndex] = _medicationSelectedDataModel.selectedMedicationDateList[key].length - 1;
          _medicineTimeList[selectedMedicationIndex] = _medicationSelectedDataModel.selectedMedicationDateList[key];

          for(var i = 0; i < _numberOfDosageAddedList[selectedMedicationIndex]; i++) {
            String medName = widget.valuesList[selectedMedicationIndex].text;
            Questions questions = widget.medicationExpandableWidgetList.firstWhere(
                    (element) {
                  List<String> splitConditionList = element.precondition.split('=');
                  if(splitConditionList.length == 2) {
                    splitConditionList[0] = splitConditionList[0].trim();
                    splitConditionList[1] = splitConditionList[1].trim();

                    return (medName == splitConditionList[1]);
                  } else {
                    return false;
                  }
                },
                orElse: () => null);

            if(questions != null) {
              List<Values> valuesList = [];

              questions.values.forEach((element) {
                valuesList.add(Values(text: element.text,
                    valueNumber: element.valueNumber,
                    isSelected: element.isSelected));
              });

              Questions questions1 = Questions(
                  tag: questions.tag,
                  id: questions.id,
                  questionType: questions.questionType,
                  precondition: questions.precondition,
                  next: questions.next,
                  text: questions.text,
                  helpText: questions.helpText,
                  values: valuesList,
                  min: questions.min,
                  max: questions.max,
                  updatedAt: questions.updatedAt,
                  exclusiveValue: questions.exclusiveValue,
                  phi: questions.phi,
                  required: questions.required,
                  uiHints: questions.uiHints,
                  currentValue: questions.currentValue
              );
              _medicationDosageList[selectedMedicationIndex].add(questions1);
            } else {
              _medicationDosageList[selectedMedicationIndex].add(Questions());
            }
          }

          if(_medicationSelectedDataModel.selectedMedicationDosageList[key].length > 0) {
              //if(index == 0) {
              _medicationSelectedDataModel.selectedMedicationDosageList[key].asMap().forEach((index, value) {
                  try {
                    int selectedValueIndex = int.parse(value) - 1;
                    _medicationDosageList[selectedMedicationIndex][index].values[selectedValueIndex].isSelected = true;
                  } catch(e) {
                    print(e.toString());
                    _additionalMedicationDosage[selectedMedicationIndex].add(value);
                  }
                });
          }
        });
      }

      print(_medicationSelectedDataModel);
    }
    if(widget.isFromRecordsScreen)
      _updateDoubleTapSelectedAnswersList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getSectionWidget();
  }

  /// @param cupertinoDatePickerMode: for time and date mode selection
  /// @param whichPickerClicked: 0 for startDate, 1 for startTime, 2 for endDate, 3 for endTime
  void _openDatePickerBottomSheet(
      CupertinoDatePickerMode cupertinoDatePickerMode, int index) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
          cupertinoDatePickerMode: cupertinoDatePickerMode,
          onDateTimeSelected: (DateTime dateTime) {
            setState(() {
              _medicineTimeList[index][_whichExpandedMedicationItemSelected] = dateTime.toString();
            });

            _updateMedicationSelectedDataModel();

            _storeExpandedWidgetDataIntoLocalModel(index);
          },
        ));
  }

  ///This method is to update medication Data Model
  void _updateMedicationSelectedDataModel() {
    List<List<String>> selectedMedicationDosageList = [];
    List<List<String>> selectedMedicationDateList = [];

    var selectedMedicationValueList = widget.valuesList.where((element) => element.isSelected).toList();

    selectedMedicationValueList.forEach((element1) {
      int medicationIndex = widget.valuesList.indexOf(element1);
      List<String> selectedDosageList = [];

      selectedMedicationDateList.add(_medicineTimeList[medicationIndex]);

      if(element1.isNewlyAdded) {
        selectedMedicationDosageList.add(_additionalMedicationDosage[medicationIndex]);
      }else {
        _medicationDosageList[medicationIndex].forEach((element2) {
          if(element2.values != null) {
            element2.values.forEach((element3) {
              if(element3.isSelected) {
                selectedDosageList.add(element3.valueNumber);
              }
            });
          }
        });
        selectedMedicationDosageList.add(selectedDosageList);
      }
    });

    _medicationSelectedDataModel = MedicationSelectedDataModel(
      selectedMedicationIndex: selectedMedicationValueList,
      selectedMedicationDateList: selectedMedicationDateList,
      selectedMedicationDosageList: selectedMedicationDosageList,
    );
  }

  void _updateSelectedAnswerListWhenCircleItemSelected(String selectedAnswer, bool isSelected) {
    if(isSelected) {
      if (widget.questionType == 'multi') {
        SelectedAnswers selectedAnswersValue = widget.selectedAnswers.firstWhere((element) => element.questionTag == widget.contentType && element.answer == selectedAnswer, orElse: () => null);
        if(selectedAnswersValue == null)
          widget.selectedAnswers.add(SelectedAnswers(questionTag: widget.contentType, answer: selectedAnswer));
      } else {
        SelectedAnswers selectedAnswerObj = widget.selectedAnswers.firstWhere(
                (element) => element.questionTag == widget.contentType,
            orElse: () => null);
        if (selectedAnswerObj == null) {
          widget.selectedAnswers.add(
              SelectedAnswers(
                  questionTag: widget.contentType, answer: selectedAnswer));
        } else {
          selectedAnswerObj.answer = selectedAnswer;
        }
      }
    } else {
      if (widget.questionType == 'multi') {
        List<SelectedAnswers> selectedAnswerList = [];
        widget.selectedAnswers.forEach((element) {
          if (element.questionTag == widget.contentType &&
              element.answer == selectedAnswer) {
            selectedAnswerList.add(element);
          }
        });

        selectedAnswerList.forEach((element) {
          widget.selectedAnswers.remove(element);
        });
      } else {
        SelectedAnswers selectedAnswerObj = widget.selectedAnswers.firstWhere(
                (element) => element.questionTag == widget.contentType,
            orElse: () => null);

        if (selectedAnswerObj != null) {
          widget.selectedAnswers.remove(selectedAnswerObj);
        }
      }
    }
  }

  void _storeExpandedWidgetDataIntoLocalModel([int selectedMedicationIndex]) {
    switch (widget.contentType) {
      case 'behavior.presleep':
        String text = widget.valuesList[whichSleepItemSelected].text;
        String preCondition = widget.sleepExpandableWidgetList[0].precondition;

        if (preCondition.contains(text)) {
          List<Values> values = widget.sleepExpandableWidgetList[0].values;

          widget.selectedAnswers.removeWhere((element) => element.questionTag == 'behavior.sleep');

          values.forEach((element) {
            if (element.isSelected) {
              widget.selectedAnswers.add(SelectedAnswers(questionTag: 'behavior.sleep', answer: element.valueNumber));
            }
          });
        } else {
          widget.selectedAnswers.removeWhere(
                  (element) => element.questionTag == 'behavior.sleep');
        }
        break;
      case 'medication':
        widget.selectedAnswers.removeWhere((element) => element.questionTag == 'administered');
        SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere(
                (element) => element.questionTag == 'administered',
            orElse: () => null);
        if (selectedAnswers == null) {
          widget.selectedAnswers.add(SelectedAnswers(
              questionTag: 'administered',
              answer: medicationSelectedDataModelToJson(_medicationSelectedDataModel)));
        } else {
          selectedAnswers.answer =
              medicationSelectedDataModelToJson(_medicationSelectedDataModel);
        }

        if (previousMedicationTag != null) {
          widget.selectedAnswers.removeWhere(
                  (element) => element.questionTag == previousMedicationTag);
        }

        try {
          previousMedicationTag = widget
              .medicationExpandableWidgetList[selectedMedicationIndex].tag;
          Values selectedDosageValue = widget
              .medicationExpandableWidgetList[selectedMedicationIndex]
              .values
              .firstWhere((element) => element.isSelected, orElse: () => null);
          if (selectedDosageValue != null) {
            widget.selectedAnswers.add(SelectedAnswers(
                questionTag: previousMedicationTag,
                answer: selectedDosageValue.valueNumber));
          }
        } catch (e) {
          print(e);
        }
        break;
      case 'triggers1':
        widget.valuesList.forEach((element) {
          if (element.isSelected) {
            Questions questionTriggerData = widget.triggerExpandableWidgetList
                .firstWhere(
                    (element1) => element1.precondition.contains(element.text),
                orElse: () => null);
            if (questionTriggerData != null) {
              SelectedAnswers selectedAnswerTriggerData =
              selectedAnswerListOfTriggers.firstWhere(
                      (element1) =>
                  element1.questionTag == questionTriggerData.tag,
                  orElse: () => null);
              if (selectedAnswerTriggerData != null) {
                SelectedAnswers selectedAnswerData = widget.selectedAnswers
                    .firstWhere(
                        (element1) =>
                    element1.questionTag ==
                        selectedAnswerTriggerData.questionTag,
                    orElse: () => null);
                if (selectedAnswerData == null) {
                  widget.selectedAnswers.add(SelectedAnswers(
                      questionTag: selectedAnswerTriggerData.questionTag,
                      answer: selectedAnswerTriggerData.answer));
                } else {
                  selectedAnswerData.answer = selectedAnswerTriggerData.answer;
                }
              }
            }
          }
        });
        break;
    }
  }

  void _openAddNewMedicationDialog() async{
    /*var addMedicationResult = await */showBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => AddNewMedicationDialog(
          onSubmitClickedCallback: (addMedicationResult) {
            if(addMedicationResult != null && addMedicationResult is String && addMedicationResult != '') {
              setState(() {
                widget.valuesList.insert(widget.valuesList.length - 1, Values(text: addMedicationResult, valueNumber: (widget.valuesList.length).toString(), isNewlyAdded: true));
                _medicineTimeList.add(List.generate(1, (index) => DateTime.now().toString()));
                _medicationDosageList.add(List.generate(1, (index) => Questions()));
                _numberOfDosageAddedList.add(0);
                _additionalMedicationDosage.add([]);
                widget.medicationExpandableWidgetList.add(Questions(precondition: ''));
              });
            }
          },
        )
    );
  }

  ///Method to update double tap selected answers list
  void _updateDoubleTapSelectedAnswersList() {
    widget.doubleTapSelectedAnswer.clear();
    widget.selectedAnswers.forEach((element) {
      if(element.isDoubleTapped ?? false) {
        widget.doubleTapSelectedAnswer.add(element);
      }
    });
  }

  void _showMedicationDosagePicker(int index, int selectedMedicationIndex) async{
    var resultFromActionSheet = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => MedicationDosagePicker(
          selectedDosageValue: _additionalMedicationDosage[selectedMedicationIndex].length >= index + 1 ? _additionalMedicationDosage[selectedMedicationIndex][index] : null,
        ));

    if(resultFromActionSheet != null && resultFromActionSheet is String) {
      SelectedAnswers dosageSelectedAnswer = widget.selectedAnswers.firstWhere((element) => element.questionTag == '${widget.valuesList[selectedMedicationIndex].text}_custom.dosage', orElse: () => null);
      if(dosageSelectedAnswer != null) {
        List<String> selectedValuesList = (json.decode(dosageSelectedAnswer.answer) as List<dynamic>).cast<String>();
        if(selectedValuesList != null && selectedValuesList.length >= 1) {
          selectedValuesList[index] = resultFromActionSheet;
        }
      }
      if(_additionalMedicationDosage[selectedMedicationIndex].length >= index + 1) {
        _additionalMedicationDosage[selectedMedicationIndex][index] = resultFromActionSheet;
      } else {
        _additionalMedicationDosage[selectedMedicationIndex].add(resultFromActionSheet);
      }
      _updateMedicationSelectedDataModel();
      _storeExpandedWidgetDataIntoLocalModel();
      setState(() {

      });
    }
  }
}
