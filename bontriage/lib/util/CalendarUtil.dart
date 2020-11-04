import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/view/ConsecutiveSelectedDateWidget.dart';
import 'package:mobile/view/DateWidget.dart';

class CalendarUtil {
  int calenderType;

  // calenderType
  // 0- Me Screen
  // 1- Triggers Screen
  // 2- Severity Screen
  CalendarUtil({this.calenderType});

  /// Method to get total no of days in the month
   daysInMonth(int monthNum, int year) {
    List<int> monthLength = new List(12);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum - 1];
  }
  ///method to draw the month calendar for the month and year passed as arguments.
  ///and it returns the list of widgets which contain the calendar items to draw over screen.
  List<Widget> drawMonthCalendar(
      {int yy = 2020, int mm = 1, int dd = 1, bool drawCurrentMonth = false}) {
    List<Widget> monthData = [];
    List<bool> currentWeekConsData = [];
    var _firstDateOfMonth = DateTime.utc(yy, mm, dd);
    var daysInMonth = this.daysInMonth(mm, yy);
    var weekDay =
        _firstDateOfMonth.weekday != 7 ? _firstDateOfMonth.weekday : 0;

    for (int i = 0; i < daysInMonth; i++) {
      Random random = Random();
      currentWeekConsData.add(random.nextBool());
    }

    for (int n = 0, i = 0; n < 37 && i < daysInMonth; n++) {
      if (n < weekDay || n > daysInMonth + weekDay) {
        monthData.add(Container());
      } else {
        if (currentWeekConsData[i] && (n + 1) % 7 != 0 && n < daysInMonth) {
          var j = i + 1;
          if (j < daysInMonth &&
              currentWeekConsData[i] == currentWeekConsData[j]) {
            monthData.add(ConsecutiveSelectedDateWidget(
                _firstDateOfMonth.day.toString(),calenderType));
          } else {
            monthData.add(DateWidget(_firstDateOfMonth.day.toString(),calenderType));
          }
          i++;
        } else {
          monthData.add(DateWidget(_firstDateOfMonth.day.toString(),calenderType));
          i++;
        }
        _firstDateOfMonth = DateTime(_firstDateOfMonth.year,
            _firstDateOfMonth.month, _firstDateOfMonth.day + 1);
      }
    }
    return monthData;
  }



  ///method to find, the given year is a leap year or not
  leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }
}
