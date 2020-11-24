import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/CalendarRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class CalendarScreenBloc {
  CalendarRepository _calendarRepository;
  StreamController<dynamic> _albumStreamController;
  StreamController<dynamic> _triggersStreamController;
  UserLogHeadacheDataCalendarModel _userLogHeadacheDataCalendarModel;
  int count = 0;

  StreamSink<dynamic> get albumDataSink => _albumStreamController.sink;

  Stream<dynamic> get albumDataStream => _albumStreamController.stream;

  StreamSink<dynamic> get triggersDataSink => _triggersStreamController.sink;

  Stream<dynamic> get triggersDataStream => _triggersStreamController.stream;

  List<SignUpHeadacheAnswerListModel> userMonthTriggersData = [];

  CalendarScreenBloc({this.count = 0}) {
    _albumStreamController = StreamController<dynamic>();
    _triggersStreamController = StreamController<dynamic>();
    _calendarRepository = CalendarRepository();
  }

  fetchCalendarTriggersData(String startDateValue, String endDateValue) async {
    String apiResponse;
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'calender/?' +
          "end_calendar_entry_date=" +
          endDateValue +
          "&" +
          "start_calendar_entry_date=" +
          startDateValue +
          "&" +
          "user_id=" +
          userProfileInfoData.userId;
      var response = await _calendarRepository.calendarTriggersServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        apiResponse = response.toString();
      } else {
        if (response is CalendarInfoDataModel) {
          print(response);
          UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel =
              setAllCalendarDataInToModel(response, userProfileInfoData.userId);
          albumDataSink.add(userLogHeadacheDataCalendarModel);

          // apiResponse = response.toString();
        }
      }
    } catch (Exception) {
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  void dispose() {
    _albumStreamController?.close();
    _triggersStreamController?.close();
  }

  UserLogHeadacheDataCalendarModel setAllCalendarDataInToModel(
      CalendarInfoDataModel response, String userId) {
    _userLogHeadacheDataCalendarModel = UserLogHeadacheDataCalendarModel();
    setCalendarHeadacheData(
        response.headache, _userLogHeadacheDataCalendarModel);
    setCalendarLogTriggersData(
        response.triggers, _userLogHeadacheDataCalendarModel);
    _userLogHeadacheDataCalendarModel.userId = userId;
    return _userLogHeadacheDataCalendarModel;
  }

  void setCalendarHeadacheData(List<Headache> headache,
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel) {
    headache.forEach((element) {
      SelectedHeadacheLogDate _selectedHeadacheLogDate =
          SelectedHeadacheLogDate();
      _selectedHeadacheLogDate.formattedDate = element.calendarEntryAt;
      DateTime _dateTime = DateTime.parse(element.calendarEntryAt);
      _selectedHeadacheLogDate.selectedDay = _dateTime.day.toString();

      SelectedDayHeadacheIntensity _selectedDayHeadacheIntensity =
          SelectedDayHeadacheIntensity();
      _selectedDayHeadacheIntensity.selectedDay = _dateTime.day.toString();
      var severityValue = element.mobileEventDetails.firstWhere(
          (element) => element.questionTag == Constant.severityTag,
          orElse: () => null);
      if (severityValue != null) {
        _selectedDayHeadacheIntensity.intensityValue = severityValue.value;
      } else {
        _selectedDayHeadacheIntensity.intensityValue = "0";
      }
      userLogHeadacheDataCalendarModel.addHeadacheIntensityListData
          .add(_selectedDayHeadacheIntensity);
      userLogHeadacheDataCalendarModel.addHeadacheListData
          .add(_selectedHeadacheLogDate);
    });
  }

  void setCalendarLogTriggersData(List<Headache> triggers,
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel) {
    triggers.forEach((element) {
      SelectedHeadacheLogDate _selectedHeadacheLogDate =
          SelectedHeadacheLogDate();
      _selectedHeadacheLogDate.formattedDate = element.calendarEntryAt;
      DateTime _dateTime = DateTime.parse(element.calendarEntryAt);
      _selectedHeadacheLogDate.selectedDay = _dateTime.day.toString();
      if (element.mobileEventDetails.length == 0) {
        userLogHeadacheDataCalendarModel.addLogDayListData
            .add(_selectedHeadacheLogDate);
      } else {
        var triggersElement = element.mobileEventDetails
            .firstWhere((element) => element.questionTag == "triggers1");
        String triggersValues = triggersElement.value;
        List<String> formattedValues = triggersValues.split("%@");
        formattedValues.asMap().forEach((index, element) {
          SignUpHeadacheAnswerListModel signUpHeadacheAnswerListModel =
              SignUpHeadacheAnswerListModel();
          signUpHeadacheAnswerListModel.answerData = element;

          setInitialTriggers(index, signUpHeadacheAnswerListModel);
          _selectedHeadacheLogDate.userTriggersListData
              .add(signUpHeadacheAnswerListModel);
        });
        setAllMonthTriggersData(formattedValues);
        userLogHeadacheDataCalendarModel.addTriggersListData
            .add(_selectedHeadacheLogDate);
      }
    });
  }

  void setAllMonthTriggersData(List<String> formattedValues) {
    formattedValues.forEach((element) {
      SignUpHeadacheAnswerListModel signUpHeadacheAnswerListModel =
          SignUpHeadacheAnswerListModel();
      var filteredTriggersData = userMonthTriggersData.firstWhere(
          (triggersElement) => element == triggersElement.answerData,
          orElse: () => null);
      if (filteredTriggersData == null) {
        signUpHeadacheAnswerListModel.answerData = element;
        if (userMonthTriggersData.length <= 3) {
          setInitialTriggers(
              userMonthTriggersData.length, signUpHeadacheAnswerListModel);
        }
        userMonthTriggersData.add(signUpHeadacheAnswerListModel);
      }
    });

    triggersDataSink.add(userMonthTriggersData);
    print(userMonthTriggersData);
  }

  void setInitialTriggers(
      int index, SignUpHeadacheAnswerListModel signUpHeadacheAnswerListModel) {
    if (index < 3) {
      switch (index) {
        case 0:
          signUpHeadacheAnswerListModel.color =
              Constant.calendarRedTriggerColor;
          signUpHeadacheAnswerListModel.isSelected = true;
          break;
        case 1:
          signUpHeadacheAnswerListModel.color =
              Constant.calendarPurpleTriggersColor;
          signUpHeadacheAnswerListModel.isSelected = true;
          break;
        case 2:
          signUpHeadacheAnswerListModel.color =
              Constant.calendarBlueTriggersColor;
          signUpHeadacheAnswerListModel.isSelected = true;
          break;
      }
    }
  }
}
