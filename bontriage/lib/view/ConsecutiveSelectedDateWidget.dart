import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/DrawHorizontalLine.dart';
import 'package:mobile/view/DateWidget.dart';

class ConsecutiveSelectedDateWidget extends StatelessWidget {
  final String weekDateData;
  final int calendarType;
  final int calendarDateViewType;
  final  List<SignUpHeadacheAnswerListModel> triggersListData;
  final List<SignUpHeadacheAnswerListModel> userMonthTriggersListData ;
  final SelectedDayHeadacheIntensity selectedDayHeadacheIntensity;

  ConsecutiveSelectedDateWidget({this.weekDateData,this.calendarType, this.calendarDateViewType,this.triggersListData,this.userMonthTriggersListData,this.selectedDayHeadacheIntensity});

  @override
  Widget build(BuildContext context) {
    return DrawHorizontalLine(
        painter: HorizontalLinePainter(), child: DateWidget(weekDateData: weekDateData,calendarType: calendarType,calendarDateViewType: calendarDateViewType,triggersListData: triggersListData,userMonthTriggersListData: userMonthTriggersListData,selectedDayHeadacheIntensity: selectedDayHeadacheIntensity));
  }
}
