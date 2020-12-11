import 'dart:async';
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/UserHeadacheLogDayDetailsModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/CalendarRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class CalendarHeadacheLogDayDetailsBloc {
  CalendarRepository _calendarRepository;
  StreamController<dynamic> _calendarLogDayStreamController;
  StreamController<dynamic> _networkStreamController;
  UserHeadacheLogDayDetailsModel userHeadacheLogDayDetailsModel =
      UserHeadacheLogDayDetailsModel();
  int count = 0;

  StreamSink<dynamic> get calendarLogDayDataSink =>
      _calendarLogDayStreamController.sink;

  Stream<dynamic> get calendarLogDayDetailsDataStream =>
      _calendarLogDayStreamController.stream;

  Stream<dynamic> get networkDataStream => _networkStreamController.stream;

  StreamSink<dynamic> get networkDataSink => _networkStreamController.sink;

  CalendarHeadacheLogDayDetailsBloc({this.count = 0}) {
    _calendarLogDayStreamController = StreamController<dynamic>();
    _networkStreamController = StreamController<dynamic>();
    _calendarRepository = CalendarRepository();
  }

  fetchCalendarHeadacheLogDayData(String selectedDate) async {
    String apiResponse;
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'common/?' +
          "date=" +
          selectedDate +
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
          getHeadacheLogDayData(response);
          userHeadacheLogDayDetailsModel.headacheLogDayListData.removeWhere((element) => element.imagePath == null);
          calendarLogDayDataSink.add(userHeadacheLogDayDetailsModel);
          networkDataSink.add(Constant.success);
        }
      }
    } catch (e) {
      apiResponse = Constant.somethingWentWrong;
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
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
    _calendarLogDayStreamController?.close();
    _networkStreamController?.close();
  }

  UserHeadacheLogDayDetailsModel getHeadacheLogDayData(
      CalendarInfoDataModel response) {
    RecordWidgetData headacheWidgetData = RecordWidgetData();
    if (response.headache.length > 0 ||
        response.behaviours.length > 0 ||
        response.triggers.length > 0 ||
        response.medication.length > 0 || response.logDayNote.length > 0) {
      userHeadacheLogDayDetailsModel.headacheLogDayListData = [];
      userHeadacheLogDayDetailsModel.isDayLogged = false;
      userHeadacheLogDayDetailsModel.isHeadacheLogged = false;
      headacheWidgetData.headacheListData = [];
      headacheWidgetData.imagePath = Constant.migraineIcon;
    }
    response.headache.forEach((element) {
      var headacheTypeData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.HeadacheTypeTag,
          orElse: () => null);
      var headacheEndTimeData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.endTimeTag,
          orElse: () => null);
      var headacheStartTimeData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.onSetTag,
          orElse: () => null);
      var headacheIntensityData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.severityTag,
          orElse: () => null);
      var headacheDisabilityData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.disabilityTag,
          orElse: () => null);
      var headacheNoteData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.headacheNoteTag,
          orElse: () => null);

      HeadacheData headacheData = HeadacheData();
      String headacheInfo = "";
      if (headacheTypeData != null) {
        headacheData.headacheName = headacheTypeData.value;
      } else {
        headacheData.headacheName = "";
      }
      if (headacheNoteData != null) {
        headacheData.headacheNote = headacheNoteData.value;
      } else {
        headacheData.headacheNote = "";
      }
      if (headacheEndTimeData != null && headacheStartTimeData != null) {
        DateTime startDataTime = DateTime.parse(headacheStartTimeData.value);
        DateTime endDataTime = DateTime.parse(headacheEndTimeData.value);
        Duration headacheTimeDuration = endDataTime.difference(startDataTime);
        headacheInfo = _getDisplayTime(headacheTimeDuration.inMinutes.abs());
      }
      if (headacheIntensityData != null) {
        headacheInfo =
            '$headacheInfo, Intensity: ${headacheIntensityData.value}';
      } else {
        headacheInfo = '$headacheInfo, Intensity: 0';
      }
      if (headacheDisabilityData != null) {
        headacheInfo =
            '$headacheInfo, Disability: ${headacheDisabilityData.value}';
      } else {
        headacheInfo = '$headacheInfo, Disability: 0';
      }
      headacheData.headacheInfo = headacheInfo;
      headacheWidgetData.headacheListData.add(headacheData);
      userHeadacheLogDayDetailsModel.isHeadacheLogged = true;
    });

    if (userHeadacheLogDayDetailsModel.headacheLogDayListData != null)
      userHeadacheLogDayDetailsModel.headacheLogDayListData
          .add(headacheWidgetData);

    response.behaviours.forEach((element) {
      RecordWidgetData logDaySleepWidgetData = RecordWidgetData();
      logDaySleepWidgetData.logDayListData = LogDayData();

      var behaviourPreSleepData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.behaviourPreSleepTag,
          orElse: () => null);
      var behaviourSleepData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.behaviourSleepTag,
          orElse: () => null);
      var behaviourMealData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.behaviourPreMealTag,
          orElse: () => null);

      if (behaviourPreSleepData != null) {
        String titleInfo = behaviourPreSleepData.value;
        if (titleInfo.toLowerCase() == "yes") {
          titleInfo = 'Had a good sleep';
        }
        if (behaviourSleepData != null) {
          List<String> formattedValues = behaviourSleepData.value?.split("%@");
          if (formattedValues != null) {
            formattedValues.forEach((sleepElement) {
              titleInfo = '$titleInfo, $sleepElement';
            });
          }
        }
        logDaySleepWidgetData.logDayListData.titleInfo = titleInfo;
        logDaySleepWidgetData.logDayListData.titleName = "Sleep";
        logDaySleepWidgetData.imagePath = Constant.sleepIcon;
      }
      userHeadacheLogDayDetailsModel.headacheLogDayListData
          .add(logDaySleepWidgetData);

      RecordWidgetData logDayMealWidgetData = RecordWidgetData();
      logDayMealWidgetData.logDayListData = LogDayData();
      if (behaviourMealData != null) {
        String titleMealInfo = behaviourMealData.value;
        if (titleMealInfo.toLowerCase() == "yes") {
          titleMealInfo = 'Regular Meal Times';
        } else {
          titleMealInfo = 'No Meal';
        }
        logDayMealWidgetData.imagePath = Constant.mealIcon;
        logDayMealWidgetData.logDayListData.titleName = "Meal";
        logDayMealWidgetData.logDayListData.titleInfo = titleMealInfo;
      }

      userHeadacheLogDayDetailsModel.headacheLogDayListData
          .add(logDayMealWidgetData);
      userHeadacheLogDayDetailsModel.isDayLogged = true;
    });

    response.medication.forEach((element) {
      RecordWidgetData logDayMedicationWidgetData = RecordWidgetData();
      logDayMedicationWidgetData.logDayListData = LogDayData();

      var medicationData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.logDayMedicationTag,
          orElse: () => null);
      var medicationDosageData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag.contains('.dosage'),
          orElse: () => null);

      if (medicationData != null) {
        String titleInfo = medicationData.value;
        if (medicationDosageData != null) {
          List<String> formattedValues =
              medicationDosageData.value?.split("%@");
          if (formattedValues != null) {
            String medicationDosage = '';
            formattedValues.forEach((medicationElement) {
              if (medicationDosage.isEmpty) {
                medicationDosage = medicationElement;
              } else {
                medicationDosage = '$medicationDosage, $medicationElement';
              }
            });
            titleInfo = '$titleInfo ($medicationDosage)';
          }
        }
        logDayMedicationWidgetData.logDayListData.titleInfo = titleInfo;
      }

      logDayMedicationWidgetData.logDayListData.titleName = Constant.medication;
      logDayMedicationWidgetData.imagePath = Constant.pillIcon;
      userHeadacheLogDayDetailsModel.headacheLogDayListData
          .add(logDayMedicationWidgetData);
      userHeadacheLogDayDetailsModel.isDayLogged = true;
    });

    ///To:Do : Need to Show triggers Data
    response.triggers.forEach((element) {
      userHeadacheLogDayDetailsModel.isDayLogged = true;
    });
    response.logDayNote.forEach((element) {
      var logDayNoteData = element.mobileEventDetails.firstWhere(
              (mobileEventElement) =>
          mobileEventElement.questionTag == Constant.logDayNoteTag,
          orElse: () => null);
      if(logDayNoteData != null)
      userHeadacheLogDayDetailsModel.logDayNote = logDayNoteData.value;
    });

    return userHeadacheLogDayDetailsModel;
  }

  void enterSomeDummyDataToStream() {
    calendarLogDayDataSink.add(Constant.loading);
  }

  String _getDisplayTime(int totalTime) {
    int hours = totalTime ~/ 60;
    int minute = totalTime % 60;

    if (hours < 10) {
      if (minute < 10) {
        return '$hours:0$minute hrs';
      } else {
        return '$hours:$minute hrs';
      }
    } else if (hours < 24) {
      if (minute < 10) {
        return '${hours}hrs 0${minute}m';
      } else {
        return '${hours}hrs ${minute}m';
      }
    } else {
      int days = (hours == 24) ? 1 : hours ~/ 24;
      hours = hours % 24;
      if (minute < 10) {
        return '$days day,$hours:0$minute hrs';
      } else {
        return '$days day,$hours:$minute hrs';
      }
    }
  }
}
