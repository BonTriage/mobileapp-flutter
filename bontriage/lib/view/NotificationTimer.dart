import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/LocalNotificationModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'LocalNotifications.dart';

class NotificationTimer extends StatefulWidget {
  final int selectedNotification;
  final Function(String) selectedTimerValue;
  final Stream localNotificationDataStream;
  final List<LocalNotificationModel> allNotificationListData;
  final Function customNotification;
  final String notificationName;

  NotificationTimer(
      {Key key,
      this.selectedNotification,
      this.selectedTimerValue,
      this.localNotificationDataStream,
      this.customNotification,
        this.notificationName,
      this.allNotificationListData})
      : super(key: key);

  @override
  _NotificationTimerState createState() => _NotificationTimerState();
}

class _NotificationTimerState extends State<NotificationTimer> {
  bool isDailySelected = false;
  bool isWeekDaysSelected = false;
  bool isOffSelected = false;
  DateTime _dateTime;
  int _selectedHour = 0;
  int _selectedMinute = 0;

  String whichButtonSelected;

  String dailyNotificationLogTime = "Off";

  String medicationNotificationLogTime = "Off";

  String exerciseNotificationLogTime = "Off";

  String customNotificationLogTime = "Off";
  LocalNotificationModel localNotificationModel = LocalNotificationModel();

  LocalNotificationModel localNotificationNameModel;

