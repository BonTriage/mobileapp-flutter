import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LocalNotificationModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

import 'NotificationTimer.dart';

class NotificationSection extends StatefulWidget {
  final String notificationName;
  final int notificationId;
  final Stream localNotificationDataStream;
  final List<LocalNotificationModel> allNotificationListData;
  final bool isNotificationTimerOpen;
  final Function customNotification;

  const NotificationSection(
      {Key key,
      this.notificationName,
      this.notificationId,
      this.localNotificationDataStream,
        this.customNotification,
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

  bool isDailySelected = false;
  bool isWeekDaysSelected = false;
  bool isOffSelected = true;

  DateTime _dateTime;
  int _selectedHour = 0;
  int _selectedMinute = 0;
  String whichButtonSelected;

  String dailyNotificationLogTime = "Off";

  String medicationNotificationLogTime = "Off";

  String exerciseNotificationLogTime = "Off";

  String customNotificationLogTime = "Off";

  String customNotificationValue = '';


  @override
  void initState() {
    super.initState();

    _dateTime = DateTime.now();
    _selectedHour = _dateTime.hour;
    _selectedMinute = _dateTime.minute;
    widget.localNotificationDataStream.listen((event) {
      if(event == 'Clicked')
        _setAllNotifications();
      else if(event == 'CancelAll') {
        flutterLocalNotificationsPlugin?.cancelAll();
      }
    });

    _setInItNotificationData();

    if(widget.isNotificationTimerOpen != null) {
      isDailyLogTimerLayoutOpen = widget.isNotificationTimerOpen;
    }else{
      isDailyLogTimerLayoutOpen = false;
    }
    DateTime dateTime;
    if (widget.notificationId == 0) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
          (element) => element.notificationName == 'Daily Log',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null && localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
      }
    } else if (widget.notificationId == 1) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
          (element) => element.notificationName == 'Medication',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null&& localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
      }
    } else if (widget.notificationId == 2) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
          (element) => element.notificationName == 'Exercise',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null&& localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
      }
    } else {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded ?? false,
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null&& localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
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
              (element) => element.notificationName == 'Daily Log',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null && localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
      }
    } else if (widget.notificationId == 1) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Medication',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null&& localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
      }
    } else if (widget.notificationId == 2) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Exercise',
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null && localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
      }
    } else {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded,
          orElse: () => null);
      if (localNotificationNameModel != null) {
        dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
        if (dateTime != null) {
          selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute)}';
        } else {
          if(localNotificationNameModel.notificationTime != null && localNotificationNameModel.notificationType != 'Off'){
            selectedTimerValue = '${localNotificationNameModel.notificationType ?? 'Daily'}, ${localNotificationNameModel.notificationTime}';
          }else{
            selectedTimerValue = 'Off';
          }
        }
      } else {
        selectedTimerValue = 'Off';
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
                setNotificationName(),

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
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Constant.chatBubbleGreen, width: 1),
                              color: isDailySelected
                                  ? Constant.backgroundTransparentColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isWeekDaysSelected = false;
                                    isOffSelected = false;
                                    if (isDailySelected) {
                                      isDailySelected = false;
                                    } else {
                                      isDailySelected = true;
                                    }
                                  });
                                },
                                child: Text(
                                  'Daily',
                                  style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Constant.jostRegular),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Constant.chatBubbleGreen, width: 1),
                              color: isWeekDaysSelected
                                  ? Constant.backgroundTransparentColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isDailySelected = false;
                                    isOffSelected = false;
                                    if (isWeekDaysSelected) {
                                      isWeekDaysSelected = false;
                                    } else {
                                      isWeekDaysSelected = true;
                                    }
                                  });
                                },
                                child: Text(
                                  'WeekDays',
                                  style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Constant.jostRegular),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                          color: isOffSelected
                              ? Constant.backgroundTransparentColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isWeekDaysSelected = false;
                                isDailySelected = false;
                                if (isOffSelected) {
                                  isOffSelected = false;
                                } else {
                                  isOffSelected = true;
                                }
                                _selectedTimerValueFunc('Off');
                                if (widget.notificationId == 0) {
                                  _deleteNotificationChannel(0);
                                } else if(widget.notificationId == 1) {
                                  _deleteNotificationChannel(1);
                                }else{
                                  _deleteNotificationChannel(2);
                                }
                              });
                            },
                            child: Text(
                              'Off',
                              style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Constant.jostRegular),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 180,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                              fontSize: 18,
                              color: Constant.locationServiceGreen,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: _dateTime,
                        backgroundColor: Colors.transparent,
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: false,
                        onDateTimeChanged: (dateTime) {
                          _selectedHour = dateTime.hour;
                          _selectedMinute = dateTime.minute;
                          _dateTime = dateTime;
                          print(_selectedHour);
                          print(_selectedMinute);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isWeekDaysSelected = false;
                            isDailySelected = false;
                            isOffSelected = false;
                            if (widget.notificationId == 3) {
                              widget.customNotification();
                            } else {
                              if (widget.notificationId == 0) {
                                _deleteNotificationChannel(0);
                              } else if(widget.notificationId == 1) {
                                _deleteNotificationChannel(1);
                              }else{
                                _deleteNotificationChannel(2);
                              }
                            }
                          });
                        },
                        child: Text(
                          _setDeleteOrEditText(),
                          style: TextStyle(
                              color: Constant.addCustomNotificationTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constant.jostRegular),
                        ),
                      ),
                    ],
                  ),
                ],
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

  String setNotificationName() {
    if(widget.notificationId == 3){
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded ?? false,
          orElse: () => null);
      if (localNotificationNameModel != null && localNotificationNameModel.notificationName.isNotEmpty) {
        return localNotificationNameModel.notificationName ;
      }else return widget.notificationName;
    }else return localNotificationNameModel != null ? localNotificationNameModel.notificationName : widget.notificationName;

  }

  void _selectedTimerValueFunc(String userSelectedTimerValue) {
    print(userSelectedTimerValue);
    setState(() {
      isDailyLogTimerLayoutOpen = false;
      selectedTimerValue = userSelectedTimerValue;
    });
  }

  /// This Method will be use for Delete Notification from respective Notification Section.
  Future<void> _deleteNotificationChannel(int channelId) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId.toString());
  }

  String _setDeleteOrEditText() {
    if (widget.notificationId == 3) {
      return 'Edit';
    } else
      return 'Delete';
  }

  /// This Method will be use for to set Daily, Weekly Notifications on respective Notifications Section.
  void _setAllNotifications() async {
    if (isDailySelected) {
      whichButtonSelected = 'Daily';
    } else if (isWeekDaysSelected) {
      whichButtonSelected = 'WeekDay';
    } else {
      whichButtonSelected = 'Off';
    }
    if (isDailySelected || isWeekDaysSelected) {
      _selectedTimerValueFunc('$whichButtonSelected, ${Utils.getTimeInAmPmFormat(_selectedHour, _selectedMinute)}');
      print('Save Ho GYa');
    } else {
      _selectedTimerValueFunc(whichButtonSelected);
    }
    await _notificationSelected("");

    _saveAllNotification();
  }

  /// This Method will be use for save the all Notification Data for the any alarm set by User.
  void _saveAllNotification() {
    Future.delayed(Duration(milliseconds: 100), () {
      /*SignUpOnBoardProviders.db
          .insertUserNotifications(widget.allNotificationListData);*/
    });
  }

  /// This Method will be use for to set all UI related data whatever user has saved last time on the current screen.
  void _setInItNotificationData() {
    if (widget.notificationId == 0) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Daily Log',
          orElse: () => null);
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationTime != null) {
        _dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
      } else {
        _dateTime = DateTime.now();
      }
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationType != null) {
        if (localNotificationNameModel.notificationType == 'Daily') {
          isDailySelected = true;
          isWeekDaysSelected = false;
          isOffSelected = false;

          whichButtonSelected = 'Daily';
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isDailySelected = false;
          isWeekDaysSelected = true;
          isOffSelected = false;

          whichButtonSelected = 'WeekDay';
        } else {
          isDailySelected = false;
          isWeekDaysSelected = false;
          isOffSelected = true;

          whichButtonSelected = 'Off';
        }
      }
    } else if (widget.notificationId == 1) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Medication',
          orElse: () => null);
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationTime != null) {
        _dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
      } else {
        _dateTime = DateTime.now();
      }
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationType != null) {
        if (localNotificationNameModel.notificationType == 'Daily') {
          isDailySelected = true;
          isWeekDaysSelected = false;
          isOffSelected = false;

          whichButtonSelected = 'Daily';
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isDailySelected = false;
          isWeekDaysSelected = true;
          isOffSelected = false;

          whichButtonSelected = 'WeekDay';
        } else {
          isDailySelected = false;
          isWeekDaysSelected = false;
          isOffSelected = true;

          whichButtonSelected = 'Off';
        }
      }
    } else if (widget.notificationId == 2) {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Exercise',
          orElse: () => null);
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationTime != null) {
        _dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
      } else {
        _dateTime = DateTime.now();
      }
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationType != null) {
        if (localNotificationNameModel.notificationType == 'Daily') {
          isDailySelected = true;
          isWeekDaysSelected = false;
          isOffSelected = false;

          whichButtonSelected = 'Daily';
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isDailySelected = false;
          isWeekDaysSelected = true;
          isOffSelected = false;

          whichButtonSelected = 'WeekDay';
        } else {
          isDailySelected = false;
          isWeekDaysSelected = false;
          isOffSelected = true;

          whichButtonSelected = 'Off';
        }
      }
    } else {
      localNotificationNameModel = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded ,
          orElse: () => null);
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationTime != null) {
        _dateTime =
            DateTime.tryParse(localNotificationNameModel.notificationTime);
      } else {
        _dateTime = DateTime.now();
      }
      if (localNotificationNameModel != null &&
          localNotificationNameModel.notificationType != null) {
        if (localNotificationNameModel.notificationType == 'Daily') {
          isDailySelected = true;
          isWeekDaysSelected = false;
          isOffSelected = false;

          whichButtonSelected = 'Daily';
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isDailySelected = false;
          isWeekDaysSelected = true;
          isOffSelected = false;

          whichButtonSelected = 'WeekDay';
        } else {
          isDailySelected = false;
          isWeekDaysSelected = false;
          isOffSelected = true;

          whichButtonSelected = 'Off';
        }
      }
    }
  }

  /// This Method will be use to set for Daily, Weekly notification on respective notification section.
  Future<void> _notificationSelected(String payload) async {
    var androidDetails = AndroidNotificationDetails(
        "ChannelId", "BonTriage", 'Reminder to log your day.',
        importance: Importance.max, icon: 'app_icon_1', color: Constant.chatBubbleGreen);
    var iosDetails = IOSNotificationDetails();
    var notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    if (widget.notificationId == 0) {
      if (isDailySelected) {
        dailyNotificationLogTime = 'Daily';
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            0,
            "BonTriage",
            "Reminder to log your day.",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else if (isWeekDaysSelected) {
        dailyNotificationLogTime = 'WeekDay';
        int weekDay = _dateTime.weekday + 1;
        weekDay = weekDay % 7;
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            1,
            'BonTriage',
            'Reminder to log your day.',
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        dailyNotificationLogTime = 'Off';
      }
      var dailyLogNotificationData = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Daily Log',
          orElse: () => null);
      if (dailyLogNotificationData != null) {
        dailyLogNotificationData.notificationName = 'Daily Log';
        dailyLogNotificationData.notificationType = dailyNotificationLogTime;
        if (dailyNotificationLogTime == 'Off') {
          dailyLogNotificationData.notificationTime = "";
          widget.allNotificationListData.remove(dailyLogNotificationData);
        } else {
          print("scheduled notification at $_dateTime");
          dailyLogNotificationData.notificationTime =  _dateTime.toIso8601String();
        }
      } else {
        LocalNotificationModel localNotificationModel = LocalNotificationModel();
        localNotificationModel.notificationName = 'Daily Log';
        localNotificationModel.notificationType = dailyNotificationLogTime;
        if (dailyNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        if(dailyNotificationLogTime != 'Off') {
          widget.allNotificationListData.add(localNotificationModel);
        }else{
          widget.allNotificationListData.remove(localNotificationModel);
        }
      }
    } else if (widget.notificationId == 1) {
      if (isDailySelected) {
        medicationNotificationLogTime = 'Daily';
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            2,
            "BonTriage",
            "Reminder to log your today's medications.",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else if (isWeekDaysSelected) {
        medicationNotificationLogTime = 'WeekDay';
        int weekDay = _dateTime.weekday + 1;
        weekDay = weekDay % 7;
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            3,
            'BonTriage',
            "Reminder to log your today's medications.",
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        medicationNotificationLogTime = 'Off';
      }
      var medicationNotificationData = widget.allNotificationListData
          .firstWhere((element) => element.notificationName == 'Medication',
          orElse: () => null);
      if (medicationNotificationData != null) {
        medicationNotificationData.notificationName = 'Medication';
        medicationNotificationData.notificationType =
            medicationNotificationLogTime;
        if (medicationNotificationLogTime == 'Off') {
          medicationNotificationData.notificationTime = "";
          widget.allNotificationListData.remove(medicationNotificationData);
        } else {
          medicationNotificationData.notificationTime = _dateTime.toIso8601String();
        }
      } else {
        LocalNotificationModel localNotificationModel = LocalNotificationModel();
        localNotificationModel.notificationName = 'Medication';
        localNotificationModel.notificationType = medicationNotificationLogTime;
        if (medicationNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        if(medicationNotificationLogTime != 'Off') {
          widget.allNotificationListData.add(localNotificationModel);
        }else{
          widget.allNotificationListData.remove(localNotificationModel);
        }
      }
    } else if (widget.notificationId == 2) {
      if (isDailySelected) {
        exerciseNotificationLogTime = 'Daily';
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            4,
            "BonTriage",
            "Reminder to log your today's exercise.",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else if (isWeekDaysSelected) {
        exerciseNotificationLogTime = 'WeekDay';
        int weekDay = _dateTime.weekday + 1;
        weekDay = weekDay % 7;
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            5,
            'BonTriage',
            "Reminder to log your today's exercise.",
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        exerciseNotificationLogTime = 'Off';
      }

      var exerciseNotificationData = widget.allNotificationListData.firstWhere(
              (element) => element.notificationName == 'Exercise',
          orElse: () => null);
      if (exerciseNotificationData != null) {
        exerciseNotificationData.notificationName = 'Exercise';
        exerciseNotificationData.notificationType = exerciseNotificationLogTime;
        if (exerciseNotificationLogTime == 'Off') {
          exerciseNotificationData.notificationTime = "";
          widget.allNotificationListData.remove(exerciseNotificationData);
        } else {
          exerciseNotificationData.notificationTime =  _dateTime.toIso8601String();
        }
      } else {
        LocalNotificationModel localNotificationModel = LocalNotificationModel();
        localNotificationModel.notificationName = 'Exercise';
        localNotificationModel.notificationType = exerciseNotificationLogTime;
        if (exerciseNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        if(exerciseNotificationLogTime != 'Off') {
          widget.allNotificationListData.add(localNotificationModel);
        }else{
          widget.allNotificationListData.remove(localNotificationModel);
        }
      }
    } else {
      var customNotificationData = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded ?? false,
          orElse: () => null);
      if (customNotificationData != null) {
        customNotificationValue = customNotificationData.notificationName;
      }else{
        customNotificationValue = widget.notificationName;
      }

      print('customNotificationValue???$customNotificationValue');
      if (isDailySelected) {
        customNotificationLogTime = 'Daily';
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            4,
            "BonTriage",
            customNotificationValue,
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else if (isWeekDaysSelected) {
        customNotificationLogTime = 'WeekDay';
        int weekDay = _dateTime.weekday + 1;
        weekDay = weekDay % 7;
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            5,
            'BonTriage',
            customNotificationValue,
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        customNotificationLogTime = 'Off';
      }
      if (customNotificationData != null) {
        customNotificationData.notificationType = customNotificationLogTime;
        if (customNotificationLogTime == 'Off') {
          customNotificationData.notificationTime = "";
          widget.allNotificationListData.remove(customNotificationData);
        } else {
          customNotificationData.notificationTime =  _dateTime.toIso8601String();
        }
      }else {
        LocalNotificationModel localNotificationModel = LocalNotificationModel();
        localNotificationModel.notificationName = widget.notificationName?? 'Custom';
        localNotificationModel.notificationType = customNotificationLogTime;
        localNotificationModel.isCustomNotificationAdded = true;
        if (customNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        if(customNotificationLogTime != 'Off') {
          widget.allNotificationListData.add(localNotificationModel);
        }else{
          widget.allNotificationListData.remove(localNotificationModel);
        }
      }
    }


  }
}
