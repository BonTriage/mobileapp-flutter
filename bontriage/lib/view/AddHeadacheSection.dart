import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/TriggerWidgetModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CircleLogOptions.dart';
import 'package:mobile/view/DateTimePicker.dart';
import 'package:mobile/view/TimeSection.dart';
import 'package:mobile/view/sign_up_age_screen.dart';

class AddHeadacheSection extends StatefulWidget {
  final String headerText;
  final String subText;
  final String contentType;
  final String questionType;
  final double min;
  final double max;
  final List<Questions> sleepExpandableWidgetList;
  final List<Questions> medicationExpandableWidgetList;
  final List<Questions> triggerExpandableWidgetList;
  final List<Values> valuesList;
  final List<Values> chipsValuesList;

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
      this.triggerExpandableWidgetList,
      this.questionType})
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
  List<DateTime> _medicineTimeList;
  List<TriggerWidgetModel> _triggerWidgetList;

  Widget _getSectionWidget() {
    switch (widget.contentType) {
      case 'headacheType':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
        ));
      case 'onset':
        return _getWidget(TimeSection());
      case 'severity':
        return _getWidget(SignUpAgeScreen(
          sliderValue: widget.min,
          minText: Constant.one,
          maxText: Constant.ten,
          sliderMinValue: widget.min,
          sliderMaxValue: widget.max,
          minTextLabel: Constant.mild,
          maxTextLabel: Constant.veryPainful,
          labelText: '',
          horizontalPadding: 0,
          isAnimate: false,
        ));
      case 'disability':
        return _getWidget(SignUpAgeScreen(
          sliderValue: widget.min,
          minText: Constant.one,
          maxText: Constant.ten,
          sliderMinValue: widget.min,
          sliderMaxValue: widget.max,
          minTextLabel: Constant.noneAtALL,
          maxTextLabel: Constant.totalDisability,
          labelText: '',
          horizontalPadding: 0,
          isAnimate: false,
        ));
      case 'behavior.presleep':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          preCondition: widget.sleepExpandableWidgetList[0].precondition,
          overlayNumber: numberOfSleepItemSelected,
          onCircleItemSelected: _onSleepItemSelected,
        ));
      case 'behavior.premeal':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
        ));
      case 'behavior.preexercise':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
        ));
      case 'medication':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          onCircleItemSelected: _onMedicationItemSelected,
        ));
      case 'triggers1':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
          questionType: widget.questionType,
          onCircleItemSelected: _onTriggerItemSelected,
        ));
      default:
        return Container();
    }
  }

  void _onSleepItemSelected(int index) {
    String preCondition = widget.sleepExpandableWidgetList[0].precondition;
    String text = widget.valuesList[index].text;

    if(preCondition.contains(text) && widget.valuesList[index].isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onMedicationItemSelected(int index) {
    setState(() {
      whichMedicationItemSelected = index;
    });
    if(widget.valuesList[index].isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTriggerItemSelected(int index) {
    setState(() {
      whichTriggerItemSelected = index;
    });

    /*String triggerName = widget.valuesList[whichTriggerItemSelected].text;
    Questions questions = widget.triggerExpandableWidgetList.firstWhere((element) => element.precondition.contains(triggerName), orElse: () => null);*/

    Values value = widget.valuesList.firstWhere((element) => element.isSelected, orElse: () => null);

    if(value != null) {
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
          child: Text(
            widget.headerText,
            style: TextStyle(
                fontSize: 18,
                color: Constant.chatBubbleGreen,
                fontFamily: Constant.jostMedium),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.subText,
            style: TextStyle(
                fontSize: 14,
                color: Constant.locationServiceGreen,
                fontFamily: Constant.jostRegular),
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
        Divider(
          height: 40,
          thickness: 0.5,
          color: Constant.chatBubbleGreen,
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
            Text(
              expandableWidgetData.helpText,
              style: TextStyle(
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
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
        Questions questions = widget.medicationExpandableWidgetList.firstWhere((element) => element.precondition.contains(medName), orElse: () => null);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'When did you take $medName?',
              style: TextStyle(
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
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
                        Utils.getTimeInAmPmFormat(_medicineTimeList[whichMedicationItemSelected].hour, _medicineTimeList[whichMedicationItemSelected].minute),
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
            SizedBox(
              height: 10,
            ),
            Text(
              (questions == null) ? 'What dosage did you take?' : questions.helpText,
              style: TextStyle(
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.medicationExpandableWidgetList[whichMedicationItemSelected].values.length,
                itemBuilder: (context, index) {
                  return _getOverlayedChip(index);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
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
          ],
        );
      case 'triggers1':
        if(_triggerWidgetList == null) {
          _triggerWidgetList = [];
        }

        String triggerName = widget.valuesList[whichTriggerItemSelected].text;
        bool isSelected = widget.valuesList[whichTriggerItemSelected].isSelected;
        Questions questions = widget.triggerExpandableWidgetList.firstWhere((element) => element.precondition.contains(triggerName), orElse: () => null);
        String questionTag = (questions == null) ? '' : questions.tag;
        TriggerWidgetModel triggerWidgetModel = _triggerWidgetList.firstWhere((element) => element.questionTag == questionTag, orElse: () => null);

        if(triggerWidgetModel == null) {
            if (questions == null) {
              _triggerWidgetList.add(
                  TriggerWidgetModel(questionTag: "", widget: Container()));
            } else {
              switch (questions.questionType) {
                case 'number':
                  _triggerWidgetList.add(TriggerWidgetModel(
                      questionTag: questions.tag, widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions.helpText,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SignUpAgeScreen(
                        sliderValue: questions.min.toDouble(),
                        sliderMinValue: questions.min.toDouble(),
                        sliderMaxValue: questions.max.toDouble(),
                        minText: questions.min.toString(),
                        maxText: questions.max.toString(),
                        labelText: '',
                        isAnimate: false,
                        horizontalPadding: 0,
                      ),
                    ],
                  )));
                  break;
                case 'text':
                  _triggerWidgetList.add(TriggerWidgetModel(
                      questionTag: questions.tag, widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        questions.helpText,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        minLines: 5,
                        maxLines: 6,
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
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            borderSide: BorderSide(
                                color: Constant.backgroundTransparentColor,
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            borderSide: BorderSide(
                                color: Constant.backgroundTransparentColor,
                                width: 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  )));
                  break;
                case 'multi':
                  _triggerWidgetList.add(TriggerWidgetModel(
                      questionTag: questions.tag, widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        questions.helpText,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: questions.values.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Constant.chatBubbleGreen,
                                  ),
                                  color: questions.values[index].isSelected
                                      ? Constant.chatBubbleGreen
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    questions.values[index].text,
                                    style: TextStyle(
                                        color: questions.values[index]
                                            .isSelected
                                            ? Constant.bubbleChatTextView
                                            : Constant.locationServiceGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.jostRegular),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  )));
                  break;
                default:
                  _triggerWidgetList.add(TriggerWidgetModel(
                      questionTag: questions.tag, widget: Container()));
              }
            }
        } else {
          if(!isSelected) {
            _triggerWidgetList.remove(triggerWidgetModel);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_triggerWidgetList.length, (index) => _triggerWidgetList[index].widget),
        );
      default:
        return Container();
    }
  }

  Widget _getOverlayedChip(int index) {
    Values value = widget.medicationExpandableWidgetList[whichMedicationItemSelected].values[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.medicationExpandableWidgetList[whichMedicationItemSelected].values.asMap().forEach((currIndex, value) {
            widget.medicationExpandableWidgetList[whichMedicationItemSelected].values[currIndex].isSelected = index == currIndex;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 5,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Constant.chatBubbleGreen,
          ),
          borderRadius: BorderRadius.circular(20),
          color: value.isSelected ? Constant.chatBubbleGreen : Colors.transparent
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              value.text,
              style: TextStyle(
                  color: value.isSelected ? Constant.bubbleChatTextView : Constant.locationServiceGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: Constant.jostRegular),
            ),
          ),
        ),
      ),
    );
  }

  /// This method is used to get list of chips widget which will be shown when user taps on the options of sleep section
  List<Widget> _getChipsWidget() {
    List<Widget> chipsList = [];

    widget.sleepExpandableWidgetList[0].values.forEach((element) {
      chipsList.add(GestureDetector(
        onTap: () {
          setState(() {
            element.isSelected = !element.isSelected;

            if(element.isSelected) {
              numberOfSleepItemSelected++;
            } else {
              numberOfSleepItemSelected--;
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(
            right: 5,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Constant.chatBubbleGreen,
            ),
            color: element.isSelected ? Constant.chatBubbleGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              element.text,
              style: TextStyle(
                  color: element.isSelected ? Constant.bubbleChatTextView : Constant.locationServiceGreen,
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

    _medicineTimeList = List.generate(widget.valuesList.length, (index) => DateTime.now());
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