  String customNotificationValue = '';

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _selectedHour = _dateTime.hour;
    _selectedMinute = _dateTime.minute;
    widget.localNotificationDataStream.listen((event) {
      if(event == 'Clicked')
        setAllNotifications();
      else if(event == 'CancelAll') {
        flutterLocalNotificationsPlugin?.cancelAll();
      }
    });
    setInItNotificationData();
    inItNotification();
  }

  @override
  void didUpdateWidget(covariant NotificationTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        widget.selectedTimerValue('Off');
                        if (widget.selectedNotification == 0) {
                          _deleteNotificationChannel(0);
                        } else if(widget.selectedNotification == 1) {
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
                    if (widget.selectedNotification == 3) {
                      widget.customNotification();
                    } else {
                      if (widget.selectedNotification == 0) {
                        _deleteNotificationChannel(0);
                      } else if(widget.selectedNotification == 1) {
                        _deleteNotificationChannel(1);
                      }else{
                        _deleteNotificationChannel(2);
                      }
                    }
                  });
                },
                child: Text(
                  setDeleteOrEditText(),
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
    );
  }

  /// This Method will be use for initialize all android and IOs Plugin and other required variables.
  void inItNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: 1,
                  title: 'BonTriage',
                  body: 'Log Kar diya',
                  payload: 'Reminder to log your day'));
            });
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    Constant.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
  }

  /// This Method will be use to set for Daily, Weekly notification on respective notification section.
  Future<void> notificationSelected(String payload) async {
    var androidDetails = AndroidNotificationDetails(
        "ChannelId", "BonTriage", 'Reminder to log your day',
        importance: Importance.max/*, icon: 'ic_launcher', color: Colors.blue*/);
    var iosDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    if (widget.selectedNotification == 0) {
      if (isDailySelected) {
        dailyNotificationLogTime = 'Daily';
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            0,
            "BonTriage",
            "Reminder to log your day",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else if (isWeekDaysSelected) {
        dailyNotificationLogTime = 'WeekDay';
        int weekDay = _dateTime.weekday + 1;
        weekDay = weekDay % 7;
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            1,
            'BonTriage',
            'Reminder to log your day',
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
        if (customNotificationLogTime == 'Off') {
          dailyLogNotificationData.notificationTime = "";
        } else {
          print("scheduled notification at $_dateTime");
          dailyLogNotificationData.notificationTime =  Utils.getTimeInAmPmFormat(_selectedHour, _selectedMinute);
         }
      } else {
        localNotificationModel.notificationName = 'Daily Log';
        localNotificationModel.notificationType = dailyNotificationLogTime;
        if (dailyNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        widget.allNotificationListData.add(localNotificationModel);
      }
    } else if (widget.selectedNotification == 1) {
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
        } else {
          medicationNotificationData.notificationTime = Utils.getTimeInAmPmFormat(_selectedHour, _selectedMinute);
        }
      } else {
        localNotificationModel.notificationName = 'Medication';
        localNotificationModel.notificationType = medicationNotificationLogTime;
        if (medicationNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        widget.allNotificationListData.add(localNotificationModel);
      }
    } else if (widget.selectedNotification == 2) {
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
        } else {
          exerciseNotificationData.notificationTime =  Utils.getTimeInAmPmFormat(_selectedHour, _selectedMinute);

        }
      } else {
        localNotificationModel.notificationName = 'Exercise';
        localNotificationModel.notificationType = exerciseNotificationLogTime;
        if (exerciseNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        widget.allNotificationListData.add(localNotificationModel);
      }
    } else {
      var customNotificationData = widget.allNotificationListData.firstWhere(
              (element) => element.isCustomNotificationAdded ?? false,
          orElse: () => null);
      if (customNotificationData != null) {
        customNotificationValue = customNotificationData.notificationName;
      }
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
        } else {
          customNotificationData.notificationTime =  Utils.getTimeInAmPmFormat(_selectedHour, _selectedMinute);
        }
      }else {
        localNotificationModel.notificationName = widget.notificationName?? 'Custom';
        localNotificationModel.notificationType = customNotificationLogTime;
        localNotificationModel.isCustomNotificationAdded = true;
        if (customNotificationLogTime == 'Off') {
          localNotificationModel.notificationTime = "";
        } else {
          localNotificationModel.notificationTime = _dateTime.toIso8601String();
        }
        widget.allNotificationListData.add(localNotificationModel);
      }
    }


  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print("onDidReceiveLocalNotification");

    var androidDetails = AndroidNotificationDetails(
        "ChannelId", "BonTriage", 'Bhag Le na',
        importance: Importance.max);
    var iosDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        2,
        "BonTriage",
        "Medication le le na",
        Time(_selectedHour, _selectedMinute),
        notificationDetails);
  }

  /// This Method will be use for Delete Notification from respective Notification Section.
  Future<void> _deleteNotificationChannel(int channelId) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId.toString());
  }

  /// This Method will be use for to set Daily, Weekly Notifications on respective Notifications Section.
  void setAllNotifications() async {
    if (isDailySelected) {
      whichButtonSelected = 'Daily';
    } else if (isWeekDaysSelected) {
      whichButtonSelected = 'WeekDay';
    } else {
      whichButtonSelected = 'Off';
    }
    if (isDailySelected || isWeekDaysSelected) {
      widget.selectedTimerValue('$whichButtonSelected, ${Utils.getTimeInAmPmFormat(_selectedHour, _selectedMinute)}');
      print('Save Ho GYa');
    } else {
      widget.selectedTimerValue(whichButtonSelected);
    }
    await notificationSelected("");

    saveAllNotification();
  }

  /// This Method will be use for save the all Notification Data for the any alarm set by User.
  void saveAllNotification() {
    Future.delayed(Duration(milliseconds: 100), () {
      SignUpOnBoardProviders.db
          .insertUserNotifications(widget.allNotificationListData);
    });
  }

  /// This Method will be use for to set all UI related data whatever user has saved last time on the current screen.
  void setInItNotificationData() {
    if (widget.selectedNotification == 0) {
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
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isWeekDaysSelected = true;
        } else {
          isOffSelected = true;
        }
      }
    } else if (widget.selectedNotification == 1) {
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
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isWeekDaysSelected = true;
        } else {
          isOffSelected = true;
        }
      }
    } else if (widget.selectedNotification == 2) {
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
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isWeekDaysSelected = true;
        } else {
          isOffSelected = true;
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
        } else if (localNotificationNameModel.notificationType == 'WeekDay') {
          isWeekDaysSelected = true;
        } else {
          isOffSelected = true;
        }
      }
    }
  }

  String setDeleteOrEditText() {
    if (widget.selectedNotification == 3) {
      return 'Edit';
    } else
      return 'Delete';
  }
}
