import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class Utils {
  static String getMonthName(int monthNum) {
    String month = '';
    switch (monthNum) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    return month;
  }

  static String getShortMonthName(int monthNum) {
    String month = '';
    switch (monthNum) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sept";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }
    return month;
  }

  static String getTimeInAmPmFormat(int hours, int minutes) {
    String time = '';
    int hrs = hours;
    String hrsString = hours.toString();
    String minString = minutes.toString();
    String amPm = 'AM';

    if (hrs > 12) {
      hrs = hours % 12;
    }

    if(hrs < 10) {
      hrsString = '0$hrs';
    }

    if(minutes < 10) {
      minString = '0$minutes';
    }

    if(hours >= 12) {
      amPm = 'PM';
    }

    time = '$hrsString:$minString $amPm';

    return time;
  }

 static String getStringFromJson(dynamic jsonObject){
    return jsonEncode(jsonObject);
  }

  Map<String,dynamic> _getJsonFromString(String response){
    return json.decode(response);
  }

  static void saveTutorialsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constant.tutorialsState, true);
  }

  // this returns the last date of the month using DateTime
  static int daysInMonth(DateTime date){
    var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
}