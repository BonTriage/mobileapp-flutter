import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';

class MoreSection extends StatefulWidget {
  final String text;
  final String moreStatus;
  final bool isShowDivider;
  final String currentTag;
  final Function(String) navigateToOtherScreenCallback;

  const MoreSection({Key key, this.text, this.moreStatus, this.isShowDivider, this.currentTag, this.navigateToOtherScreenCallback}) : super(key: key);
  @override
  _MoreSectionState createState() => _MoreSectionState();
}

class _MoreSectionState extends State<MoreSection> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  AnimationController _animationController;
  int clickedOnWhichButton = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if(widget.currentTag != null) {
                switch(widget.currentTag) {
                  case Constant.settings:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreSettingRoute);
                    break;
                  case Constant.generateReport:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreGenerateReportRoute);
                    break;
                  case Constant.support:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreSupportRoute);
                    break;
                  case Constant.myInfo:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreMyInfoScreenRoute);
                    break;
                  case Constant.notifications:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreNotificationScreenRoute);
                    break;
                  case Constant.faq:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreFaqScreenRoute);
                    break;
                  case Constant.dailyLog:
                  case Constant.medication:
                  case Constant.exercise:
                    if (!isExpanded) {
                      isExpanded = true;
                      _animationController.forward();
                    }
                    else {
                      isExpanded = false;
                      _animationController.reverse();
                    }
                    break;
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                      color: Constant.locationServiceGreen,
                      fontSize: 16,
                      fontFamily: Constant.jostMedium
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.moreStatus,
                      style: TextStyle(
                          color: Constant.notificationTextColor,
                          fontSize: 16,
                          fontFamily: Constant.jostMedium
                      ),
                    ),
                    SizedBox(width: 10,),
                    Image(
                      width: 20,
                      height: 20,
                      image: AssetImage(Constant.rightArrow),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _animationController,
            child: _getExpandableWidget(),
          ),
          Visibility(
            visible: widget.isShowDivider,
            child: Divider(
              color: Constant.locationServiceGreen,
              thickness: 1,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getExpandableWidget() {
    switch(widget.currentTag) {
      case Constant.dailyLog:
      case Constant.medication:
      case Constant.exercise:
        return Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            clickedOnWhichButton = 0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: (clickedOnWhichButton == 0) ? Constant.selectedNotificationColor : Colors.transparent
                          ),
                          child: Text(
                            'Daily',
                            style: TextStyle(
                                fontSize: 10,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostRegular
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            clickedOnWhichButton = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: (clickedOnWhichButton == 1) ? Constant.selectedNotificationColor : Colors.transparent
                          ),
                          child: Text(
                            'Weekdays',
                            style: TextStyle(
                                fontSize: 10,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostRegular
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clickedOnWhichButton = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: (clickedOnWhichButton == 2) ? Constant.selectedNotificationColor : Colors.transparent
                      ),
                      child: Text(
                        'Off',
                        style: TextStyle(
                            fontSize: 10,
                            color: Constant.chatBubbleGreen,
                            fontFamily: Constant.jostRegular
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(fontSize: 18, color: Constant.locationServiceGreen, fontFamily: Constant.jostRegular),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    backgroundColor: Colors.transparent,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: false,
                    onDateTimeChanged: (dateTime) {

                    },
                  ),
                ),
              ),
              Text(
                Constant.delete,
                style: TextStyle(
                  color: Constant.addCustomNotificationTextColor,
                  fontSize: 12,
                  fontFamily: Constant.jostRegular
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return Container();
    }
  }
}
