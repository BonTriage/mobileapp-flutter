import 'dart:async';
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/models/OnGoingHeadacheDataModel.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/CalendarRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class CalendarScreenBloc {
  CalendarRepository _calendarRepository;
  StreamController<dynamic> _calendarStreamController;
  StreamController<dynamic> _triggersStreamController;
  StreamController<dynamic> _networkStreamController;
  UserLogHeadacheDataCalendarModel _userLogHeadacheDataCalendarModel;
  int count = 0;
  CurrentUserHeadacheModel currentUserHeadacheModel;

  StreamSink<dynamic> get calendarDataSink => _calendarStreamController.sink;

  Stream<dynamic> get calendarDataStream => _calendarStreamController.stream;

  StreamSink<dynamic> get triggersDataSink => _triggersStreamController.sink;

  Stream<dynamic> get triggersDataStream => _triggersStreamController.stream;

  Stream<dynamic> get networkDataStream => _networkStreamController.stream;

  StreamSink<dynamic> get networkDataSink => _networkStreamController.sink;

  List<SignUpHeadacheAnswerListModel> userMonthTriggersData = [];

  CalendarScreenBloc({this.count = 0}) {
    _calendarStreamController = StreamController<dynamic>.broadcast();
    _triggersStreamController = StreamController<dynamic>.broadcast();
    _networkStreamController  = StreamController<dynamic>.broadcast();
    _calendarRepository = CalendarRepository();
  }

  Future<CurrentUserHeadacheModel> fetchUserOnGoingHeadache() async {
    CurrentUserHeadacheModel currentUserHeadacheModel;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if(userProfileInfoData != null) {
      try{
        String url = '${WebservicePost.qaServerUrl}common/ongoingheadache/${userProfileInfoData.userId}';
        print(url);
        var response = await _calendarRepository.onGoingHeadacheServiceCall(url, RequestMethod.GET);
        if (response is AppException) {
          networkDataSink.addError(response);
        } else {
          print(response);
          if(response != null && response is OnGoingHeadacheDataModel) {
            if(response.isExists) {
              currentUserHeadacheModel = CurrentUserHeadacheModel();
              var headacheStartTimeMobileEventDetail = response.headaches[0].mobileEventDetails.firstWhere((element) => element.questionTag == Constant.onSetTag, orElse: () => null);
              currentUserHeadacheModel.selectedDate = headacheStartTimeMobileEventDetail.value;
              currentUserHeadacheModel.userId = userProfileInfoData.userId;
              currentUserHeadacheModel.headacheId = response.headaches[0].id;
              currentUserHeadacheModel.isOnGoing = true;
              currentUserHeadacheModel.isFromRecordScreen = false;
              await SignUpOnBoardProviders.db.insertUserCurrentHeadacheData(currentUserHeadacheModel);
            }
          } else {
            networkDataSink.addError(Exception(Constant.somethingWentWrong));
            print('67');
          }
        }
      } catch(e) {
        networkDataSink.addError(Exception(Constant.somethingWentWrong));
        print(e);
      }
    }
    return currentUserHeadacheModel;
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
        networkDataSink.addError(response);
      } else {
        if (response != null && response is CalendarInfoDataModel) {
          print(response);
          userMonthTriggersData.clear();
          UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel =  setAllCalendarDataInToModel(response, userProfileInfoData.userId);
          triggersDataSink.add(userMonthTriggersData);
          calendarDataSink.add(userLogHeadacheDataCalendarModel);
          networkDataSink.add(Constant.success);
        }
      }
    } catch (e) {
      apiResponse = Constant.somethingWentWrong;
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e);
    }
    return apiResponse;
  }

  void enterSomeDummyDataToStreamController() {
    networkDataSink.add(Constant.loading);
  }
  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void dispose() {
    _calendarStreamController?.close();
    _triggersStreamController?.close();
    _networkStreamController?.close();
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

      DateTime _dateTime = DateTime.parse(element.calendarEntryAt);

      var userSelectedHeadacheDayData =  userLogHeadacheDataCalendarModel.addHeadacheListData.firstWhere((intensityElementData) => intensityElementData.selectedDay == _dateTime.day.toString(),orElse: ()=> null);

      if(userSelectedHeadacheDayData == null) {
        SelectedHeadacheLogDate _selectedHeadacheLogDate =  SelectedHeadacheLogDate();
        _selectedHeadacheLogDate.formattedDate = element.calendarEntryAt;
        _selectedHeadacheLogDate.headacheListData = [element];
        _selectedHeadacheLogDate.selectedDay = _dateTime.day.toString();
        userLogHeadacheDataCalendarModel.addHeadacheListData.add(_selectedHeadacheLogDate);
      } else {
        userSelectedHeadacheDayData.headacheListData.add(element);
      }


      var userSelectedHeadacheDayIntensityData =  userLogHeadacheDataCalendarModel.addHeadacheIntensityListData.firstWhere((intensityElementData) => intensityElementData.selectedDay == _dateTime.day.toString(),orElse: ()=> null);
      if(userSelectedHeadacheDayIntensityData != null){
        SelectedDayHeadacheIntensity _selectedDayHeadacheIntensity = SelectedDayHeadacheIntensity();
        _selectedDayHeadacheIntensity.selectedDay = _dateTime.day.toString();
        _selectedDayHeadacheIntensity.isMigraine = element.isMigraine;
        var severityValue = element.mobileEventDetails.firstWhere(
                (element) => element.questionTag == Constant.severityTag,
            orElse: () => null);
        if (severityValue != null) {
          if(int.tryParse(userSelectedHeadacheDayIntensityData.intensityValue) < int.tryParse(severityValue.value)){
            userSelectedHeadacheDayIntensityData.intensityValue = severityValue.value;
          }
        }
      }else{
        SelectedDayHeadacheIntensity _selectedDayHeadacheIntensity = SelectedDayHeadacheIntensity();
        _selectedDayHeadacheIntensity.selectedDay = _dateTime.day.toString();
        _selectedDayHeadacheIntensity.isMigraine = element.isMigraine;
        var severityValue = element.mobileEventDetails.firstWhere(
                (element) => element.questionTag == Constant.severityTag,
            orElse: () => null);
        if (severityValue != null) {
          _selectedDayHeadacheIntensity.intensityValue = severityValue.value;
        } else {
          _selectedDayHeadacheIntensity.intensityValue = "0";
        }
        userLogHeadacheDataCalendarModel.addHeadacheIntensityListData.add(_selectedDayHeadacheIntensity);
      }
    });
  }

  void setCalendarLogTriggersData(List<Headache> triggers,
      UserLogHeadacheDataCalendarModel userLogHeadacheDataCalendarModel) {
    if(triggers.length == 0){
      userMonthTriggersData = [];
      triggersDataSink.add(userMonthTriggersData);
    }else{
      triggers.forEach((element) {
        SelectedHeadacheLogDate _selectedHeadacheLogDate =  SelectedHeadacheLogDate();
        _selectedHeadacheLogDate.formattedDate = element.calendarEntryAt;
        DateTime _dateTime = DateTime.parse(element.calendarEntryAt);
        var userSelectedHeadacheDayTriggersData =  userLogHeadacheDataCalendarModel.addTriggersListData.firstWhere((triggersElementData) => triggersElementData.selectedDay == _dateTime.day.toString(),orElse: ()=> null);
           if(userSelectedHeadacheDayTriggersData != null){
             _selectedHeadacheLogDate.selectedDay = _dateTime.day.toString();
             if (element.mobileEventDetails.length == 0) {
               userLogHeadacheDataCalendarModel.addLogDayListData.add(_selectedHeadacheLogDate);
             }else {
               var triggersElement = element.mobileEventDetails.firstWhere((
                   element) => element.questionTag == "triggers1");
               String triggersValues = triggersElement.value;
               List<String> formattedValues = triggersValues.split("%@");
               formattedValues.asMap().forEach((index, element) {
                 SignUpHeadacheAnswerListModel signUpHeadacheAnswerListModel = SignUpHeadacheAnswerListModel();
                 signUpHeadacheAnswerListModel.answerData = element;
                 userSelectedHeadacheDayTriggersData.userTriggersListData.add(signUpHeadacheAnswerListModel);
               });
               setAllMonthTriggersData(formattedValues);
               userLogHeadacheDataCalendarModel.addLogDayListData.add(_selectedHeadacheLogDate);
               //  userSelectedHeadacheDayTriggersData.userTriggersListData.addAll(_selectedHeadacheLogDate);
             }
        }else{
          _selectedHeadacheLogDate.selectedDay = _dateTime.day.toString();
          if (element.mobileEventDetails.length == 0) {
            userLogHeadacheDataCalendarModel.addLogDayListData.add(_selectedHeadacheLogDate);
          } else {
            var triggersElement = element.mobileEventDetails.firstWhere((element) => element.questionTag == "triggers1");
            String triggersValues = triggersElement.value;
            List<String> formattedValues = triggersValues.split("%@");
            formattedValues.asMap().forEach((index, element) {
              SignUpHeadacheAnswerListModel signUpHeadacheAnswerListModel = SignUpHeadacheAnswerListModel();
              signUpHeadacheAnswerListModel.answerData = element;

              setInitialTriggers(index, signUpHeadacheAnswerListModel);
              _selectedHeadacheLogDate.userTriggersListData.add(signUpHeadacheAnswerListModel);
            });
            setAllMonthTriggersData(formattedValues);
            userLogHeadacheDataCalendarModel.addTriggersListData.add(_selectedHeadacheLogDate);
            userLogHeadacheDataCalendarModel.addLogDayListData.add(_selectedHeadacheLogDate);
          }
        }



      });
    }

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
