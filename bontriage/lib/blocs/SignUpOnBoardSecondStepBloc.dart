import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpOnBoardSecondStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardSecondStepBloc {
  SignUpOnBoardFirstStepRepository _signUpOnBoardFirstStepRepository;
  StreamController<dynamic>
      __signUpOnBoardSecondStepRepositoryDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpOnBoardSecondStepDataSink =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.sink;

  Stream<dynamic> get signUpOnBoardSecondStepDataStream =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.stream;

  SignUpOnBoardSecondStepBloc({this.count = 0}) {
    __signUpOnBoardSecondStepRepositoryDataStreamController =
        StreamController<dynamic>();
    _signUpOnBoardFirstStepRepository = SignUpOnBoardFirstStepRepository();
  }

  fetchSignUpOnBoardSecondStepData(String argumentsName) async {
    try {
      var signUpFirstStepData =
          await _signUpOnBoardFirstStepRepository.serviceCall(
              WebservicePost.qaServerUrl + 'questionnaire',
              RequestMethod.POST,
              argumentsName);
      if (signUpFirstStepData is AppException) {
        print(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpOnBoardSecondStepDataSink.add(filterQuestionsListData);
      }
    } catch (e) {
      print(e.toString());
      //  signUpFirstStepDataSink.add("Error");
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
    signUpOnBoardSecondStepDataSink.add(filterQuestionsListData);

    return SignUpOnBoardSelectedAnswersModel.fromJson(
        jsonDecode(localQuestionnaireEventData.selectedAnswers));
  }

  void dispose() {
    __signUpOnBoardSecondStepRepositoryDataStreamController?.close();
  }

  sendSignUpSecondStepData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    String response;
    try {
      var signUpSecondStepData = await _signUpOnBoardFirstStepRepository
          .signUpWelcomeOnBoardSecondStepServiceCall(
              WebservicePost.qaServerUrl + 'event',
              RequestMethod.POST,
              signUpOnBoardSelectedAnswersModel);
      if (signUpSecondStepData is AppException) {
        print(signUpSecondStepData);
        response = signUpSecondStepData.toString();
      } else {
        print(signUpSecondStepData);
        response = Constant.success;
      }
    } catch (Exception) {
      response = Constant.somethingWentWrong;
      //  signUpFirstStepDataSink.add("Error");
    }
    return response;
  }
}
