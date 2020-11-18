import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/LogDayResponseModel.dart';
import 'package:mobile/models/LogDaySendDataModel.dart';
import 'package:mobile/models/MedicationSelectedDataModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LogDayRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class LogDayBloc {
  LogDayRepository _logDayRepository;
  StreamController<dynamic> _logDayDataStreamController;

  List<SelectedAnswers> behaviorSelectedAnswerList = [];
  List<SelectedAnswers> medicationSelectedAnswerList = [];
  List<SelectedAnswers> triggerSelectedAnswerList = [];

  StreamSink<dynamic> get logDayDataSink => _logDayDataStreamController.sink;

  Stream<dynamic> get logDayDataStream => _logDayDataStreamController.stream;

  StreamController<dynamic> _sendLogDayDataStreamController;

  StreamSink<dynamic> get sendLogDayDataSink => _sendLogDayDataStreamController.sink;

  Stream<dynamic> get sendLogDayDataStream => _sendLogDayDataStreamController.stream;

  List<String> eventTypeList = ['behaviors', 'medication', 'triggers'];
  int _currentEventTypeIndex = 0;

  List<Questions> filterQuestionsListData = [];

  LogDayBloc() {
    _logDayDataStreamController = StreamController<dynamic>();
    _sendLogDayDataStreamController = StreamController<dynamic>();
    _logDayRepository = LogDayRepository();
  }

  Future<dynamic> fetchLogDayData() async {
    _logDayRepository.eventType = 'behaviors';
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
    var logDayData = await _logDayRepository.serviceCall(
        WebservicePost.qaServerUrl +
            'logday?mobile_user_id=' +
            userProfileInfoData.userId,
        RequestMethod.GET);
    if (logDayData is AppException) {
      //logDayDataSink.add(logDayData.toString());
      logDayDataSink.addError(logDayData);
    } else {
      if (logDayData is LogDayResponseModel) {
        filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
            logDayData.behaviors.questionnaires[0].initialQuestion,
            logDayData
                .behaviors.questionnaires[0].questionGroups[0].questions));

        filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
            logDayData.medication.questionnaires[0].initialQuestion,
            logDayData
                .medication.questionnaires[0].questionGroups[0].questions));

        filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
            logDayData.triggers.questionnaires[0].initialQuestion,
            logDayData.triggers.questionnaires[0].questionGroups[0].questions));
      }
      /*filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
            logDayData.questionnaires[0].initialQuestion,
            logDayData.questionnaires[0].questionGroups[0].questions));*/
      print(filterQuestionsListData);
      //fetchLogDayData1();
      logDayDataSink.add(filterQuestionsListData);
    }
    } catch (e) {
      logDayDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
    }
  }

  fetchLogDayData1() async {
    _logDayRepository.eventType = 'medication';
    try {
      var logDayData = await _logDayRepository.serviceCall(
          WebservicePost.qaServerUrl + 'questionnaire', RequestMethod.POST);
      if (logDayData is AppException) {
        logDayDataSink.add(logDayData.toString());
      } else {
        filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
            logDayData.questionnaires[0].initialQuestion,
            logDayData.questionnaires[0].questionGroups[0].questions));
        print(filterQuestionsListData);
        fetchLogDayData2();
        //logDayDataSink.add(filterQuestionsListData);
      }
    } catch (e) {
      //  signUpFirstStepDataSink.add("Error");
      print(e.toString());
    }
  }

  fetchLogDayData2() async {
    _logDayRepository.eventType = 'triggers';
    try {
      var logDayData = await _logDayRepository.serviceCall(
          WebservicePost.qaServerUrl + 'questionnaire', RequestMethod.POST);
      if (logDayData is AppException) {
        logDayDataSink.add(logDayData.toString());
      } else {
        filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
            logDayData.questionnaires[0].initialQuestion,
            logDayData.questionnaires[0].questionGroups[0].questions));
        print(filterQuestionsListData);
        //_logDayRepository.insertLogDayData(json.encode(filterQuestionsListData));
        logDayDataSink.add(filterQuestionsListData);
      }
    } catch (e) {
      //  signUpFirstStepDataSink.add("Error");
      print(e.toString());
    }
  }

  Future<List<Map>> getAllLogDayData(String userId) async {
    return await _logDayRepository.getAllLogDayData(userId);
  }

  void dispose() {
    _logDayDataStreamController?.close();
    _sendLogDayDataStreamController?.close();
  }

  Future<String> sendLogDayData(List<SelectedAnswers> selectedAnswers, List<Questions> questionList) async {
    behaviorSelectedAnswerList.clear();
    medicationSelectedAnswerList.clear();
    triggerSelectedAnswerList.clear();
    String payload = await _getLogDaySubmissionPayload(selectedAnswers, questionList);
    String response;
    try {
      var logDaySendData = await _logDayRepository.logDaySubmissionDataServiceCall(WebservicePost.qaServerUrl + 'logday', RequestMethod.POST, payload);
      if (logDaySendData is AppException) {
        print(logDaySendData);
        response = logDaySendData.toString();
        sendLogDayDataSink.addError(logDaySendData);
      } else {
        print(logDaySendData);
        if(logDaySendData != null) {
          response = Constant.success;
        } else {
          sendLogDayDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      response = Constant.somethingWentWrong;
      sendLogDayDataSink.addError(Exception(Constant.somethingWentWrong));
      //  signUpFirstStepDataSink.add("Error");
    }
    return response;
  }

  Future<String> _getLogDaySubmissionPayload(List<SelectedAnswers> selectedAnswers, List<Questions> questionList) async{
    selectedAnswers.forEach((element) {
      List<String> selectedValuesList = [];
      if(element.questionTag.contains('behavior')) {
        SelectedAnswers behaviorSelectedAnswer = behaviorSelectedAnswerList.firstWhere((element1) => element1.questionTag == element.questionTag, orElse: () => null);
        if(behaviorSelectedAnswer == null) {
          try {
            int selectedIndex = int.parse(element.answer.toString()) - 1;
            Questions questions = questionList.firstWhere((quesElement) => quesElement.tag == element.questionTag, orElse: () => null);
            if(questions != null) {
              selectedValuesList.add(questions.values[selectedIndex].text);
              behaviorSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
            }
          } catch(e) {
            print(e);
          }
        } else {
          try {
            selectedValuesList = (json.decode(behaviorSelectedAnswer.answer) as List<dynamic>).cast<String>();
            int selectedIndex = int.parse(element.answer.toString()) - 1;
            Questions questions = questionList.firstWhere((quesElement) => quesElement.tag == element.questionTag, orElse: () => null);
            if(questions != null) {
              selectedValuesList.add(questions.values[selectedIndex].text);
              behaviorSelectedAnswer.answer = jsonEncode(selectedValuesList);
            }
          } catch(e) {
            print(e);
          }
        }
      } else if (element.questionTag.contains('medication') || element.questionTag.contains('administered') || element.questionTag.contains('dosage')) {
        if(element.questionTag == 'administered') {
          MedicationSelectedDataModel medicationSelectedDataModel = MedicationSelectedDataModel.fromJson(jsonDecode(element.answer));
          try {
            int selectedIndex = medicationSelectedDataModel.selectedMedicationIndex;
            Questions selectedMedicationQuestion = questionList.firstWhere((quesElement) => quesElement.tag == 'medication', orElse: () => null);
            if(selectedMedicationQuestion != null) {
              String selectedMedicationValue = selectedMedicationQuestion.values[selectedIndex].text;
              Questions selectedDosageQuestion = questionList.firstWhere((element) => element.precondition.contains(selectedMedicationValue), orElse: () => null);
              if(selectedDosageQuestion != null) {
                medicationSelectedDataModel.selectedMedicationDosageList.forEach((dosageElement) {
                  int selectedDosageIndex = int.parse(dosageElement.toString()) - 1;
                  selectedValuesList.add(selectedDosageQuestion.values[selectedDosageIndex].text);
                });
                medicationSelectedAnswerList.add(SelectedAnswers(questionTag: selectedDosageQuestion.tag, answer: jsonEncode(selectedValuesList)));
              }
            }
            selectedValuesList = [];

            medicationSelectedDataModel.selectedMedicationDateList.forEach((dateElement) {
              selectedValuesList.add(DateTime.parse(dateElement).toUtc().toIso8601String());
            });

            medicationSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
          } catch(e) {
            print(e);
          }
        } else {
          SelectedAnswers medicationSelectedAnswer = medicationSelectedAnswerList.firstWhere((element1) => element1.questionTag == element.questionTag, orElse: () => null);
          if(medicationSelectedAnswer == null) {
            try {
              int selectedIndex = int.parse(element.answer.toString()) - 1;
              Questions questions = questionList.firstWhere((quesElement) => quesElement.tag == element.questionTag, orElse: () => null);
              if(questions != null) {
                selectedValuesList.add(questions.values[selectedIndex].text);
                medicationSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
              }
            } catch(e) {
              print(e);
            }
          } else {
            try {
              selectedValuesList = (json.decode(medicationSelectedAnswer.answer) as List<dynamic>).cast<String>();
              int selectedIndex = int.parse(element.answer.toString()) - 1;
              Questions questions = questionList.firstWhere((quesElement) => quesElement.tag == element.questionTag, orElse: () => null);
              if(questions != null) {
                selectedValuesList.add(questions.values[selectedIndex].text);
                medicationSelectedAnswer.answer = jsonEncode(selectedValuesList);
              }
            } catch(e) {
              print(e);
            }
          }
        }
      } else {
        if (element.questionTag != 'triggers1.travel' && element.questionTag != 'triggers1') {
          SelectedAnswers triggersSelectedAnswer = triggerSelectedAnswerList
              .firstWhere((element1) =>
          element1.questionTag == element.questionTag, orElse: () => null);
          if (triggersSelectedAnswer == null) {
            selectedValuesList.add(element.answer);
            triggerSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
          } else {
            try {
              selectedValuesList =
                  (json.decode(triggersSelectedAnswer.answer) as List<dynamic>)
                      .cast<String>();
              int selectedIndex = int.parse(element.answer.toString()) - 1;
              Questions questions = questionList.firstWhere((
                  quesElement) => quesElement.tag == element.questionTag,
                  orElse: () => null);
              if (questions != null) {
                selectedValuesList.add(questions.values[selectedIndex].text);
                triggersSelectedAnswer.answer = jsonEncode(selectedValuesList);
              }
            } catch (e) {
              print(e);
            }
          }
        } else if (element.questionTag == 'triggers1') {
          SelectedAnswers triggersSelectedAnswer = triggerSelectedAnswerList
              .firstWhere((element1) =>
          element1.questionTag == element.questionTag, orElse: () => null);
          if (triggersSelectedAnswer == null) {
            try {
              int selectedIndex = int.parse(element.answer.toString()) - 1;
              Questions questions = questionList.firstWhere((quesElement) => quesElement.tag == element.questionTag, orElse: () => null);
              if(questions != null) {
                selectedValuesList.add(questions.values[selectedIndex].text);
                triggerSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
              }
            } catch(e) {
              print(e);
            }
          } else {
            try {
              selectedValuesList =
                  (json.decode(triggersSelectedAnswer.answer) as List<dynamic>)
                      .cast<String>();
              int selectedIndex = int.parse(element.answer.toString()) - 1;
              Questions questions = questionList.firstWhere((
                  quesElement) => quesElement.tag == element.questionTag,
                  orElse: () => null);
              if (questions != null) {
                selectedValuesList.add(questions.values[selectedIndex].text);
                triggersSelectedAnswer.answer = jsonEncode(selectedValuesList);
              }
            } catch (e) {
              print(e);
            }
          }
        } else {
          Questions triggerTravelQuestionObj = Questions.fromJson(jsonDecode(element.answer));
          triggerTravelQuestionObj.values.forEach((element) {
            if(element.isSelected) {
              selectedValuesList.add(element.text);
            }
          });
          triggerSelectedAnswerList.add(SelectedAnswers(
              questionTag: element.questionTag,
              answer: jsonEncode(selectedValuesList)));
        }
      }
    });

    LogDaySendDataModel logDaySendDataModel = LogDaySendDataModel();

    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    logDaySendDataModel.behaviors = _getSelectAnswerModel(behaviorSelectedAnswerList, Constant.behaviorsEventType, userProfileInfoData);
    logDaySendDataModel.medication = _getSelectAnswerModel(medicationSelectedAnswerList, Constant.medicationEventType, userProfileInfoData);
    logDaySendDataModel.triggers = _getSelectAnswerModel(triggerSelectedAnswerList, Constant.triggersEventType, userProfileInfoData);

    return jsonEncode(logDaySendDataModel.toJson());
  }

  SignUpOnBoardAnswersRequestModel _getSelectAnswerModel(List<SelectedAnswers> selectedAnswers, String eventType, UserProfileInfoModel userProfileInfoData){
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
    SignUpOnBoardAnswersRequestModel();
    signUpOnBoardAnswersRequestModel.eventType =
        eventType;
    if (userProfileInfoData != null)
      signUpOnBoardAnswersRequestModel.userId =
          int.parse(userProfileInfoData.userId);
    else
      signUpOnBoardAnswersRequestModel.userId = 4214;
    DateTime dateTime = DateTime.now();
    signUpOnBoardAnswersRequestModel.calendarEntryAt = Utils.getDateTimeInUtcFormat(DateTime(dateTime.year, dateTime.month, dateTime.day - 2));
    signUpOnBoardAnswersRequestModel.updatedAt = Utils.getDateTimeInUtcFormat(DateTime.now());
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];

    selectedAnswers.forEach((element) {
      List<String> valuesList =
      (json.decode(element.answer) as List<dynamic>).cast<String>();
      signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
          MobileEventDetails(
              questionTag: element.questionTag,
              questionJson: "",
              updatedAt: Utils.getDateTimeInUtcFormat(DateTime.now()),
              value: valuesList));
    });

    return signUpOnBoardAnswersRequestModel;
  }

  void enterSomeDummyDataToStreamController() {
    logDayDataSink.add(Constant.loading);
  }
}
