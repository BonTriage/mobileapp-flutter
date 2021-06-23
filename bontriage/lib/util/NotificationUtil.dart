import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/main.dart';
import 'package:mobile/models/LocalNotificationModel.dart';
import 'package:mobile/util/constant.dart';

class NotificationUtil {
  static Future<void> notificationSelected(LocalNotificationModel localNotificationModel, DateTime defaultNotificationTime) async {
    var androidDetails = AndroidNotificationDetails(
        "ChannelId", "MigraineMentor", 'Reminder to log your day.',
        importance: Importance.max, icon: 'notification_icon', color: Constant.chatBubbleGreen);
    var iosDetails = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    int _selectedHour = defaultNotificationTime.hour;
    int _selectedMinute = defaultNotificationTime.minute;
    int weekDay = defaultNotificationTime.weekday + 1;
    weekDay = weekDay % 7;

    if (localNotificationModel.notificationName == 'Daily Log') {
      if(localNotificationModel.notificationType == 'Daily') {
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            0,
            "MigraineMentor",
            "Reminder to log your day.",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else if (localNotificationModel.notificationType == 'WeekDay'){
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            1,
            'MigraineMentor',
            'Reminder to log your day.',
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      }
    } else if (localNotificationModel.notificationName == 'Medication') {
      if(localNotificationModel.notificationType == 'Daily') {
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            2,
            "MigraineMentor",
            "Reminder to log your today's medications.",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            3,
            'MigraineMentor',
            "Reminder to log your today's medications.",
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      }
    } else if (localNotificationModel.notificationName == 'Exercise') {
      if(localNotificationModel.notificationType == 'Daily') {
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            4,
            "MigraineMentor",
            "Reminder to log your today's exercise.",
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            5,
            'MigraineMentor',
            "Reminder to log your today's exercise.",
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      }
    } else if (localNotificationModel.isCustomNotificationAdded) {
      if(localNotificationModel.notificationType == 'Daily') {
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            4,
            "MigraineMentor",
            localNotificationModel.notificationName ?? 'Custom',
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      } else {
        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
            5,
            'MigraineMentor',
            localNotificationModel.notificationName ?? 'Custom',
            Day(weekDay),
            Time(_selectedHour, _selectedMinute),
            notificationDetails);
      }
    }
  }
}