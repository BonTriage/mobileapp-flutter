import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/LogDayResponseModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/LogDayRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';

class LogDayBloc {
  LogDayRepository _logDayRepository;
  StreamController<dynamic> _logDayDataStreamController;

  StreamSink<dynamic> get logDayDataSink =>
      _logDayDataStreamController.sink;

  Stream<dynamic> get logDayDataStream =>
      _logDayDataStreamController.stream;

  List<String> eventTypeList = ['behaviors', 'medication',  'triggers'];
  int _currentEventTypeIndex = 0;

  List<Questions> filterQuestionsListData = [];

  LogDayBloc() {
    _logDayDataStreamController = StreamController<dynamic>();
    _logDayRepository = LogDayRepository();
  }

  Future<dynamic> fetchLogDayData() async {
    _logDayRepository.eventType = 'behaviors';
    //try {
      var logDayData = await _logDayRepository.serviceCall(
          'http://34.222.200.187:8080/mobileapi/v0/logday?mobile_user_id=4214',
          RequestMethod.GET);
      if (logDayData is AppException) {
        //logDayDataSink.add(logDayData.toString());
        logDayDataSink.addError(logDayData);
      } else {
        if(logDayData is LogDayResponseModel) {
          filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
              logDayData.behaviors.questionnaires[0].initialQuestion,
              logDayData.behaviors.questionnaires[0].questionGroups[0].questions));

          filterQuestionsListData.addAll(LinearListFilter.getQuestionSeries(
              logDayData.medication.questionnaires[0].initialQuestion,
              logDayData.medication.questionnaires[0].questionGroups[0].questions));

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
    /*} catch (e) {
      //  signUpFirstStepDataSink.add("Error");
      print(e.toString());
    }*/
  }

  fetchLogDayData1() async {
    _logDayRepository.eventType = 'medication';
    try {
      var logDayData = await _logDayRepository.serviceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
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
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
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
  }
}