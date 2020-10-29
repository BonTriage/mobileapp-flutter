import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreNotificationScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const MoreNotificationScreen({Key key, this.onPush})
      : super(key: key);
  @override
  _MoreNotificationScreenState createState() => _MoreNotificationScreenState();
}

class _MoreNotificationScreenState extends State<MoreNotificationScreen> with SingleTickerProviderStateMixin {

  String dailyLogStatus = 'Daily, 8:00 PM';
  String medicationStatus = 'Daily, 2:30 PM';
  String exerciseStatus = 'Off';

  AnimationController _animationController;

  bool _notificationSwitchState = false;

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
      decoration: Constant.backgroundBoxDecoration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Constant.moreBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(Constant.leftArrow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Constant.notifications,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                          child: Text(
                            Constant.notifications,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Switch(
                            value: _notificationSwitchState,
                            onChanged: (bool state) {
                              setState(() {
                                _notificationSwitchState = state;

                                if(state) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }
                              });
                            },
                            activeColor: Constant.chatBubbleGreen,
                            inactiveThumbColor: Constant.chatBubbleGreen,
                            inactiveTrackColor: Constant.chatBubbleGreenBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizeTransition(
                    sizeFactor: _animationController,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constant.moreBackgroundColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MoreSection(
                              currentTag: Constant.dailyLog,
                              text: Constant.dailyLog,
                              moreStatus: dailyLogStatus,
                              isShowDivider: true,
                            ),
                            MoreSection(
                              currentTag: Constant.medication,
                              text: Constant.medication,
                              moreStatus: medicationStatus,
                              isShowDivider: true,
                            ),
                            MoreSection(
                              currentTag: Constant.exercise,
                              text: Constant.exercise,
                              moreStatus: exerciseStatus,
                              isShowDivider: true,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                child: Text(
                                  Constant.addCustomNotification,
                                  style: TextStyle(
                                    color: Constant.addCustomNotificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostMedium
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
