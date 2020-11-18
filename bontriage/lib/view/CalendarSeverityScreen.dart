import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/constant.dart';

class CalendarSeverityScreen extends StatefulWidget {
  @override
  _CalendarSeverityScreenState createState() => _CalendarSeverityScreenState();
}

class _CalendarSeverityScreenState extends State<CalendarSeverityScreen> {
  List<Widget> currentMonthData = [];
  List<Widget> _pageViewWidgetList;

  List<SignUpHeadacheAnswerListModel> signUpHeadacheAnswerListModel = [
    SignUpHeadacheAnswerListModel(answerData: 'Dehydration', isSelected: true),
    SignUpHeadacheAnswerListModel(answerData: 'Poor Sleep', isSelected: true),
    SignUpHeadacheAnswerListModel(answerData: 'Stress', isSelected: true),
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
    var calendarUtil = CalendarUtil(calenderType: 2);
    currentMonthData = calendarUtil.drawMonthCalendar(yy: 2020, mm: 11);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
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
                        'November 2020',
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
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Constant.backgroundTransparentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constant.chatBubbleGreen,
                                      width: 1.3)),
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
                                  border: Border.all(
                                      color: Constant.chatBubbleGreen)),
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
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Constant.migraineColor,
                                shape: BoxShape.circle,
                              ),
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Migraine day',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Constant.backgroundTransparentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constant.chatBubbleGreen,
                                      width: 1.3)),
                              child: Center(
                                child: Text(
                                  'i',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Constant.locationServiceGreen,
                                      fontFamily: Constant.jostRegular),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                Constant.calculatedSeverityCalendarTextView,
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
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.mildTriggerColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 8,
                        width: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Mild',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Headache score between',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '1 - 3',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.moderateTriggerColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 8,
                        width: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Moderate',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Headache score between',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '4 - 7',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.severeTriggerColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 8,
                        width: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Severe',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        'Headache score',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '8 to 10',
                        style: TextStyle(
                            fontSize: 12,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
