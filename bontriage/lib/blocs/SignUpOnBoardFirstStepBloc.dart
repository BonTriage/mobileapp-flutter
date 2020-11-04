import 'dart:async';
import 'dart:convert';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/WelcomeOnBoardProfileModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpOnBoardFirstStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';

class SignUpBoardFirstStepBloc {
  SignUpOnBoardFirstStepRepository _signUpOnBoardFirstStepRepository;
  StreamController<dynamic> _signUpFirstStepDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpFirstStepDataSink =>
      _signUpFirstStepDataStreamController.sink;

  Stream<dynamic> get albumDataStream =>
      _signUpFirstStepDataStreamController.stream;

  SignUpBoardFirstStepBloc({this.count = 0}) {
    _signUpFirstStepDataStreamController = StreamController<dynamic>();
    _signUpOnBoardFirstStepRepository = SignUpOnBoardFirstStepRepository();
  }
// QA Url it will be change.
  fetchSignUpFirstStepData() async {
    try {
      var signUpFirstStepData =
      await _signUpOnBoardFirstStepRepository.serviceCall(
          'http://34.222.200.187:8080/mobileapi/v0/questionnaire',
          RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpFirstStepDataSink.add(filterQuestionsListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  sendSignUpFirstStepData(
      SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel) async {
    try {
      var signUpFirstStepData =
      await _signUpOnBoardFirstStepRepository
          .signUpFirstStepInfoObjectServiceCall(
          'http://34.222.200.187:8080/mobileapi/v0/event',
          RequestMethod.POST, signUpOnBoardSelectedAnswersModel);
      if (signUpFirstStepData is AppException) {
        //signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        /*   var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpFirstStepDataSink.add(filterQuestionsListData);*/
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  void dispose() {
    _signUpFirstStepDataStreamController?.close();
  }

  fetchDataFromLocalDatabase(
      List<LocalQuestionnaire> localQuestionnaireData) async {
    LocalQuestionnaire localQuestionnaireEventData = localQuestionnaireData[0];
    WelcomeOnBoardProfileModel welcomeOnBoardProfileModel =
    WelcomeOnBoardProfileModel();
    welcomeOnBoardProfileModel = WelcomeOnBoardProfileModel.fromJson(
        json.decode(localQuestionnaireEventData.questionnaires));
    var filterQuestionsListData = LinearListFilter.getQuestionSeries(
        welcomeOnBoardProfileModel.questionnaires[0].initialQuestion,
        welcomeOnBoardProfileModel
            .questionnaires[0].questionGroups[0].questions);
    signUpFirstStepDataSink.add(filterQuestionsListData);

    return SignUpOnBoardSelectedAnswersModel.fromJson(
        json.decode(localQuestionnaireEventData.selectedAnswers));
  }
}
