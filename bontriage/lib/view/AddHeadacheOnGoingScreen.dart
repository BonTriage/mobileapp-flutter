import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CirleLogOptions.dart';

class AddHeadacheOnGoingScreen extends StatefulWidget {
  @override
  _AddHeadacheOnGoingScreenState createState() => _AddHeadacheOnGoingScreenState();
}

class _AddHeadacheOnGoingScreenState extends State<AddHeadacheOnGoingScreen> {
  DateTime _dateTime;
  AnimationController _animationController;

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
                      height: 30,
                      thickness: 1,
                      color: Constant.chatBubbleGreen,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Constant.headacheType,
                        style: TextStyle(
                            fontSize: 18,
                            color: Constant.chatBubbleGreen,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 7,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Constant.whatKindOfHeadache,
                        style: TextStyle(
                            fontSize: 13,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    CircleLogOptions(
                      logOptions: [
                        'abc',
                        'abc',
                        'abc',
                        'abc',
                        'abc',
                        'abc',
                        'abc',
                        'abc',
                      ],
                    ),
                    Divider(
                      height: 40,
                      thickness: 0.5,
                      color: Constant.chatBubbleGreen,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Constant.time,
                        style: TextStyle(
                            fontSize: 18,
                            color: Constant.chatBubbleGreen,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 7,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Constant.whatKindOfHeadache,
                        style: TextStyle(
                            fontSize: 13,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Constant.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: Constant.locationServiceGreen,
                            fontFamily: Constant.jostRegular
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Constant.backgroundTransparentColor,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text(
                                      'Aug 16, 2020',
                                      style: TextStyle(
                                        color: Constant.splashColor,
                                        fontFamily: Constant.jostRegular,
                                        fontSize: 14
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Constant.backgroundTransparentColor,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text(
                                      '10:30 AM',
                                      style: TextStyle(
                                          color: Constant.splashColor,
                                          fontFamily: Constant.jostRegular,
                                          fontSize: 14
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
