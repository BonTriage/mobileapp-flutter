import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CircleLogOptions.dart';

class LogDayNoHeadacheScreen extends StatefulWidget {
  @override
  _LogDayNoHeadacheScreenState createState() => _LogDayNoHeadacheScreenState();
}

class _LogDayNoHeadacheScreenState extends State<LogDayNoHeadacheScreen> {
  DateTime _dateTime;
  List<Values> noHeadacheLogDayListData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now();
    noHeadacheLogDayListData.add(Values(text: 'No headache today'));
    noHeadacheLogDayListData.add(Values(text: 'I had a headache'));
    noHeadacheLogDayListData.add(Values(text: 'I have an ongoing headache'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
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
                      Image(
                        image: AssetImage(Constant.closeIcon),
                        width: 22,
                        height: 22,
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
                _getWidget(CircleLogOptions(logOptions: noHeadacheLogDayListData,
                )),
                Expanded(
                  child: Container(),
                )
                ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingWidget(
                      onPressed: () {

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
                          child: Text( Constant.submit,
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
                      onPressed: () {},
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _getWidget(Widget mainWidget) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Headache',
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
              Constant.logDayNoHeadacheTextView,
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
      ],
    );
  }
}
