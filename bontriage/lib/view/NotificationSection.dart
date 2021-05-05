import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LocalNotificationModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

import 'NotificationTimer.dart';

class NotificationSection extends StatefulWidget {
  final String notificationName;
  final int notificationId;
  final Stream localNotificationDataStream;
  final List<LocalNotificationModel> allNotificationListData;
  final bool isNotificationTimerOpen;

  const NotificationSection(
      {Key key,
      this.notificationName,
      this.notificationId,
      this.localNotificationDataStream,
      this.allNotificationListData,this.isNotificationTimerOpen})
      : super(key: key);

  @override
  _NotificationSectionState createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection>
    with TickerProviderStateMixin {
  bool isDailyLogTimerLayoutOpen = false;
  bool isMedicationTimerLayoutOpen = false;
  bool isExerciseTimerLayoutOpen = false;
  bool isCustomTimerLayoutOpen = false;
  String selectedTimerValue = "";
  LocalNotificationModel localNotificationNameModel;

  @override
  void initState() {
    super.initState();
    if(widget.isNotificationTimerOpen != null) {
      isDailyLogTimerLayoutOpen = widget.isNotificationTimerOpen;
    }else{
      isDailyLogTimerLayoutOpen = false;
    }
    DateTime dateTime;
    if (widget.notificationId == 0) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
          (element) => element.notificationName == 'DailyLog',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    } else if (widget.notificationId == 1) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
          (element) => element.notificationName == 'Medication',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    } else if (widget.notificationId == 2) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
          (element) => element.notificationName == 'Exercise',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    } else {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded,
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    }
  }

  @override
  void didUpdateWidget(NotificationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isNotificationTimerOpen != null) {
      isDailyLogTimerLayoutOpen = widget.isNotificationTimerOpen;
    }else{
      isDailyLogTimerLayoutOpen = false;
    }
    DateTime dateTime;
    if (widget.notificationId == 0) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'DailyLog',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    } else if (widget.notificationId == 1) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Medication',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    } else if (widget.notificationId == 2) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Exercise',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    } else {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded,
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = localNotificationNameModel.notificationType +','
              ' ' +
              Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        } else {
          selectedTimerValue = 'Off';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              if (isDailyLogTimerLayoutOpen) {
                isDailyLogTimerLayoutOpen = false;
              } else {
                isDailyLogTimerLayoutOpen = true;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                localNotificationNameModel != null
                    ? localNotificationNameModel.notificationName
                    : widget.notificationName,
                style: TextStyle(
                    color: Constant.locationServiceGreen,
                    fontSize: 14,
                    fontFamily: Constant.jostMedium),
              ),
              Row(
                children: <Widget>[
                  Text(
                    selectedTimerValue,
                    style: TextStyle(
                        color: Constant.notificationTextColor,
                        fontSize: 16,
                        fontFamily: Constant.jostRegular),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    image: AssetImage(isDailyLogTimerLayoutOpen
                        ? Constant.notificationDownArrow
                        : Constant.rightArrow),
                    width: 16,
                    height: 16,
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 350),
          child: Visibility(
            visible: isDailyLogTimerLayoutOpen,
            child: Container(
              child: NotificationTimer(
                selectedNotification: widget.notificationId,
                allNotificationListData: widget.allNotificationListData,
                localNotificationDataStream: widget.localNotificationDataStream,
                selectedTimerValue: (userSelectedTimerValue) {
                  setState(() {
                    isDailyLogTimerLayoutOpen = false;
                    selectedTimerValue = userSelectedTimerValue;
                  });
                },
              ),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Constant.locationServiceGreen,
        ),
      ],
    );
  }
}