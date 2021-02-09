import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/view/ConsecutiveSelectedDateWidget.dart';
import 'package:mobile/view/DateWidget.dart';

import 'Utils.dart';

class CalendarUtil {
  int calenderType;
  UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel;
  List<String> userLogHeadacheDataList = [];
  List<SignUpHeadacheAnswerListModel> userMonthTriggersListData = [];
  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;

  // calenderType
  // 0- Me Screen
  // 1- Triggers Screen
  // 2- Severity Screen
  CalendarUtil({this.calenderType, this.userLogHeadacheDataCalendarModel,this.userMonthTriggersListData,this.navigateToOtherScreenCallback}) ;



  ///method to draw the month calendar for the month and year passed as arguments.
  ///and it returns the list of widgets which contain the calendar items to draw over screen.
  List<Widget> drawMonthCalendar(
      {int yy = 2020, int mm = 1, int dd = 1, bool drawCurrentMonth = false}) {
    List<Widget> monthData = [];
    List<int> currentWeekConsData = [];
    var _firstDateOfMonth = DateTime.utc(yy, mm, dd);
    var daysInMonth = Utils.daysInCurrentMonth(mm, yy);
    var weekDay =
        _firstDateOfMonth.weekday != 7 ? _firstDateOfMonth.weekday : 0;
    filterSelectedLogAndHeadacheDayList(daysInMonth, currentWeekConsData);

    for (int n = 0, i = 0; n < 37 && i < daysInMonth; n++) {
      List<SignUpHeadacheAnswerListModel> triggersListData = [];
      SelectedDayHeadacheIntensity selectedDayHeadacheIntensity ;
      if(calenderType == 1){
        userLogHeadacheDataCalendarModel.addTriggersListData.firstWhere(
                (element) {
              if (int.parse(element.selectedDay) - 1 == i) {
                triggersListData = element.userTriggersListData;
                return true;
              }
              return false;
            }, orElse: () => null);
      }else if(calenderType == 2){
        selectedDayHeadacheIntensity  = SelectedDayHeadacheIntensity();
        userLogHeadacheDataCalendarModel.addHeadacheIntensityListData.firstWhere(
                (element) {
              if (int.parse(element.selectedDay) - 1 == i) {
                selectedDayHeadacheIntensity.intensityValue = element.intensityValue;
                return true;
              }
              return false;
            }, orElse: () => null);
      }


      if (n < weekDay || n > daysInMonth + weekDay) {
        monthData.add(Container());
      } else {
        if ((currentWeekConsData[i] == 0 || currentWeekConsData[i] == 1) &&
            (n + 1) % 7 != 0) {
          var j = i + 1;
          if (j < daysInMonth &&
              (currentWeekConsData[i] == 0) &&
              (currentWeekConsData[j] == 0)) {
            monthData.add(ConsecutiveSelectedDateWidget(
                weekDateData:_firstDateOfMonth,
                calendarType:calenderType,
                calendarDateViewType:currentWeekConsData[i],
                triggersListData:triggersListData,userMonthTriggersListData:userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity,navigateToOtherScreenCallback: navigateToOtherScreenCallback,));
          } else {
            monthData.add(DateWidget(weekDateData:_firstDateOfMonth,
                calendarType:calenderType,calendarDateViewType: currentWeekConsData[i],triggersListData: triggersListData,userMonthTriggersListData:userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity,navigateToOtherScreenCallback: navigateToOtherScreenCallback,));
          }
          i++;
        } else {
          monthData.add(DateWidget(weekDateData:_firstDateOfMonth,
              calendarType:calenderType,calendarDateViewType: currentWeekConsData[i],triggersListData: triggersListData,userMonthTriggersListData:userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity,navigateToOtherScreenCallback: navigateToOtherScreenCallback,));

          i++;
        }
         _firstDateOfMonth = DateTime(_firstDateOfMonth.year,
            _firstDateOfMonth.month, _firstDateOfMonth.day + 1);
      }
    }
    return monthData;
  }


// 0- Headache Data
  // 1- LogDay Data
  // 2- No Headache and No Log
  void filterSelectedLogAndHeadacheDayList(daysInMonth, List<int> currentWeekConsData) {
      for (int i = 0; i < daysInMonth; i++) {
        var userCalendarData = userLogHeadacheDataCalendarModel
            .addHeadacheListData
            .firstWhere((element) {
          if (int.parse(element.selectedDay) - 1 == i) {
            currentWeekConsData.add(0);
            return true;
          }
          return false;
        }, orElse: () => null);
        if (userCalendarData == null) {
          userLogHeadacheDataCalendarModel.addLogDayListData.firstWhere(
                  (element) {
                if (int.parse(element.selectedDay) - 1 == i) {
                  currentWeekConsData.add(1);
                  return true;
                }
                return false;
              }, orElse: () {
            currentWeekConsData.add(2);
            return null;
          });
        }
        // currentWeekConsData.add(a);
      }


    print(currentWeekConsData);
  }
}
