import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/util/CalendarUtil.dart';
import 'package:mobile/util/constant.dart';

class CalendarTriggersScreen extends StatefulWidget {
  @override
  _CalendarTriggersScreenState createState() => _CalendarTriggersScreenState();
}

class _CalendarTriggersScreenState extends State<CalendarTriggersScreen> {
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
    var calendarUtil = CalendarUtil();
    currentMonthData = calendarUtil.drawMonthCalendar(yy: 2021, mm: 1);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: DefaultTabController(
                      length: 3,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 30, right: 30, top: 30, bottom: 20),
                        padding: EdgeInsets.all(5),
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color(0xff0E232F),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: TabBar(
                          labelStyle: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold),
                          //For Selected tab
                          unselectedLabelStyle: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.normal),
                          //For Un-selected Tabs
                          labelColor: Color(0xff0E232F),
                          unselectedLabelColor: Color(0xffafd794),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffafd794)),
                          tabs: <Widget>[
                            Tab(text: 'Calender'),
                            Tab(
                              text: 'Compass',
                            ),
                            Tab(
                              text: 'Trends',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            Constant.backgroundColor.withOpacity(0.85),
                        child: Image(
                          image: AssetImage(Constant.calenderBackArrow),
                          width: 14,
                          height: 14,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        'Triggers',
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constant.jostMedium),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            Constant.backgroundColor.withOpacity(0.85),
                        child: Image(
                          image: AssetImage(Constant.calenderNextArrow),
                          width: 14,
                          height: 14,
                        ),
                      ),
                    ],
                  ),
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
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
                              Container(
                                margin: EdgeInsets.only(
                                  right: 10,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constant.chatBubbleGreen,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                    color: signUpHeadacheAnswerListModel[i]
                                            .isSelected
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
                                                color: Colors.red),
                                          ),
                                        ),
                                        SizedBox(width: 3,),
                                        Text(
                                          signUpHeadacheAnswerListModel[i]
                                              .answerData,
                                          style: TextStyle(
                                              color:
                                                  signUpHeadacheAnswerListModel[i]
                                                          .isSelected
                                                      ? Constant
                                                          .bubbleChatTextView
                                                      : Constant
                                                          .locationServiceGreen,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: Constant.jostMedium),
                                        ),
                                      ],
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
            ),
          ),
        ),
      ),
    );
  }
}
