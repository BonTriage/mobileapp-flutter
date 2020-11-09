import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpOnBoardSecondStepRepository.dart';
import 'package:mobile/repository/SignUpOnBoardThirdStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardThirdStepBloc {
  SignUpOnBoardThirdStepRepository _signUpOnBoardThirdStepRepository;
  StreamController<dynamic>
      __signUpOnBoardThirdStepRepositoryDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpOnBoardThirdStepDataSink =>
      __signUpOnBoardThirdStepRepositoryDataStreamController.sink;

  Stream<dynamic> get signUpOnBoardThirdStepDataStream =>
      __signUpOnBoardThirdStepRepositoryDataStreamController.stream;

  SignUpOnBoardThirdStepBloc({this.count = 0}) {
    __signUpOnBoardThirdStepRepositoryDataStreamController =
        StreamController<dynamic>();
    _signUpOnBoardThirdStepRepository = SignUpOnBoardThirdStepRepository();
  }

  fetchSignUpOnBoardThirdStepData(String argumentsName) async {
    try {
      var signUpFirstStepData =
          await _signUpOnBoardThirdStepRepository.serviceCall(
              'http://34.222.200.187:8080/mobileapi/v0/questionnaire',
              RequestMethod.POST,
              argumentsName);
      if (signUpFirstStepData is AppException) {
        signUpOnBoardThirdStepDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpOnBoardThirdStepDataSink.add(filterQuestionsListData);
      }
    } catch (e) {
      print(e);
    }
  }

  fetchDataFromLocalDatabase(
      List<LocalQuestionnaire> localQuestionnaireData) async {
    LocalQuestionnaire localQuestionnaireEventData = localQuestionnaireData[0];
    SignUpOnBoardSecondStepModel welcomeOnBoardProfileModel =
        SignUpOnBoardSecondStepModel();
    welcomeOnBoardProfileModel = SignUpOnBoardSecondStepModel.fromJson(
        json.decode(localQuestionnaireEventData.questionnaires));
    var filterQuestionsListData = LinearListFilter.getQuestionSeries(
        welcomeOnBoardProfileModel.questionnaires[0].initialQuestion,
        welcomeOnBoardProfileModel
            .questionnaires[0].questionGroups[0].questions);
    signUpOnBoardThirdStepDataSink.add(filterQuestionsListData);

    return SignUpOnBoardSelectedAnswersModel.fromJson(
        json.decode(localQuestionnaireEventData.selectedAnswers));
  }

  void dispose() {
    __signUpOnBoardThirdStepRepositoryDataStreamController?.close();
  }

  sendSignUpThirdStepData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    String apiResponse;
    try {
      var signUpThirdStepData = await _signUpOnBoardThirdStepRepository
          .signUpThirdStepInfoObjectServiceCall(
              'http://34.222.200.187:8080/mobileapi/v0/event',
              RequestMethod.POST,
              signUpOnBoardSelectedAnswersModel);
      if (signUpThirdStepData is AppException) {
        print(signUpThirdStepData);
        apiResponse = signUpThirdStepData.toString();
      } else {
        print(signUpThirdStepData);
        apiResponse = Constant.success;
      }
    } catch (Exception) {
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }
}
