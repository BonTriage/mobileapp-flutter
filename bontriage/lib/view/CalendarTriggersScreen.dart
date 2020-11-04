import 'package:flutter/material.dart';
import 'package:mobile/models/SelectedTriggersColorsModel.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/constant.dart';

class CalendarTriggersScreen extends StatefulWidget {
  @override
  _CalendarTriggersScreenState createState() => _CalendarTriggersScreenState();
}

class _CalendarTriggersScreenState extends State<CalendarTriggersScreen> {
  List<Widget> currentMonthData = [];
  Color lastDeselectedColor;

  List<SelectedTriggersColorsModel> triggersColorsListData = [
    SelectedTriggersColorsModel(
        triggersColorsValue: Color(0Xff7E00CB), isSelected: true),
    SelectedTriggersColorsModel(
        triggersColorsValue: Color(0xffD85B00), isSelected: true),
    SelectedTriggersColorsModel(
        triggersColorsValue:  Color(0XFF00A8CD), isSelected: true),
  ];

  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel = [
    SignUpHeadacheAnswerListModel(
        answerData: 'Dehydration', isSelected: true, color: Color(0Xff7E00CB)),
    SignUpHeadacheAnswerListModel(
        answerData: 'Poor Sleep', isSelected: true, color:Color(0xffD85B00)),
    SignUpHeadacheAnswerListModel(
        answerData: 'Stress', isSelected: true, color:  Color(0XFF00A8CD)),
    SignUpHeadacheAnswerListModel(
        answerData: 'Menstruation', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: 'High Humidity', isSelected: false),
    SignUpHeadacheAnswerListModel(answerData: 'Caffeine', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: '2+ Glasses of Red Wine', isSelected: false),
    SignUpHeadacheAnswerListModel(
        answerData: 'High Screen Time', isSelected: false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var calendarUtil = CalendarUtil(calenderType: 1);
    currentMonthData = calendarUtil.drawMonthCalendar(yy: 2020, mm: 11);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Constant.locationServiceGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(Constant.backArrow),
                      width: 10,
                      height: 10,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'October 2020',
                      style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontSize: 13,
                          fontFamily: Constant.jostRegular),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Image(
                      image: AssetImage(Constant.nextArrow),
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Center(
                          child: Text(
                            'Su',
                            style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                              fontSize: 15,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Tu',
                          style: TextStyle(
                              fontSize: 15,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                      Center(
                        child: Text(
                          'W',
                          style: TextStyle(
                              fontSize: 15,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Th',
                          style: TextStyle(
                              fontSize: 15,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                      Center(
                        child: Text(
                          'F',
                          style: TextStyle(
                              fontSize: 15,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Sa',
                          style: TextStyle(
                              fontSize: 15,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                    ]),
                  ],
                ),
                Container(
                  height: 290,
                  child: GridView.count(
                      crossAxisCount: 7,
                      padding: EdgeInsets.all(4.0),
                      childAspectRatio: 8.0 / 9.0,
                      children: currentMonthData.map((e) {
                        return e;
                      }).toList()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Constant.backgroundTransparentColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Constant.chatBubbleGreen, width: 1.3)),
                        height: 10,
                        width: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Headache-free day',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Constant.chatBubbleGreen,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Constant.chatBubbleGreen)),
                        height: 10,
                        width: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Headache day',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
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
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              Constant.sortedCalenderTextView,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150),
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 15),
              child: SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    for (var i = 0;
                        i < signUpHeadacheAnswerListModel.length;
                        i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            var foundElements = signUpHeadacheAnswerListModel
                                .where((e) => e.isSelected);
                            if (!signUpHeadacheAnswerListModel[i].isSelected) {
                              if (foundElements.length < 3) {
                                var unSelectedColor =
                                    triggersColorsListData.firstWhere(
                                        (element) => !element.isSelected,
                                        orElse: () => null);
                                if (unSelectedColor != null) {
                                  signUpHeadacheAnswerListModel[i].color =
                                      unSelectedColor.triggersColorsValue;
                                  signUpHeadacheAnswerListModel[i].isSelected =
                                      true;
                                  unSelectedColor.isSelected = true;
                                }
                                signUpHeadacheAnswerListModel[i].isSelected =
                                    true;
                              } else {
                                print(
                                    "PopUp will be show for more then 3 selected color");
                              }
                            } else {
                              var selectedColor =
                                  triggersColorsListData.firstWhere(
                                      (element) =>
                                          element.triggersColorsValue ==
                                          signUpHeadacheAnswerListModel[i]
                                              .color,
                                      orElse: () => null);
                              if (selectedColor != null) {
                                selectedColor.isSelected = false;
                                signUpHeadacheAnswerListModel[i].isSelected =
                                    false;
                              }
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Constant.chatBubbleGreen, width: 1),
                              borderRadius: BorderRadius.circular(20),
                              color: signUpHeadacheAnswerListModel[i].isSelected
                                  ? Constant.chatBubbleGreen
                                  : Colors.transparent),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 10),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Visibility(
                                    visible: signUpHeadacheAnswerListModel[i]
                                        .isSelected,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Constant.bubbleChatTextView,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              signUpHeadacheAnswerListModel[i]
                                                  .color),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    signUpHeadacheAnswerListModel[i].answerData,
                                    style: TextStyle(
                                        color: signUpHeadacheAnswerListModel[i]
                                                .isSelected
                                            ? Constant.bubbleChatTextView
                                            : Constant.locationServiceGreen,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ],
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
        ],
      ),
    );
  }

  Color selectedTriggersColor() {
    Color unselectedColor;
    var foundElements = triggersColorsListData.where((e) => e.isSelected);
    if (foundElements == null) {
      unselectedColor = Colors.red;
    } else {
      if (foundElements.length < 3) {
        var unSelectedTriggerColor = triggersColorsListData
            .firstWhere((element) => !element.isSelected, orElse: () => null);

        if (unSelectedTriggerColor == null) {
          unselectedColor = Colors.red;
        } else {
          unselectedColor = unSelectedTriggerColor.triggersColorsValue;
        }
      }
    }
    return unselectedColor;
  }
}
