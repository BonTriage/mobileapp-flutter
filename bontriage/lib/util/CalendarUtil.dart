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
    List<CurrentWeekConsData> currentWeekConsData = [];
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
                selectedDayHeadacheIntensity.isMigraine = element.isMigraine;
                return true;
              }
              return false;
            }, orElse: () => null);
      }


      if (n < weekDay || n > daysInMonth + weekDay) {
        monthData.add(Container());
      } else {
        if ((currentWeekConsData[i].widgetType == 0 || currentWeekConsData[i].widgetType == 1) &&
            (n + 1) % 7 != 0) {

          var j = i + 1;
          if (j < daysInMonth &&
              (currentWeekConsData[i].widgetType == 0) &&
              (currentWeekConsData[j].widgetType == 0) && _checkForConsecutiveHeadacheId(currentWeekConsData[i], currentWeekConsData[j])) {
            monthData.add(ConsecutiveSelectedDateWidget(
                weekDateData:_firstDateOfMonth,
                calendarType:calenderType,
                calendarDateViewType:currentWeekConsData[i].widgetType,
                triggersListData:triggersListData,userMonthTriggersListData:userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity,navigateToOtherScreenCallback: navigateToOtherScreenCallback,));
          } else {
            monthData.add(DateWidget(weekDateData:_firstDateOfMonth,
                calendarType:calenderType,calendarDateViewType: currentWeekConsData[i].widgetType,triggersListData: triggersListData,userMonthTriggersListData:userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity,navigateToOtherScreenCallback: navigateToOtherScreenCallback,));
          }
          i++;
        } else {
          monthData.add(DateWidget(weekDateData:_firstDateOfMonth,
              calendarType:calenderType,calendarDateViewType: currentWeekConsData[i].widgetType,triggersListData: triggersListData,userMonthTriggersListData:userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity,navigateToOtherScreenCallback: navigateToOtherScreenCallback,));

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
  void filterSelectedLogAndHeadacheDayList(daysInMonth, List<CurrentWeekConsData> currentWeekConsDataList) {
      for (int i = 0; i < daysInMonth; i++) {
        var userCalendarData = userLogHeadacheDataCalendarModel
            .addHeadacheListData
            .firstWhere((element) {
          if (int.parse(element.selectedDay) - 1 == i) {
            CurrentWeekConsData currentWeekConsData = CurrentWeekConsData();
            currentWeekConsData.widgetType = 0;
            currentWeekConsData.eventIdList = [];

            print(element.headacheListData);

            if(element.headacheListData != null) {
              element.headacheListData.forEach((headacheElement) {
                currentWeekConsData.eventIdList.add(headacheElement.id);
              });
            }
            currentWeekConsDataList.add(currentWeekConsData);
            return true;
          }
          return false;
        }, orElse: () => null);
        if (userCalendarData == null) {
          userLogHeadacheDataCalendarModel.addLogDayListData.firstWhere(
                  (element) {
                if (int.parse(element.selectedDay) - 1 == i) {
                  CurrentWeekConsData currentWeekConsData = CurrentWeekConsData();
                  currentWeekConsData.widgetType = 1;
                  currentWeekConsData.eventIdList = [];
                  currentWeekConsDataList.add(currentWeekConsData);
                  return true;
                }
                return false;
              }, orElse: () {
            CurrentWeekConsData currentWeekConsData = CurrentWeekConsData();
            currentWeekConsData.widgetType = 2;
            currentWeekConsData.eventIdList = [];
            currentWeekConsDataList.add(currentWeekConsData);
            return null;
          });
        }
        // currentWeekConsData.add(a);
      }


    print(currentWeekConsDataList);
  }

  bool _checkForConsecutiveHeadacheId(CurrentWeekConsData currentWeekConsData1, CurrentWeekConsData currentWeekConsData2) {
    bool isSatisfied = false;

    for (int i = 0; i < currentWeekConsData1.eventIdList.length; i++) {
      int eventId = currentWeekConsData1.eventIdList[i];

      var eventIdElement = currentWeekConsData2.eventIdList.firstWhere((element) => element == eventId, orElse: () => null);

      if(eventIdElement != null) {
        isSatisfied = true;
        break;
      }
    }

    return isSatisfied;
  }
}

class CurrentWeekConsData {
  int widgetType;
  List<int> eventIdList;

  CurrentWeekConsData({this.widgetType, this.eventIdList});
}
