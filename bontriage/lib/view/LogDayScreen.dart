import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddHeadacheSection.dart';

class LogDayScreen extends StatefulWidget {
  @override
  _LogDayScreenState createState() => _LogDayScreenState();
}

class _LogDayScreenState extends State<LogDayScreen> {
  DateTime _dateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Constant.backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Utils.getMonthName(_dateTime.month)} ${_dateTime.day}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Constant.chatBubbleGreen,
                              fontFamily: Constant.jostMedium
                          ),
                        ),
                        Image(
                          image: AssetImage(Constant.closeIcon),
                          width: 26,
                          height: 26,
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: Constant.chatBubbleGreen,
                      height: 30,
                    ),
                    Text(
                      Constant.doubleTapAnItem,
                      style: TextStyle(
                          fontSize: 13,
                          color: Constant.doubleTapTextColor,
                          fontFamily: Constant.jostRegular
                      ),
                    ),
                    SizedBox(height: 30,),
                    AddHeadacheSection(
                      headerText: Constant.sleep,
                      subText: Constant.howFeelWakingUp,
                      contentType: 'sleep',
                      valuesList: [
                        Values(text: 'Energized\n& refreshed', isSelected: false, valueNumber: '1'),
                        Values(text: 'Could have been better', isSelected: false, valueNumber: '2'),
                      ],
                    ),
                    AddHeadacheSection(
                      headerText: 'Activity',
                      subText: 'Did you have 20+ minutes of aerobic exercise?',
                      contentType: 'activity',
                      valuesList: [
                        Values(text: 'Yes', isSelected: false, valueNumber: '1'),
                        Values(text: 'No', isSelected: false, valueNumber: '2'),
                      ],
                    ),
                    AddHeadacheSection(
                      headerText: 'Meal Schedule',
                      subText: 'Did you eat on time without skipping or dealying meals?',
                      contentType: 'meal_schedule',
                      valuesList: [
                        Values(text: 'Yes', isSelected: false, valueNumber: '1'),
                        Values(text: 'No', isSelected: false, valueNumber: '2'),
                      ],
                    ),
                    AddHeadacheSection(
                      headerText: 'Medications',
                      subText: 'What medications, if any, did you take?',
                      contentType: 'medications',
                      valuesList: [
                        Values(text: 'abc', isSelected: false, valueNumber: '1'),
                        Values(text: 'abc', isSelected: false, valueNumber: '2'),
                        Values(text: 'abc', isSelected: false, valueNumber: '3'),
                        Values(text: 'abc', isSelected: false, valueNumber: '4'),
                      ],
                    ),
                    AddHeadacheSection(
                      headerText: 'Triggers',
                      subText: 'What potential triggers, if any, did you experience?',
                      contentType: 'triggers',
                      valuesList: [
                        Values(text: 'abc', isSelected: false, valueNumber: '1'),
                        Values(text: 'abc', isSelected: false, valueNumber: '2'),
                        Values(text: 'abc', isSelected: false, valueNumber: '3'),
                        Values(text: 'abc', isSelected: false, valueNumber: '4'),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
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
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {},
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.symmetric(vertical: 13),
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
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {},
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.symmetric(vertical: 13),
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
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
