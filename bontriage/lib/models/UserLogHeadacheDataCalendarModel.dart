import 'CalendarInfoDataModel.dart';
import 'SignUpHeadacheAnswerListModel.dart';

class UserLogHeadacheDataCalendarModel {
  List<SelectedHeadacheLogDate> addHeadacheListData = [];
  List<SelectedHeadacheLogDate> addTriggersListData = [];
  List<SelectedHeadacheLogDate> addLogDayListData = [];
  List<SelectedDayHeadacheIntensity> addHeadacheIntensityListData = [];
  String userId = "";
}

class SelectedHeadacheLogDate {
  String formattedDate;
  String selectedDay;
  List<SignUpHeadacheAnswerListModel> userTriggersListData = [];
}

class SelectedDayHeadacheIntensity {
  String questionTag;
  String intensityValue;
  String selectedDay;
}
