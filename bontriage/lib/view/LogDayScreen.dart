import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Constant.backgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Text(
                      Constant.sleep,
                      style: TextStyle(
                          fontSize: 18,
                          color: Constant.chatBubbleGreen,
                          fontFamily: Constant.jostMedium
                      ),
                    ),
                    SizedBox(height: 7,),
                    Text(
                      Constant.howFeelWakingUp,
                      style: TextStyle(
                          fontSize: 13,
                          color: Constant.locationServiceGreen,
                          fontFamily: Constant.jostRegular
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Constant.chatBubbleGreen
                            ),
                          ),
                          child: Center(
                            child: Text(
                              Constant.energizedRefreshed,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostRegular
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Constant.chatBubbleGreen
                            ),
                          ),
                          child: Center(
                            child: Text(
                              Constant.couldHaveBeenBetter,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostRegular
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
