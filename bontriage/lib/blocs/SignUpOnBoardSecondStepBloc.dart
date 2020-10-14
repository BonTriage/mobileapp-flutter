import 'dart:async';
import 'dart:convert';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/SignUpOnBoardSecondStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';

class SignUpOnBoardSecondStepBloc {
  SignUpOnBoardFirstStepRepository _signUpOnBoardFirstStepRepository;
  StreamController<dynamic> __signUpOnBoardSecondStepRepositoryDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpOnBoardSecondStepDataSink =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.sink;

  Stream<dynamic> get signUpOnBoardSecondStepDataStream =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.stream;

  SignUpOnBoardSecondStepBloc({this.count = 0}) {
    __signUpOnBoardSecondStepRepositoryDataStreamController = StreamController<dynamic>();
    _signUpOnBoardFirstStepRepository = SignUpOnBoardFirstStepRepository();
  }

  fetchSignUpOnBoardSecondStepData() async {
    try {
      var signUpFirstStepData =
      await _signUpOnBoardFirstStepRepository.serviceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        signUpOnBoardSecondStepDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpOnBoardSecondStepDataSink.add(filterQuestionsListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }
  fetchDataFromLocalDatabase() async {
    List<LocalQuestionnaire> localQuestionnaireData =
    await SignUpOnBoardProviders.db.getQuestionnaire();
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
        json.decode(localQuestionnaireEventData.selectedAnswers));
  }

  void dispose() {
    __signUpOnBoardSecondStepRepositoryDataStreamController?.close();
  }
}
