import 'dart:async';
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/UserHeadacheLogDayDetailsModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/CalendarRepository.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class CalendarHeadacheLogDayDetailsBloc {
  CalendarRepository _calendarRepository;
  StreamController<dynamic> _calendarLogDayStreamController;
  StreamController<dynamic> _networkStreamController;
  UserHeadacheLogDayDetailsModel userHeadacheLogDayDetailsModel =
      UserHeadacheLogDayDetailsModel();
  int count = 0;
  int onGoingHeadacheId;

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
    if(userHeadacheLogDayDetailsModel.headacheLogDayListData != null)
      userHeadacheLogDayDetailsModel.headacheLogDayListData.clear();
    String apiResponse;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'common/?' +
          "date=" +
          selectedDate +
          "&" +
          "user_id=" +
          userProfileInfoData.userId;
      var response = await _calendarRepository.calendarTriggersServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        apiResponse = response.toString();
        networkDataSink.addError(response);
      } else {
        if (response != null && response is CalendarInfoDataModel) {
          print(response);
          getHeadacheLogDayData(response);
          if(userHeadacheLogDayDetailsModel.headacheLogDayListData != null) {
            userHeadacheLogDayDetailsModel.headacheLogDayListData.removeWhere((
                element) => element.imagePath == null);
          }
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
      var headacheOnGoingData = element.mobileEventDetails.firstWhere(
              (mobileEventElement) =>
          mobileEventElement.questionTag == Constant.onGoingTag,
          orElse: () => null);
      var headacheNoteData = element.mobileEventDetails.firstWhere(
          (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.headacheNoteTag,
          orElse: () => null);

      HeadacheData headacheData = HeadacheData();
      headacheData.headacheId = element.id;
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
      if(headacheOnGoingData != null) {
        if(headacheOnGoingData.value.toLowerCase() == 'yes') {
          onGoingHeadacheId = element.id;
          headacheInfo = 'Headache On-Going: Yes';
          if(headacheStartTimeData != null) {
            DateTime startDataTime = DateTime.tryParse(headacheStartTimeData.value);
            if(startDataTime != null) {
              startDataTime = startDataTime;
              headacheInfo = '$headacheInfo\nStart Time: ${Utils.getTimeInAmPmFormat(startDataTime.hour, startDataTime.minute)}';
            }
          }
        } else if (headacheEndTimeData != null && headacheStartTimeData != null) {
          onGoingHeadacheId = null;
          DateTime startDataTime = DateTime.tryParse(headacheStartTimeData.value);
          DateTime endDataTime = DateTime.tryParse(headacheEndTimeData.value);
          Duration headacheTimeDuration = endDataTime.difference(startDataTime);
          headacheInfo = 'Duration: ${_getDisplayTime(headacheTimeDuration.inMinutes.abs())}';
        }
      }
      if (headacheIntensityData != null) {
        headacheInfo =
            '$headacheInfo\nIntensity: ${headacheIntensityData.value}';
      } else {
        headacheInfo = '$headacheInfo\nIntensity: 0';
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

    response.behaviours.asMap().forEach((index, element) {
      if(index == 0) {
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
            List<String> formattedValues = behaviourSleepData.value?.split(
                "%@");
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
      }
    });

    response.medication.asMap().forEach((index, element) {
      if(index == 0) {
        var medicationMobileEvent = element.mobileEventDetails.firstWhere((mobileEventDetailElement) => mobileEventDetailElement.questionTag == Constant.logDayMedicationTag, orElse: () => null);
        if (element.mobileEventDetails.length > 0 && medicationMobileEvent != null) {
          RecordWidgetData logDayMedicationWidgetData = RecordWidgetData();
          logDayMedicationWidgetData.logDayListData = LogDayData();

          var medicationData = element.mobileEventDetails.firstWhere(
                  (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.logDayMedicationTag,
              orElse: () => null);

          var medicationTimeData = element.mobileEventDetails.firstWhere(
                  (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.administeredTag,
              orElse: () => null);

          var medicationDosageData = element.mobileEventDetails.firstWhere(
                  (mobileEventElement) =>
                  mobileEventElement.questionTag.contains(Constant.dotDosage),
              orElse: () => null);

          if (medicationData != null) {
            String titleInfo = medicationData.value;
            if (medicationDosageData != null && medicationTimeData != null) {
              List<String> formattedValues = medicationDosageData.value?.split(
                  "%@");
              List<String> medicationTimeValues = medicationTimeData.value
                  ?.split("%@");
              if (formattedValues != null && medicationTimeValues != null) {
                String medicationDosage = '';
                formattedValues.asMap().forEach((index, medicationElement) {
                  if (medicationDosage.isEmpty) {
                    DateTime medicationDateTime;

                    try {
                      medicationDateTime =
                          DateTime.parse(medicationTimeValues[index]);
                    } catch (e) {
                      print(e);
                    }

                    if (medicationDateTime != null) {
                      medicationElement = _getMedicationDosageUnit(medicationElement);
                      medicationDosage = '$medicationElement at ${Utils.getTimeInAmPmFormat(
                          medicationDateTime.hour, medicationDateTime.minute)}';
                    } else {
                      medicationDosage = '$medicationElement';
                    }
                  } else {
                    DateTime medDateTime;

                    try {
                      medDateTime =
                          DateTime.parse(medicationTimeValues[index]);
                    } catch (e) {
                      print(e);
                    }

                    if (medDateTime != null) {
                      medicationElement = _getMedicationDosageUnit(medicationElement);
                      medicationDosage =
                      '$medicationDosage, $medicationElement at ${Utils
                          .getTimeInAmPmFormat(
                          medDateTime.hour, medDateTime.minute)}';
                    } else {
                      medicationDosage =
                      '$medicationDosage, $medicationElement';
                    }
                  }
                });
                if (medicationDosage.isEmpty) {
                  titleInfo = '$titleInfo';
                } else
                  titleInfo = '$titleInfo\n($medicationDosage)';
              }
            }
            logDayMedicationWidgetData.logDayListData.titleInfo = titleInfo;
          }

          logDayMedicationWidgetData.logDayListData.titleName =
              Constant.medication;
          logDayMedicationWidgetData.imagePath = Constant.pillIcon;
          userHeadacheLogDayDetailsModel.headacheLogDayListData
              .add(logDayMedicationWidgetData);
          userHeadacheLogDayDetailsModel.isDayLogged = true;
        }
      }
    });

    response.triggers.asMap().forEach((index, element) {
      if(index == 0) {
        if (element.mobileEventDetails.length > 0) {
          RecordWidgetData logDayTriggersWidgetData = RecordWidgetData();
          logDayTriggersWidgetData.logDayListData = LogDayData();
          var triggersElement = element.mobileEventDetails.firstWhere(
                  (mobileEventElement) =>
              mobileEventElement.questionTag == Constant.triggersTag,
              orElse: () => null);
          String triggersValues = triggersElement.value;
          List<String> formattedValues = triggersValues.split("%@");
          logDayTriggersWidgetData.logDayListData.titleInfo =
              formattedValues.toString();
          logDayTriggersWidgetData.logDayListData.titleName = 'Triggers';

          logDayTriggersWidgetData.imagePath = Constant.alcoholIcon;
          userHeadacheLogDayDetailsModel.headacheLogDayListData
              .add(logDayTriggersWidgetData);
          userHeadacheLogDayDetailsModel.isDayLogged = true;
        }
      }
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
    networkDataSink.add(Constant.loading);
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

  String _getMedicationDosageUnit(String medicationDosage) {
    if(!(medicationDosage.contains('tablet') || medicationDosage.contains('injection') || medicationDosage.contains('mg') || medicationDosage.contains('ml')))
      return '$medicationDosage mg';
    else
      return medicationDosage;
  }
}
