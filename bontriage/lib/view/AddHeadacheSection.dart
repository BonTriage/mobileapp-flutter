import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LogDayQuestionnaire.dart';
import 'package:mobile/models/MedicationSelectedDataModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/TriggerWidgetModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CircleLogOptions.dart';
import 'package:mobile/view/DateTimePicker.dart';
import 'package:mobile/view/LogDayChipList.dart';
import 'package:mobile/view/TimeSection.dart';
import 'package:mobile/view/sign_up_age_screen.dart';

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
  final bool isHeadacheEnded;

  const AddHeadacheSection(
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
      this.isHeadacheEnded})
      : super(key: key);

  @override
  _AddHeadacheSectionState createState() => _AddHeadacheSectionState();
}

class _AddHeadacheSectionState extends State<AddHeadacheSection>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  int numberOfSleepItemSelected = 0;
  int whichSleepItemSelected = 0;
  int whichMedicationItemSelected = 0;
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
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onCircleItemSelected: _onHeadacheTypeItemSelected,
        ));
      case 'onset':
        return _getWidget(TimeSection(
            currentTag: widget.contentType,
            updatedDateValue: widget.updateAtValue,
            addHeadacheDateTimeDetailsData: _onHeadacheDateTimeSelected,
            isHeadacheEnded: widget.isHeadacheEnded,));
      case 'severity':
        return _getWidget(SignUpAgeScreen(
          sliderValue: (widget.selectedCurrentValue == null ||
                  widget.selectedCurrentValue.isEmpty)
              ? widget.min
              : double.parse(widget.selectedCurrentValue),
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
        ));
      case 'disability':
        return _getWidget(SignUpAgeScreen(
          sliderValue: (widget.selectedCurrentValue == null ||
                  widget.selectedCurrentValue.isEmpty)
              ? widget.min
              : double.parse(widget.selectedCurrentValue),
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
        ));

      case 'behavior.presleep':
        if (!isValuesUpdated) {
          isValuesUpdated = true;
          Values value = widget.valuesList.firstWhere(
              (element) => element.isDoubleTapped,
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
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          preCondition: widget.sleepExpandableWidgetList[0].precondition,
          overlayNumber: numberOfSleepItemSelected,
          onCircleItemSelected: _onSleepItemSelected,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
        ));
      case 'behavior.premeal':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
        ));
      case 'behavior.preexercise':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
        ));
      case 'medication':
        try {
          if (!isValuesUpdated) {
            isValuesUpdated = true;
            Values value = widget.valuesList.firstWhere(
                    (element) => element.isDoubleTapped,
                orElse: () => null);
            if (value != null) {
              _onMedicationItemSelected(int.parse(value.valueNumber) - 1);
              SelectedAnswers selectedAnswers = widget.selectedAnswers
                  .firstWhere(
                      (element) => element.questionTag == 'administered',
                  orElse: () => null);
              if (selectedAnswers != null) {
                _medicineTimeList[whichMedicationItemSelected][0] =
                    DateTime.parse(selectedAnswers.answer).toString();
              }
            }
          }
        } catch(e) {
          print(e.toString());
        }
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onCircleItemSelected: _onMedicationItemSelected,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
          isForMedication: true,
        ));
      case 'triggers1':
        if (!isValuesUpdated) {
          isValuesUpdated = true;
          widget.valuesList.asMap().forEach((index, element) {
            if (element.isSelected && element.isDoubleTapped) {
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
    whichMedicationItemSelected = index;
    whichTriggerItemSelected = index;
    
    if(widget.contentType == 'medication')
      _updateMedicationSelectedDataModel();
    
    if (isDoubleTapped) {
      if (questionType == 'multi') {
        widget.selectedAnswers.add(
            SelectedAnswers(questionTag: currentTag, answer: selectedAnswer));
      } else {
        SelectedAnswers selectedAnswerObj = widget.selectedAnswers.firstWhere(
            (element) => element.questionTag == currentTag,
            orElse: () => null);
        if (selectedAnswerObj == null) {
          widget.selectedAnswers.add(
              SelectedAnswers(questionTag: currentTag, answer: selectedAnswer));
        } else {
          selectedAnswerObj.answer = selectedAnswer;
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
      } else {
        SelectedAnswers selectedAnswerObj = widget.selectedAnswers.firstWhere(
            (element) => element.questionTag == currentTag,
            orElse: () => null);

        if (selectedAnswerObj != null) {
          widget.selectedAnswers.remove(selectedAnswerObj);
        }
      }
    }
    storeExpandableViewSelectedData();
    storeLogDayDataIntoDatabase();
    print(widget.selectedAnswers.length);
  }

  void storeExpandableViewSelectedData() {
    switch (widget.contentType) {
      case 'behavior.presleep':
        String text = widget.valuesList[whichSleepItemSelected].text;
        String preCondition = widget.sleepExpandableWidgetList[0].precondition;

        if (preCondition.contains(text)) {
          List<Values> values = widget.sleepExpandableWidgetList[0].values;
          values.forEach((element) {
            if (element.isSelected) {
              widget.selectedAnswers.add(SelectedAnswers(
                  questionTag: 'behavior.sleep', answer: element.valueNumber));
            }
          });
        } else {
          widget.selectedAnswers.removeWhere(
              (element) => element.questionTag == 'behavior.sleep');
        }
        break;
      case 'medication':
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

        previousMedicationTag = widget
            .medicationExpandableWidgetList[whichMedicationItemSelected].tag;
        Values selectedDosageValue = widget
            .medicationExpandableWidgetList[whichMedicationItemSelected].values
            .firstWhere((element) => element.isSelected, orElse: () => null);
        if (selectedDosageValue != null) {
          widget.selectedAnswers.add(SelectedAnswers(
              questionTag: previousMedicationTag,
              answer: selectedDosageValue.valueNumber));
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
        break;
    }
  }

  void storeLogDayDataIntoDatabase() async {
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

      logDayQuestionnaire.selectedAnswers = jsonEncode(widget.selectedAnswers);
      SignUpOnBoardProviders.db.insertLogDayData(logDayQuestionnaire);
    } else {
      var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

      if(userProfileInfoData != null)
        SignUpOnBoardProviders.db.updateLogDayData(jsonEncode(widget.selectedAnswers), userProfileInfoData.userId);
      else
        SignUpOnBoardProviders.db.updateLogDayData(jsonEncode(widget.selectedAnswers), '4214');
    }
  }

  void _onSleepItemSelected(int index) {
    String preCondition = widget.sleepExpandableWidgetList[0].precondition;
    String text = widget.valuesList[index].text;

    whichSleepItemSelected = index;

    if (preCondition.contains(text) && widget.valuesList[index].isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onMedicationItemSelected(int index) {
    setState(() {
      whichMedicationItemSelected = index;
    });

    _updateMedicationSelectedDataModel();

    if (widget.valuesList[index].isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTriggerItemSelected(int index) {
    setState(() {
      whichTriggerItemSelected = index;
    });

    Values value = widget.valuesList
        .firstWhere((element) => element.isSelected, orElse: () => null);

    if (value != null) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
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
                  fontSize: 16,
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
                  fontSize: 14,
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
                    fontSize: 14),
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
                  child: Wrap(children: _getChipsWidget()),
                ),
              ),
            ),
          ],
        );
      case 'medication':
        String medName = widget.valuesList[whichMedicationItemSelected].text;
        Questions questions = widget.medicationExpandableWidgetList.firstWhere(
            (element) => element.precondition.contains(medName),
            orElse: () => null);

        DateTime _medicationDateTime = DateTime.now();

        try {
          _medicationDateTime = DateTime.parse(_medicineTimeList[whichMedicationItemSelected][0]);
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
                    fontSize: 14,
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
                            CupertinoDatePickerMode.time, 1);
                      },
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          Utils.getTimeInAmPmFormat(
                              _medicationDateTime.hour,
                              _medicationDateTime
                                  .minute),
                          style: TextStyle(
                              color: Constant.splashColor,
                              fontFamily: Constant.jostRegular,
                              fontSize: 14),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if(_medicationDosageList[whichMedicationItemSelected][0].values != null)
            Container(
              height: 30,
              child: LogDayChipList(
                question: _medicationDosageList[whichMedicationItemSelected][0],
                onSelectCallback: _onMedicationChipSelectedCallback,
              ),
            )
            else
              Container(),
            SizedBox(
              height: 10,
            ),
            _getAddedDosageList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _numberOfDosageAddedList[whichMedicationItemSelected] = _numberOfDosageAddedList[whichMedicationItemSelected] + 1;
                    _medicineTimeList[whichMedicationItemSelected].add(DateTime.now().toString());

                    String medName = widget.valuesList[whichMedicationItemSelected].text;
                    Questions questions1 = widget.medicationExpandableWidgetList.firstWhere(
                            (element) => element.precondition.contains(medName),
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
                      _medicationDosageList[whichMedicationItemSelected].add(
                          questions2);
                    } else {
                      _medicationDosageList[whichMedicationItemSelected].add(
                          Questions());
                    }
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+ ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Constant.addCustomNotificationTextColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constant.jostRegular,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Add another dosage time for $medName',
                        style: TextStyle(
                          fontSize: 14,
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
          ],
        );
      case 'triggers1':
        if (_triggerWidgetList == null) {
          _triggerWidgetList = [];
        }

        String triggerName = widget.valuesList[whichTriggerItemSelected].text;
        bool isSelected =
            widget.valuesList[whichTriggerItemSelected].isSelected;
        Questions questions = widget.triggerExpandableWidgetList.firstWhere(
            (element) => element.precondition.contains(triggerName),
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
                                fontSize: 14,
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
                                fontSize: 14,
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
                            onChanged: (text) {
                              onValueChangedCallback(questionTag, text.trim());
                            },
                            initialValue: (selectedTriggerValue != null)
                                ? selectedTriggerValue
                                : '',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: Constant.jostMedium,
                                color: Constant.unselectedTextColor),
                            cursorColor: Constant.unselectedTextColor,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              hintText: Constant.tapToType,
                              hintStyle: TextStyle(
                                  fontSize: 14,
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
                                fontSize: 14,
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
  }

  Widget _getAddedDosageList() {
    if(_numberOfDosageAddedList[whichMedicationItemSelected] > 0) {
      String medName = widget.valuesList[whichMedicationItemSelected].text;
      Questions questions = widget.medicationExpandableWidgetList.firstWhere(
              (element) => element.precondition.contains(medName),
          orElse: () => null);

      DateTime medicationDateTime = DateTime.now();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_numberOfDosageAddedList[whichMedicationItemSelected], (index) {
          try {
            medicationDateTime = DateTime.parse(_medicineTimeList[whichMedicationItemSelected][index + 1]);
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
                      fontSize: 14,
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
                              CupertinoDatePickerMode.time, 1);
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
                                fontSize: 14),
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
                      _numberOfDosageAddedList[whichMedicationItemSelected] = _numberOfDosageAddedList[whichMedicationItemSelected] - 1;
                      _medicineTimeList[whichMedicationItemSelected].removeAt(index + 1);
                      _medicationDosageList[whichMedicationItemSelected].removeAt(index + 1);

                      _updateMedicationSelectedDataModel();
                    });
                  },
                  child: Text(
                    'Tap here to remove this dose',
                    style: TextStyle(
                      fontSize: 14,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if(_medicationDosageList[whichMedicationItemSelected][index + 1].values != null)
                Container(
                  height: 30,
                  child: LogDayChipList(
                    question: _medicationDosageList[whichMedicationItemSelected][index + 1],
                    onSelectCallback: _onMedicationChipSelectedCallback,
                  ),
                )
              else
                Container(),
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

            /*if(element.isSelected) {
>>>>>>> feature/LogDay
              numberOfSleepItemSelected++;
            } else {
              numberOfSleepItemSelected--;
            }*/
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
                  fontSize: 12,
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
    // TODO: implement initState
    super.initState();
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
      for (var i = 0; i < widget.valuesList.length; i++) {
        _medicineTimeList.add(List.generate(1, (index) => DateTime.now().toString()));
      }

      _numberOfDosageAddedList = List.generate(widget.valuesList.length, (index) => 0);

      for(var i = 0; i < widget.valuesList.length; i++) {
        String medName = widget.valuesList[i].text;
        Questions questions = widget.medicationExpandableWidgetList.firstWhere(
                (element) => element.precondition.contains(medName),
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
      
      SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere((element) => element.questionTag == 'administered', orElse: () => null);

      if(selectedAnswers != null)
        _medicationSelectedDataModel = MedicationSelectedDataModel.fromJson(json.decode(selectedAnswers.answer));

      if(_medicationSelectedDataModel != null) {
        whichMedicationItemSelected = _medicationSelectedDataModel.selectedMedicationIndex;
        _numberOfDosageAddedList[whichMedicationItemSelected] = _medicationSelectedDataModel.selectedMedicationDateList.length - 1;
        _medicineTimeList[whichMedicationItemSelected] = _medicationSelectedDataModel.selectedMedicationDateList;

        for(var i = 0; i < _numberOfDosageAddedList[whichMedicationItemSelected]; i++) {
          String medName = widget.valuesList[whichMedicationItemSelected].text;
          Questions questions = widget.medicationExpandableWidgetList.firstWhere(
                  (element) => element.precondition.contains(medName),
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
            _medicationDosageList[whichMedicationItemSelected].add(questions1);
          } else {
            _medicationDosageList[whichMedicationItemSelected].add(Questions());
          }
        }

        if(_medicationSelectedDataModel.selectedMedicationDosageList.length > 0) {
          _medicationSelectedDataModel.selectedMedicationDosageList.asMap().forEach((index, value) {
            //if(index == 0) {
              try {
                int selectedValueIndex = int.parse(value) - 1;
                _medicationDosageList[whichMedicationItemSelected][index].values[selectedValueIndex].isSelected = true;
              } catch(e) {
                print(e.toString());
              }
            }
          );
        }
      }
    }
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
      CupertinoDatePickerMode cupertinoDatePickerMode, int whichPickerClicked) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
              cupertinoDatePickerMode: cupertinoDatePickerMode,
              onDateTimeSelected:
                  _getDateTimeCallbackFunction(whichPickerClicked),
            ));
  }

  Function _getDateTimeCallbackFunction(int i) {
    return _onDateSelected;
  }

  void _onDateSelected(DateTime dateTime) {
    setState(() {
      _medicineTimeList[whichMedicationItemSelected][_whichExpandedMedicationItemSelected] = dateTime.toString();
    });

    _updateMedicationSelectedDataModel();
  }

  void _updateMedicationSelectedDataModel() {
    List<String> selectedMedicationDosageList = [];

    _medicationDosageList[whichMedicationItemSelected].forEach((element) {
      if(element.values != null) {
        element.values.forEach((element1) {
          if(element1.isSelected) {
            selectedMedicationDosageList.add(element1.valueNumber);
          }
        });
      }
    });

    _medicationSelectedDataModel = MedicationSelectedDataModel(
      selectedMedicationIndex: whichMedicationItemSelected,
      selectedMedicationDateList: _medicineTimeList[whichMedicationItemSelected],
      selectedMedicationDosageList: selectedMedicationDosageList,
    );
  }
}
