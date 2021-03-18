import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/CalendarInfoDataModel.dart';
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
  List<SelectedAnswers> noteSelectedAnswer = [];

  CalendarInfoDataModel calendarInfoModel;

  List<SelectedAnswers> selectedAnswerList;


  StreamSink<dynamic> get logDayDataSink => _logDayDataStreamController.sink;

  Stream<dynamic> get logDayDataStream => _logDayDataStreamController.stream;

  StreamController<dynamic> _sendLogDayDataStreamController;

  StreamSink<dynamic> get sendLogDayDataSink => _sendLogDayDataStreamController.sink;

  Stream<dynamic> get sendLogDayDataStream => _sendLogDayDataStreamController.stream;

  List<Questions> filterQuestionsListData = [];

  DateTime selectedDateTime;

  int behaviorEventId;
  int medicationEventId;
  int triggerEventId;
  int noteEventId;

  LogDayBloc(DateTime selectedDateTime) {
    _logDayDataStreamController = StreamController<dynamic>();
    _sendLogDayDataStreamController = StreamController<dynamic>();
    _logDayRepository = LogDayRepository();
    this.selectedDateTime = selectedDateTime;
  }

  Future<dynamic> fetchLogDayData() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
    var logDayData = await _logDayRepository.serviceCall(
        WebservicePost.qaServerUrl +
            'logday?mobile_user_id=' +
            userProfileInfoData.userId,
        RequestMethod.GET);
    if (logDayData is AppException) {
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
      print(filterQuestionsListData);
      logDayDataSink.add(filterQuestionsListData);
    }
    } catch (e) {
      logDayDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
    }
  }

  fetchCalendarHeadacheLogDayData(String selectedDate) async {
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
      var response = await _logDayRepository.calendarTriggersServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        apiResponse = response.toString();
        logDayDataSink.addError(response.toString());
      } else {
        if (response != null && response is CalendarInfoDataModel) {
          calendarInfoModel = response;
          if(calendarInfoModel.behaviours.length >= 1)
            behaviorEventId = calendarInfoModel.behaviours[0].id;
          if(calendarInfoModel.medication.length >= 1)
            medicationEventId = calendarInfoModel.medication[0].id;
          if(calendarInfoModel.triggers.length >= 1)
            triggerEventId = calendarInfoModel.triggers[0].id;
          if(calendarInfoModel.logDayNote.length >= 1)
            noteEventId = calendarInfoModel.logDayNote[0].id;

          print('id???$behaviorEventId???$medicationEventId???$triggerEventId???$noteEventId');
          await fetchLogDayData();
        } else {
          logDayDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      apiResponse = Constant.somethingWentWrong;
      logDayDataSink.addError(Exception(Constant.somethingWentWrong));
    }
    return apiResponse;
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
    LogDaySendDataModel logDaySendDataModel = LogDaySendDataModel();
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
              Questions selectedDosageQuestion = questionList.firstWhere((element) {
                List<String> splitConditionList = element.precondition.split('=');
                if(splitConditionList.length == 2) {
                  splitConditionList[0] = splitConditionList[0].trim();
                  splitConditionList[1] = splitConditionList[1].trim();

                  return (selectedMedicationValue == splitConditionList[1]);
                } else {
                  return false;
                }
              }, orElse: () => null);
              if(selectedDosageQuestion != null) {
                medicationSelectedDataModel.selectedMedicationDosageList.forEach((dosageElement) {
                  int selectedDosageIndex = int.parse(dosageElement.toString()) - 1;
                  selectedValuesList.add(selectedDosageQuestion.values[selectedDosageIndex].text);
                });
                medicationSelectedAnswerList.add(SelectedAnswers(questionTag: selectedDosageQuestion.tag, answer: jsonEncode(selectedValuesList)));
              } else {
                medicationSelectedDataModel.selectedMedicationDosageList.forEach((dosageElement) {
                  selectedValuesList.add(dosageElement);
                });
                medicationSelectedAnswerList.add(SelectedAnswers(questionTag: '${selectedMedicationValue}_custom.dosage', answer: jsonEncode(selectedValuesList)));
              }
            }
            selectedValuesList = [];

            medicationSelectedDataModel.selectedMedicationDateList.forEach((dateElement) {
              selectedValuesList.add(Utils.getDateTimeInUtcFormat(DateTime.parse(dateElement)));
            });

            medicationSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
          } catch(e) {
            print(e);
          }
        } else {
          if(element.questionTag.contains('custom')) {
            medicationSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: element.answer));
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
        }
      } else if(element.questionTag.contains('triggers1')) {
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
              selectedValuesList = (json.decode(triggersSelectedAnswer.answer) as List<dynamic>).cast<String>();
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
      } else if (element.questionTag == 'logday.note') {
        selectedValuesList.add(element.answer);
        noteSelectedAnswer.add(SelectedAnswers(questionTag: element.questionTag, answer: jsonEncode(selectedValuesList)));
      }
    });

    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    logDaySendDataModel.behaviors = _getSelectAnswerModel(behaviorSelectedAnswerList, Constant.behaviorsEventType, userProfileInfoData, behaviorEventId);
    logDaySendDataModel.medication = _getSelectAnswerModel(medicationSelectedAnswerList, Constant.medicationEventType, userProfileInfoData, medicationEventId);
    logDaySendDataModel.triggers = _getSelectAnswerModel(triggerSelectedAnswerList, Constant.triggersEventType, userProfileInfoData, triggerEventId);
    logDaySendDataModel.note = _getSelectAnswerModel(noteSelectedAnswer, Constant.noteEventType, userProfileInfoData, noteEventId);

    return jsonEncode(logDaySendDataModel.toJson());
  }

  SignUpOnBoardAnswersRequestModel _getSelectAnswerModel(List<SelectedAnswers> selectedAnswers, String eventType, UserProfileInfoModel userProfileInfoData, int eventId){
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel = SignUpOnBoardAnswersRequestModel();
    signUpOnBoardAnswersRequestModel.eventType = eventType;
    if (userProfileInfoData != null)
      signUpOnBoardAnswersRequestModel.userId =
          int.parse(userProfileInfoData.userId);
    else
      signUpOnBoardAnswersRequestModel.userId = 4214;
    DateTime dateTime = DateTime.now();
    if(selectedDateTime == null){
      signUpOnBoardAnswersRequestModel.calendarEntryAt = Utils.getDateTimeInUtcFormat(dateTime);
    }else{
      signUpOnBoardAnswersRequestModel.calendarEntryAt = '${selectedDateTime.year}-${selectedDateTime.month}-${selectedDateTime.day}T00:00:00Z';
    }

    signUpOnBoardAnswersRequestModel.updatedAt = Utils.getDateTimeInUtcFormat(DateTime.now());
    signUpOnBoardAnswersRequestModel.eventId = eventId;
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];

    selectedAnswers.forEach((element) {
      List<String> valuesList =
      (json.decode(element.answer) as List<dynamic>).cast<String>();
      signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
          MobileEventDetails(
              questionTag: element.questionTag,
              /*eventId: eventId,*/
              questionJson: "",
              updatedAt: Utils.getDateTimeInUtcFormat(DateTime.now()),
              value: valuesList));
    });

    return signUpOnBoardAnswersRequestModel;
  }

  List<SelectedAnswers> getSelectedAnswerList(List<SelectedAnswers> doubleTappedSelectedAnswerList) {
    if (selectedAnswerList == null) {
      selectedAnswerList = [];

      if (calendarInfoModel != null) {
        calendarInfoModel.behaviours.forEach((behaviorElement) {
          behaviorElement.mobileEventDetails.forEach((behaviorMobileEventDetailsElement) {
            Questions questions = filterQuestionsListData.firstWhere((questionElement) => questionElement.tag == behaviorMobileEventDetailsElement.questionTag, orElse: () => null);

            String value = behaviorMobileEventDetailsElement.value;
            List<String> valuesList = value.split("%@");
            valuesList.forEach((valueElement) {
              Values selectedValues = questions.values.firstWhere((element) => valueElement == element.text, orElse: () => null);
              selectedAnswerList.add(SelectedAnswers(questionTag: behaviorMobileEventDetailsElement.questionTag, answer: selectedValues.valueNumber, isDoubleTapped: false));
            });
          });
        });

        calendarInfoModel.medication.forEach((medicationElement) {
          MedicationSelectedDataModel medicationSelectedDataModel = MedicationSelectedDataModel();
          var medicationData = medicationElement.mobileEventDetails.firstWhere((element) => element.questionTag == Constant.logDayMedicationTag, orElse: () => null);
          if(medicationData != null) {
            medicationElement.mobileEventDetails.forEach((medicationMobileEventDetailsElement) {
              if(medicationMobileEventDetailsElement.questionTag == Constant.logDayMedicationTag) {
                Questions questions = filterQuestionsListData.firstWhere((questionElement) => questionElement.tag == Constant.logDayMedicationTag, orElse: () => null);
                if(questions != null) {
                  Values medicationValue = questions.values.firstWhere((element) => element.text == medicationMobileEventDetailsElement.value, orElse: () => null);
                  if(medicationValue != null) {
                    medicationSelectedDataModel.selectedMedicationIndex = int.tryParse(medicationValue.valueNumber) - 1;
                    medicationSelectedDataModel.newlyAddedMedicationName = '';
                  } else {
                    medicationSelectedDataModel.selectedMedicationIndex = questions.values.length;
                    medicationSelectedDataModel.isNewlyAdded = true;
                    medicationSelectedDataModel.newlyAddedMedicationName = medicationMobileEventDetailsElement.value;
                  }
                }
              } else if (medicationMobileEventDetailsElement.questionTag == Constant.administeredTag) {
                List<String> dosageTimeList = medicationMobileEventDetailsElement.value.split("%@");
                medicationSelectedDataModel.selectedMedicationDateList = dosageTimeList;
              } else if (medicationMobileEventDetailsElement.questionTag.contains(".dosage")) {
                List<String> dosageList = medicationMobileEventDetailsElement.value.split("%@");
                List<String> dosageStringList = [];
                Questions dosageQuestion = filterQuestionsListData.firstWhere((questionElement) => questionElement.tag == medicationMobileEventDetailsElement.questionTag, orElse: () => null);
                dosageList.forEach((dosageElement) {
                  if(dosageQuestion != null) {
                    Values dosageValue = dosageQuestion.values.firstWhere((dosageValueElement) => dosageValueElement.text == dosageElement, orElse: () => null);
                    if(dosageValue != null) {
                      dosageStringList.add(dosageValue.valueNumber);
                    }
                  } else {
                    dosageStringList.add(dosageElement);
                  }
                });
                medicationSelectedDataModel.selectedMedicationDosageList = dosageStringList;
              }
            });
          }
          medicationSelectedDataModel.isDoubleTapped = false;
          try {
            selectedAnswerList.add(SelectedAnswers(questionTag: Constant.administeredTag, answer: jsonEncode(medicationSelectedDataModel.toJson())));
          } catch (e) {
            print(e);
          }
        });

        calendarInfoModel.triggers.forEach((triggerElement) {
          triggerElement.mobileEventDetails.forEach((triggerMobileEventDetailElement) {
            Questions questions = filterQuestionsListData.firstWhere((questionElement) => questionElement.tag == triggerMobileEventDetailElement.questionTag, orElse: () => null);
            if(triggerMobileEventDetailElement.questionTag == Constant.triggersTag) {
              List<String> triggersSelectedValues = triggerMobileEventDetailElement.value.split("%@");
              triggersSelectedValues.forEach((valueElement) {
                Values selectedValues = questions.values.firstWhere((element) => valueElement == element.text, orElse: () => null);
                selectedAnswerList.add(SelectedAnswers(questionTag: triggerMobileEventDetailElement.questionTag, answer: selectedValues.valueNumber, isDoubleTapped: false));
              });
            } else if (questions.questionType == Constant.QuestionMultiType) {
              List<String> selectedValues = triggerMobileEventDetailElement.value.split("%@");
              selectedValues.forEach((selectedValueElement) {
                Values values = questions.values.firstWhere((element) => element.text == selectedValueElement, orElse: () => null);
                if(values != null) {
                  values.isSelected = true;
                }
              });
              selectedAnswerList.add(SelectedAnswers(questionTag: questions.tag, answer: jsonEncode(questions.toJson()), isDoubleTapped: false));
            } else if (questions.questionType == Constant.QuestionNumberType) {
              selectedAnswerList.add(SelectedAnswers(questionTag: questions.tag, answer: triggerMobileEventDetailElement.value, isDoubleTapped: false));
            } else if (questions.questionType == Constant.QuestionTextType) {
              selectedAnswerList.add(SelectedAnswers(questionTag: questions.tag, answer: triggerMobileEventDetailElement.value, isDoubleTapped: false));
            }
          });
        });

        calendarInfoModel.logDayNote.forEach((logDayNoteElement) {
          MobileEventDetails1 mobileEventDetails1 = logDayNoteElement.mobileEventDetails.firstWhere((element) => element.questionTag == Constant.logDayNoteTag, orElse: () => null);
          if(mobileEventDetails1 != null) {
            selectedAnswerList.add(SelectedAnswers(questionTag: mobileEventDetails1.questionTag, answer: mobileEventDetails1.value));
          }
        });
      }
    }

    selectedAnswerList.forEach((selectedAnswerElement) {
      if(selectedAnswerElement.questionTag == Constant.behaviourPreSleepTag ||
        selectedAnswerElement.questionTag == Constant.behaviourPreExerciseTag ||
        selectedAnswerElement.questionTag == Constant.behaviourPreMealTag ||
        selectedAnswerElement.questionTag == Constant.administeredTag ||
        selectedAnswerElement.questionTag == Constant.triggersTag) {
        var doubleTapSelectedAnswerList = doubleTappedSelectedAnswerList.where((doubleTappedSelectedAnswerElement) => doubleTappedSelectedAnswerElement.questionTag == selectedAnswerElement.questionTag /*&& doubleTappedSelectedAnswerElement.answer == selectedAnswerElement.answer*/);
        //SelectedAnswers doubleTappedSelectedAnswer = doubleTappedSelectedAnswerList.firstWhere((doubleTappedSelectedAnswerElement) => doubleTappedSelectedAnswerElement.questionTag == selectedAnswerElement.questionTag /*&& doubleTappedSelectedAnswerElement.answer == selectedAnswerElement.answer*/, orElse: () => null);
        if(doubleTapSelectedAnswerList != null) {
          doubleTapSelectedAnswerList.forEach((doubleTappedSelectedAnswer) {
            if(doubleTappedSelectedAnswer != null) {
              if(doubleTappedSelectedAnswer.questionTag != Constant.administeredTag) {
                if(doubleTappedSelectedAnswer.answer == selectedAnswerElement.answer) {
                  selectedAnswerElement.isDoubleTapped = true;
                }
              } else {
                print(selectedAnswerElement);
                if(selectedAnswerElement.answer.isNotEmpty && doubleTappedSelectedAnswer.answer.isNotEmpty) {
                  MedicationSelectedDataModel medicationSelectedDataModel = MedicationSelectedDataModel.fromJson(jsonDecode(doubleTappedSelectedAnswer.answer));
                  MedicationSelectedDataModel medicationSelectedDataModel1 = MedicationSelectedDataModel.fromJson(jsonDecode(selectedAnswerElement.answer));
                  if(medicationSelectedDataModel != null && medicationSelectedDataModel1 != null && !medicationSelectedDataModel.isNewlyAdded && !medicationSelectedDataModel1.isNewlyAdded) {
                    if(medicationSelectedDataModel.selectedMedicationIndex == medicationSelectedDataModel1.selectedMedicationIndex) {
                      medicationSelectedDataModel1.isDoubleTapped = true;
                      selectedAnswerElement.answer = jsonEncode(medicationSelectedDataModel1.toJson());
                    }
                  } else if((medicationSelectedDataModel.isNewlyAdded && medicationSelectedDataModel1.isNewlyAdded && (medicationSelectedDataModel.newlyAddedMedicationName == medicationSelectedDataModel1.newlyAddedMedicationName))){
                    medicationSelectedDataModel1.isDoubleTapped = true;
                    selectedAnswerElement.answer = jsonEncode(medicationSelectedDataModel1.toJson());
                  }
                }
              }
            }
          });
        }
      }
    });

    return selectedAnswerList;
  }

  void enterSomeDummyDataToStreamController() {
    logDayDataSink.add(Constant.loading);
  }
}
