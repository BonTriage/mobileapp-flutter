import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LogDayQuestionnaire.dart';
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
      this.selectedAnswers})
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
  int whichTriggerItemSelected = 0;
  bool isValuesUpdated = false;
  List<DateTime> _medicineTimeList;
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
            addHeadacheDateTimeDetailsData: _onHeadacheDateTimeSelected));
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
        if (!isValuesUpdated) {
          isValuesUpdated = true;
          Values value = widget.valuesList.firstWhere(
              (element) => element.isDoubleTapped,
              orElse: () => null);
          if (value != null) {
            _onMedicationItemSelected(int.parse(value.valueNumber) - 1);
            SelectedAnswers selectedAnswers = widget.selectedAnswers.firstWhere(
                (element) => element.questionTag == 'administered',
                orElse: () => null);
            if (selectedAnswers != null) {
              _medicineTimeList[whichMedicationItemSelected] =
                  DateTime.parse(selectedAnswers.answer);
            }
          }
        }
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onCircleItemSelected: _onMedicationItemSelected,
          onDoubleTapItem: _onDoubleTapItem,
          currentTag: widget.contentType,
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
              answer:
                  _medicineTimeList[whichMedicationItemSelected].toString()));
        } else {
          selectedAnswers.answer =
              _medicineTimeList[whichMedicationItemSelected].toString();
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
    List<Map> userLogDataMap =
        await SignUpOnBoardProviders.db.getLogDayData('4214');

    if (userLogDataMap == null || userLogDataMap.length == 0) {
      LogDayQuestionnaire logDayQuestionnaire = LogDayQuestionnaire();
      logDayQuestionnaire.userId = '4214';
      logDayQuestionnaire.selectedAnswers = jsonEncode(widget.selectedAnswers);
      SignUpOnBoardProviders.db.insertLogDayData(logDayQuestionnaire);
    } else {
      SignUpOnBoardProviders.db
          .updateLogDayData(jsonEncode(widget.selectedAnswers), '4214');
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
                        _openDatePickerBottomSheet(
                            CupertinoDatePickerMode.time, 1);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          Utils.getTimeInAmPmFormat(
                              _medicineTimeList[whichMedicationItemSelected].hour,
                              _medicineTimeList[whichMedicationItemSelected]
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
            Container(
              height: 30,
              child: LogDayChipList(
                question: widget.medicationExpandableWidgetList[
                    whichMedicationItemSelected],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {},
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

    _medicineTimeList =
        List.generate(widget.valuesList.length, (index) => DateTime.now());

    if (widget.selectedAnswers != null) {
      widget.selectedAnswers.forEach((element) {
        if (element.questionTag.contains('triggers1.')) {
          selectedAnswerListOfTriggers.add(element);
        }
      });
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
      _medicineTimeList[whichMedicationItemSelected] = dateTime;
    });
  }
}
